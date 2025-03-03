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

(define-module (sss fish)
  #:use-module (gnu))

(define (serialize-fish-abbreviation a)
  (format #f "abbr -a ~a \"~a\""
          (car a)
          (cdr a)))

(define* (sss-fish-abbreviations #:key sss-clone-dir)
  `((c . "clear") (h . "history")
    (tree . "tree --dirsfirst -F")
    (mkdir . "mkdir -p -v")
    (ll . "ls -lAh --group-directories-first")
    (l . "ls -lAh --group-directories-first")
    (e . "emacsclient -t")
    (vanilla-emacs . "emacs -Q")
    (fr unquote
        (format #f "cd ~a && make fr" sss-clone-dir))
    (sr unquote
        (format #f "cd ~a && make sr" sss-clone-dir))
    (jr unquote
        (format #f "cd ~a && make jr" sss-clone-dir))
    (pm unquote
        (format #f "cd ~a && make publish-manual" sss-clone-dir))
    (npi unquote
         (format #f "cd ~a && make npi" sss-clone-dir))
    (npu unquote
         (format #f "cd ~a && make npu" sss-clone-dir))
    (fpi unquote
         (format #f "cd ~a && make fpi" sss-clone-dir))
    (fpu unquote
         (format #f "cd ~a && make fpu" sss-clone-dir))
    (scala-dev unquote
               (format #f "nix develop ~a/resources/flakes/scala-dev/"
                       sss-clone-dir))
    (haskell-dev unquote
                 (format #f "nix develop ~a/resources/flakes/haskell-dev/"
                         sss-clone-dir))
    (docker . "podman")
    (docker-compose . "podman-compose")
    (ofmw . "swaymsg -- output eDP-1 scale 1.5")
    (owm . "swaymsg -- output Virtual-1 mode --custom 3840x2400 scale 2")
    (o1080 . "swaymsg -- output Virtual-1 mode --custom 1920x1080 scale 1")
    (o4k . "swaymsg -- output Virtual-1 mode --custom 3840x2160 scale 2")
    (podman-unix-socket . "podman system service --time=0 unix:///tmp/podman.sock")
    (gui . "sway")
    (find-largest-files . "du -h -x -s -- * | sort -r -h | head -20")))

(begin
  (define* (sss-fish-config #:key sss-clone-dir)
    (append `("#
# SSS - Supreme Sexp System - fish configurations
#
"
              ;; turn on the Emacs-style keybindings for the shell
              "fish_default_key_bindings")
            ;; abbreviations (a much better approach than aliases)
            (map serialize-fish-abbreviation
                 (sss-fish-abbreviations #:sss-clone-dir sss-clone-dir))))
  (export sss-fish-config))

(begin
  (define* (sss-fish-config-service #:key sss-clone-dir)
    (string-join (sss-fish-config #:sss-clone-dir sss-clone-dir) "\n"))
  (export sss-fish-config-service))

