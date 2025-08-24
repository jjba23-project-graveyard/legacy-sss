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

;; ====== Maak file abstractions ======

(define (run-system-script file)
  ($ (list "guile -L ./per-host -L ./src"
           (~ "system/scripts/~a.scm" file))))

(define (notify title message)
  ($ (list (~ "fyi ~a ~a >/dev/null 2>&1" title message))))

;; ====== Maak file tasks ======

(define (update)
  "Update the system and channels."
  ($ '("git pull" "git submodule update --recursive --remote")
     #:join " && ")
  ($ '("guix pull")))


(define (fmt)
  "Format project source code files."
  ($ '("find . -maxdepth 8 -name '*.scm'" "-type f -exec guix style -f {} \\;")
     #:verbose? #t)
  ($ (list "find ~+ -maxdepth 8 -name '*.el'"
           "-type f -exec emacs -Q --batch {} "
           (~ "--eval '~a'" emacs-lisp-indent-cmd) "\\;")
     #:verbose? #t)
  (log-info (gettext "Task was completed successfully!")))

(define (repl)
  "Development REPL."
  (manifest-shell '("guile -L ./src -L ./per-host -L ./system/packages/"
                    "-c '((@ (ares server) run-nrepl-server))'")))

(define (test)
  "Unit tests."
  (manifest-shell '("guile -L ./src -L ./per-host -L ./test"
                    "-c '((@ (veritas runner) run-tests))'")))

(define (nix-packages-install)
  (run-system-script 'install-nix-packages))

(define (npi)
  (nix-packages-install))

(define (nix-profile-upgrade)
  (run-system-script 'update-nix-packages))

(define (npu)
  (nix-profile-upgrade))

(define (default)
  "Default task to be run, list available tasks."
  ($ '("maak --list")))

