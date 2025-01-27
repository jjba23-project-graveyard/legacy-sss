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

;; Code:

;;;
;;; SSS defaults section
;;;

;; set default values for optional `per-host.scm' values
;; which can be overriden on a host-per-host basis

;; system language
(define sss-lang
  "en_US")

;; system timezone
(define sss-timezone
  "Europe/Amsterdam")

;; system keyboard layout
(define sss-keyboard-layout
  "us")

;; caps to control enabled
(define sss-keyboard-caps-to-ctrl
  #t)

;; system hostname
(define sss-hostname
  "gnusystem")

;; location where you cloned SSS Git repository
(define sss-clone-dir
  "$HOME/Ontwikkeling/Persoonlijk/sss")

;; packages that should only be installed in the current host
(define sss-per-host-packages
  '())

;; active system color palette (overridden by per-host)
(define sss-active-palette
  'sss-palette-ef-dream)

;; Nix packages to install
(define sss-nixpkgs
  '("yaml-language-server" "bash-language-server"
    "monaspace"
    "discord"
    "spotify"
    "whatsapp-for-linux"
    "jdt-language-server"
    "nil"
    "black"
    "pyright"
    "marksman"
    "_1password-gui"
    "_1password-cli"
    "stack"
    "sbt"
    "scala_2_13"
    "firefox"
    "thunderbird"
    "postman"
    "vscode-langservers-extracted"
    "nwg-look"
    "krew"
    "mermaid-cli"
    "jetbrains.idea-community"
    "nixfmt"
    "deadnix"
    "awscli"))

;;;
;;; end SSS defaults section
;;;
