;;; SSS - Supreme Sexp System

;; Copyright (C) 2025 - Josep Bigorra, jjba23 <jjbigorra@gmail.com>

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

(use-modules (ice-9 popen)
             (ice-9 textual-ports))

(define-public (syscall cmd)
  (let* ((process (open-input-pipe cmd))
         (process-output (get-string-all process)))
    (close-pipe process)
    (display process-output) process-output))

(define sss-joe-clone-repos
  (list "private-notes"
        ;; "sss"
        "jointhefreeworld"
        "wikimusic-ssr"
        "wikimusic-api"
        "wolk-jjba"
        "zzspec"
        "byggsteg"
        "rephs"
        "welkomscherm.el"
        "free-alacarte"
        "scala-rank"
        "cloud-infra"
        "yggdrasil-schema"
        "modusregel"
        "keuringsdienst"
        "tekengrootte.el"
        "git-riddance.el"
        "hsresumebuilder"
        "wikimusic-api-spec"
        "wikimusic-model-hs"
        "yak"
        "social-media-jjba"
        "carvoeiro-water-fun"))

(display "\n>>= cloning personal repos...\n")

(for-each (lambda (x)
            (syscall (format #f
                      "[ -d $HOME/Ontwikkeling/Persoonlijk/~a ] || git clone git@codeberg.org:jjba23/~a.git $HOME/Ontwikkeling/Persoonlijk/~a"
                      x x x))) sss-joe-clone-repos)
