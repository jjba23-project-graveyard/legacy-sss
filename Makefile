# Makefile - installing and working with sss - Supreme Sexp System

# Copyright (C) 2024 Josep Bigorra

# Version: 0.1.0
# Author: Josep Bigorra <jjbigorra@gmail.com>
# Maintainer: Josep Bigorra <jjbigorra@gmail.com>
# URL: https://codeberg.org/jjba23/sss

# sss is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# sss is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with sss.  If not, see <https://www.gnu.org/licenses/>.

# Commentary:

# Makefile for managing sss - Supreme Sexp System
#
# This Makefile provides commands for configuring and managing the sss system,
# including tasks like system reconfiguration, formatting files, and deploying manuals.

# Code:

.PHONY: update system-reconfigure joe-reconfigure manon-reconfigure \
        format jr fr sr mr fmt full-rebuild nix-profile-upgrade \
        publish-manual gc store-gc full-gc shepherd-logs npu \
        clone-user-repos install-nix-packages npi deploy

# Constants

DEPLOY_WWW=/srv/http/jointhefreeworld.org

# Logging and notification helper functions

# sss-log-complete: Logs when a target has finished executing.
define sss-log-complete
	@printf "\n\033[1m>>= $(shell date) - completed work on target %s\033[0m\n" $(1)
endef

# sss-log-starting: Logs when a target starts execution.
define sss-log-starting
	@printf "\n\033[1m>>= $(shell date) - begin working on target: %s...\033[0m\n" $(1)
endef

# sss-log-info: Logs informational messages in custom format with highlight.
define sss-log-info
	@printf "\n\033[1m>>= $(shell date) - info - %s\033[0m\n" $(1)
endef

# sss-notify: Sends desktop notifications (if available).
define sss-notify
	@-notify-send $(1)
endef

# Targets

# update: Updates the Guix system with the latest packages.
update:
	@guix pull

# system-reconfigure: Reconfigures the system using the provided configuration file.
system-reconfigure:
	$(call sss-log-starting,"system-reconfigure")
	@sudo guix system reconfigure ./system/config.scm --fallback
	$(call sss-log-complete,"system-reconfigure")
	$(call sss-notify,"SSS system-reconfigure was successful!")

# joe-reconfigure: Reconfigures Joe's home environment after formatting files.
joe-reconfigure: format
	$(call sss-log-starting,"joe-reconfigure")
	@guix home reconfigure ./home/joe.scm --fallback
	$(call sss-log-complete,"joe-reconfigure")
	$(call sss-notify,"SSS joe-reconfigure was successful!")

# manon-reconfigure: Reconfigures Manon's home environment after formatting files.
manon-reconfigure: format
	$(call sss-log-starting,"manon-reconfigure")
	@guix home reconfigure ./home/manon.scm --fallback
	$(call sss-log-complete,"manon-reconfigure")
	$(call sss-notify,"SSS manon-reconfigure was successful!")

# full-rebuild: Rebuilds the entire system and home environment for Joe.
full-rebuild: format
	$(call sss-log-starting,"full-rebuild")
	@make system-reconfigure
	@make joe-reconfigure
	@sudo fc-cache -rfv
	@fc-cache -rfv
	$(call sss-log-complete,"full-rebuild")

# nix-profile-upgrade: Upgrades Nix packages using a custom Guile script.
nix-profile-upgrade:
	guile --fresh-auto-compile system/scripts/update-nix-packages.scm

# format: Formats Scheme and Emacs Lisp files in the project.
format:
	$(call sss-log-starting,"format")
	-find ~+ -maxdepth 8 -name "*.scm" -type f -exec guix style -f {} \;
	-find ~+ -maxdepth 8 -name "*.el" -type f -exec emacs -Q --batch {} \
		-l $(shell realpath ./lib/emacs/batch-indent.el) -f indent-file \;
	$(call sss-log-complete,"format")

# publish-manual: Generates and publishes the manual from Org files using Emacs.
publish-manual:
	cd docs/Manual/ && emacs -Q --batch \
		-l $(shell realpath ./lib/sss-manual.el) \
		--funcall sss/publish-manual && cd ../../

# Cleans up unused objects in the Guix store.
store-gc:  
	@sudo guix gc

# Performs a full garbage collection across Guix and Nix stores.
full-gc: 
	@-sudo guix system delete-generations 1d
	@-sudo guix gc
	@-nix-store --gc
	@-nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory|/proc)"

# Displays the logs for the Shepherd service manager.
shepherd-logs:  
	cat $(HOME)/.local/state/log/shepherd.log

# clone-user-repos: Clones user repositories using a custom script.
clone-user-repos:
	guile --fresh-auto-compile system/scripts/clone-user-repos.scm

# install-nix-packages: Installs Nix packages using a custom script.
install-nix-packages:
	guile --fresh-auto-compile system/scripts/install-nix-packages.scm

# install-nix-package-shortcuts: Copies .desktop files for installed applications.
install-nix-package-shortcuts:
	cp -rfv $(HOME)/.nix-profile/share/applications/*.desktop \
		$(HOME)/.local/share/applications/

# Aliases for common tasks

jr:  # Alias for joe-reconfigure
	@make joe-reconfigure

mr:  # Alias for manon-reconfigure
	@make manon-reconfigure

sr:  # Alias for system-reconfigure
	@make system-reconfigure

fr:  # Alias for full-rebuild
	@make full-rebuild

gc:  # Deletes old generations (1 day or older).
	@sudo guix system delete-generations 1d

npu:  # Alias for nix-profile-upgrade
	@make nix-profile-upgrade

fmt:  # Alias for format
	@make format

npi:  # Installs Nix packages and updates application shortcuts.
	@make install-nix-packages
	@make install-nix-package-shortcuts

# install-nix-package-shortcuts: Copies .desktop files for installed applications.
nps:
	@make install-nix-package-shortcuts

# deploy: Deploys the manual HTML to a web server directory.
deploy:
	mkdir -pv $(DEPLOY_WWW)/manuals/sss
	rm -rfv $(DEPLOY_WWW)/manuals/sss/index.html
	cp -rfv docs/Manual/README.html $(DEPLOY_WWW)/manuals/sss/index.html
