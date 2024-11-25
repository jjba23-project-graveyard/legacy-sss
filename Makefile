# Makefile - installing and working with sss - Supreme Sexp System

# Copyright (C) 2024 Josep Bigorra

# Version: 0.1.0
# Author: Josep Bigorra <jjbigorra@gmail.com>
# Maintainer: Josep Bigorra <jjbigorra@gmail.com>
# URL: https://github.com/jjba23/sss

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

# TODO

# Code:


define sss-log-complete
	@printf "\n\033[1m>>= $(shell date) - completed work on target %s\033[0m\n" $(1)
endef

define sss-log-starting
	@printf "\n\033[1m>>= $(shell date) - begin working on target: %s...\033[0m\n" $(1)
endef

define sss-log-info
	@printf "\n\033[1m>>= $(shell date) - info - %s\033[0m\n" $(1)
endef

update:
	@guix pull
system-reconfigure:
	$(call sss-log-starting,"system-reconfigure")
	@sudo guix system reconfigure config.scm --fallback
	$(call sss-log-complete,"system-reconfigure")
joe-reconfigure:
	$(call sss-log-starting,"joe-reconfigure")
	@guix home reconfigure home/joe/home.scm  --fallback
	$(call sss-log-complete,"joe-reconfigure")
manon-reconfigure:
	$(call sss-log-starting,"manon-reconfigure")
	@guix home reconfigure home/manon/home.scm  --fallback
	$(call sss-log-complete,"manon-reconfigure")
full-rebuild:
	$(call sss-log-starting,"full-rebuild")
	@make system-reconfigure
	@make joe-reconfigure
	@sudo fc-cache -r
	@fc-cache -r
	$(call sss-log-complete,"full-rebuild")
nix-profile-upgrade:
	NIXPKGS_ALLOW_UNFREE=1 nix profile upgrade '.*' --impure
	echo -e "$(shell date +%s)" | cat - resources/sss-state/nixpkgs-updated-at | tee resources/sss-state/nixpkgs-updated-at


# Aliases section
jr:
	@make joe-reconfigure
mr:
	@make manon-reconfigure
sr:
	@make system-reconfigure
fr:
	@make full-rebuild
gc:
	@sudo guix system delete-generations 3d
store-gc:
	@sudo guix gc
shepherd-logs:
	cat ~/.local/state/log/shepherd.log
npu:
	@make nix-profile-upgrade
