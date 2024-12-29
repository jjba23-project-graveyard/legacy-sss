;;; SSS - Supreme Sexp System

;; Copyright (C) 2024 Josep Jesus Bigorra Algaba

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

(define-module (sss bash)
  #:use-module (gnu)
  #:use-module (gnu home services shells))

(define sss-bash-vars
  `((green . "'\\[\\033[01;32m\\]'") (reset . "'\\[\\033[00m\\]'")))

(define sss-bash-path-appends
  `("${KREW_ROOT:-$HOME/.krew}/bin" "$HOME/.local/bin"))

(define sss-bash-exports
  `((PS1 . "${grn}\"\\u@\\h \\w${GUIX_ENVIRONMENT:+ [env]} λ\"${clr}\"  \"")))

(define-public sss-bash-aliases
  `((".." . "cd ..;pwd") ("..." . "cd ../..;pwd")
    ("...." . "cd ../../..;pwd")
    (c . "clear")
    (h . "history")
    (tree . "tree --dirsfirst -F")
    (mkdir . "mkdir -p -v")
    (ll . "ls -lAh --group-directories-first")
    (l . "ls -lAh --group-directories-first")
    (e . "emacsclient -t")
    (vanilla-emacs . "emacs -Q")
    (fr . "cd ~/Ontwikkeling/Persoonlijk/sss && make fr")
    (sr . "cd ~/Ontwikkeling/Persoonlijk/sss && make sr")
    (jr . "cd ~/Ontwikkeling/Persoonlijk/sss && make jr")
    (scala-dev . "nix develop /home/joe/Ontwikkeling/Persoonlijk/sss/resources/flakes/scala-dev/")
    (haskell-dev . "nix develop /home/joe/Ontwikkeling/Persoonlijk/sss/resources/flakes/haskell-dev/")
    (docker . "podman")
    (docker-compose . "podman-compose")
    (owm . "swaymsg -- output Virtual-1 mode --custom 3840x2400 scale 2")
    (owmp . "swaymsg -- output Virtual-1 mode --custom 3840x2400 scale 3")
    (o1080 . "swaymsg -- output Virtual-1 mode --custom 1920x1080 scale 1")
    (o4k . "swaymsg -- output Virtual-1 mode --custom 3840x2160 scale 2")
    (podman-unix-socket . "podman system service --time=0 unix:///tmp/podman.sock")
    (gui . "sway")
    (find-largest-files . "du -h -x -s -- * | sort -r -h | head -20")))

(define sss-bash-functions
  `((glog . "sudo gzip -d \"$1.gz\" && cat \"$1\"")
    (hgrep . "history | grep \"$1\"")
    (flameshot-bash . "flameshot full -r>\"$1\"")))

(define-public sss-bash-postlude
  `("shopt -s histappend" "eval \"$(fzf --bash)\""
    "source /run/current-system/profile/etc/profile.d/nix.sh"))

(define (serialize-bash-alias a)
  (format #f "\nalias ~a=\"~a\""
          (car a)
          (cdr a)))

(define (serialize-bash-vars v)
  (format #f "\n~a=~a"
          (car v)
          (cdr v)))

(define (serialize-bash-path-appends a)
  (format #f "\nexport PATH=\"~a:$PATH\"" a))

(define (serialize-bash-exports e)
  (format #f "\nexport ~a=~a"
          (car e)
          (cdr e)))

(define (serialize-bash-function f)
  (format #f "\nfunction ~a () {\n\t~a\n}\n\n"
          (car f)
          (cond
            ((list? (cdr f))
             (string-join (cdr f) "\n\t"))
            (else (cdr f)))))

(define-public sss-bash-config
  (append (map (lambda (v)
                 (serialize-bash-vars v)) sss-bash-vars)
          (map (lambda (e)
                 (serialize-bash-exports e)) sss-bash-exports)
          (map (lambda (f)
                 (serialize-bash-function f)) sss-bash-functions)
          (map (lambda (a)
                 (serialize-bash-alias a)) sss-bash-aliases)
          (map (lambda (a)
                 (serialize-bash-path-appends a)) sss-bash-path-appends)
          sss-bash-postlude))

(define-public sss-bash-service
  (simple-service 'sss-fancy-bash home-bash-service-type
                  (home-bash-extension (environment-variables '())
                                       (bashrc `(,(plain-file "bashrc.sh"
                                                              (string-join
                                                               sss-bash-config
                                                               "\n")))))))
