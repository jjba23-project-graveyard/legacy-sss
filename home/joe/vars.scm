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

(define-module (sss-vars)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu services)
  )

(define-public  sss-home-vars
  `(("GUIX_LOCPATH" . "$home/.guix-profile/lib/locale")                  
    ("LANG" . "nl_NL.UTF-8")
    ("XDG_CURRENT_DESKTOP" . "sway")
    ("XDG_SESSION_TYPE" . "wayland")
    ("WLR_NO_HARDWARE_CURSORS" . "1")
    ("MOZ_ENABLE_WAYLAND" . "1")
    ("QT_QPA_PLATFORM" . "wayland")
    ("RTC_USE_PIPEWIRE" . "true")
    ("SDL_VIDEODRIVER" . "wayland")
    ("QT_WAYLAND_DISABLE_WINDOWDECORATION" . "1")
    ("_JAVA_AWT_WM_NONREPARENTING" . "1")
    ("LANGUAGE" . "nl_NL")))

(define-public sss-home-vars-service
  (simple-service 'some-useful-env-vars-service
                  home-environment-variables-service-type
                  sss-home-vars))
