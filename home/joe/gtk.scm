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

(load "./palette.scm")

(define-module (sss-gtk)
  #:use-module (gnu)
  #:use-module (sss-palette))

(define-public sss-gtk3-config
  `((gtk-icon-theme-name . "Yaru-sage-dark") (gtk-theme-name unquote
                                                             (cond
                                                               ((equal?
                                                                 sss-palette-ef-cyprus
                                                                 sss-active-palette)
                                                                "Yaru-sage-dark")
                                                               (else
                                                                "Yaru-sage-dark")))
    (gtk-font-name . "Monaspace Neon 11")
    (gtk-key-theme-name . "Emacs")
    (gtk-enable-event-sounds . 0)
    (gtk-cursor-theme-name . "Adwaita")
    (gtk-cursor-theme-size . 32)
    (gtk-enable-input-feedback-sounds . 0)
    (gtk-application-prefer-dark-theme unquote
                                       (cond
                                         ((equal? sss-palette-ef-cyprus
                                                  sss-active-palette)
                                          0)
                                         (else 1)))))

(define-public sss-gtk4-config
  `((gtk-icon-theme-name . "Yaru-sage-dark") (gtk-theme-name unquote
                                                             (cond
                                                               ((equal?
                                                                 sss-palette-ef-cyprus
                                                                 sss-active-palette)
                                                                "Yaru-sage-dark")
                                                               (else
                                                                "Yaru-sage-dark")))
    (gtk-font-name . "Monaspace Neon 11")
    (gtk-enable-event-sounds . 0)
    (gtk-cursor-theme-name . "Adwaita")
    (gtk-cursor-theme-size . 32)
    (gtk-enable-input-feedback-sounds . 0)
    (gtk-application-prefer-dark-theme unquote
                                       (cond
                                         ((equal? sss-palette-ef-cyprus
                                                  sss-active-palette)
                                          0)
                                         (else 1)))))
