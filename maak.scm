;;; SSS - Supreme Sexp System

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; sss is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; sss is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with sss.  If not, see <https://www.gnu.org/licenses/>.

(define-module (maak)
  #:declarative? #t
  #:use-module (maak maak))

;; ====== Maak file constants ======

;; The absolute path to the directory where the main project files will be deployed.
(define deploy-dir
  "/srv/http/jointhefreeworld.org")

;; The main copyright holders of the project.
(define copyright-holders
  '("Josep Bigorra"))

;; The path to the directory where the i18n resources are located.
(define i18n-dir
  "./resources/locale")

;; The text domain for the i18n translations.
(define i18n-textdomain
  "sss")

;; The Emacs Lisp script to run for publishing the manual. 
(define emacs-lisp-manual-publish-cmd
  '(progn (find-file "./docs/manual/en.org")
          (org-html-export-to-html)
          (message "finished publishing SSS manual")))

(define emacs-lisp-indent-cmd
  '(progn (indent-region (point-min)
                         (point-max) nil)
          (untabify (point-min)
                    (point-max))
          (delete-trailing-whitespace)
          (save-buffer)))

;; ====== Maak file prelude ======

;; Specify the directory where the MO file is located
(bindtextdomain i18n-textdomain i18n-dir)
(bind-textdomain-codeset i18n-textdomain "UTF-8")
;; Specify the domain of the MO file
(textdomain i18n-textdomain)
(define G_
  gettext)

;; ====== Maak file abstractions ======

(define (run-system-script file)
  ($ (list "guile -L ./per-host -L ./src"
           (~ "system/scripts/~a.scm" file))))

(define (run-installed-script file)
  ($ (list (~ "sh ~/.local/bin/~a.sh" file))))

(define (notify title message)
  ($ (list (~ "fyi \"~a\" \"~a\" >/dev/null 2>&1" title message))))

;; ====== Maak file tasks ======

(define (update-submodules)
  ($ '("git submodule update --recursive --remote")))

(define (update)
  "Update the system and channels."
  ($ '("git pull"))
  (update-submodules)
  ($ '("guix pull")))

(define (fmt)
  "Format project source code files."
  ($ '("find . -maxdepth 8 -name '*.scm'" "-type f -exec guix style -f {} \\;")
     #:verbose? #t)
  ($ (list "find ~+ -maxdepth 8 -name '*.el'"
           "-type f -exec emacs -Q --batch {} "
           (~ "--eval '~a'" emacs-lisp-indent-cmd) "\\;")
     #:verbose? #t)
  ($ (list "mbake format --config .mbake.toml Makefile")
     #:verbose? #t))

(define (repl)
  "Development REPL."
  (manifest-shell '("guile -L ./src -L ./per-host -L ./system/packages/"
                    "-c '((@ (ares server) run-nrepl-server))'")))

(define (test)
  "Unit tests."
  (manifest-shell '("guile -L ./src -L ./per-host -L ./test"
                    "-c '((@ (veritas runner) run-tests))'")))

(define (nix-packages-install)
  "Install Nix packages for SSS."
  (run-system-script 'install-nix-packages))

(define (npi)
  "`nix-packages-install' alias."
  (nix-packages-install))

(define (nix-packages-update)
  "Update all Nix packages for SSS."
  (run-system-script 'update-nix-packages))

(define (npu)
  "`nix-packages-update' alias."
  (nix-packages-update))

(define (flatpak-packages-install)
  "Install Flatpak packages for SSS."
  (run-system-script 'install-flatpak-packages))

(define (fpi)
  "`flatpak-packages-install' alias."
  (flatpak-packages-install))

(define (flatpak-packages-update)
  "Update all Flatpak packages for SSS."
  ($ '("flatpak update --user -y")))

(define (fpu)
  "`flatpak-packages-update' alias."
  (flatpak-packages-update))

(define (default)
  "Default task to be run, list available tasks."
  ($ '("maak --list")))

(define (document-keybindings-dconf)
  "Write SSS keybinding documentation to dconf."
  (run-system-script 'document-keybindings-dconf))

(define (user-reconfigure user)
  (fmt)
  (test)
  ($ (list "guix home reconfigure " "-L ./per-host -L ./src"
           (~ "./home/~a.scm" user) "--fallback"))
  ($ '("fc-cache -frv >/dev/null 2>&1 &"))
  (run-installed-script 'write-gtk-dconf-settings)
  (run-installed-script 'write-sss-dconf-settings)
  ($ '("herd trigger set-random-wallpaper"))
  (document-keybindings-dconf)
  (log-info (G_ "Task was completed successfully!"))
  (notify (G_ "SSS user-reconfigure")
          (G_ "Task was completed successfully!")))

(define (joe-reconfigure)
  "Re-configure Joe's Guix Home."
  (user-reconfigure 'joe)
  ($ '("hyprctl reload || true")))

(define (jr)
  "`joe-reconfigure' alias."
  (joe-reconfigure))

(define (manon-reconfigure)
  "Re-configure Manon's Guix Home."
  (user-reconfigure 'manon))

(define (mr)
  "`manon-reconfigure' alias."
  (manon-reconfigure))

(define (system-reconfigure)
  "Re-configure the Guix system."
  (fmt)
  (test)
  ($ '("sudo guix system reconfigure"
       "-L ./per-host -L ./system/packages -L ./src" "./system/config.scm"
       "--fallback --on-error=backtrace"))
  ($ '("sudo fc-cache -frv >/dev/null 2>&1 &"))
  (log-info (G_ "Task was completed successfully!"))
  (notify (G_ "SSS system-reconfigure")
          (G_ "Task was completed successfully!")))

(define (sr)
  "`system-reconfigure' alias."
  (system-reconfigure))

(define (store-gc)
  "Clean up unused objects in the Guix store."
  ($ '("sudo guix gc")))

(define (clone-user-repos)
  "Clones user's desired Git repositories."
  (run-system-script 'clone-user-repos))
