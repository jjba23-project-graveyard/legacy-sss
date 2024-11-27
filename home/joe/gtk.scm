;;; gtk.scm

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
  #:use-module (sss-palette)
  )


(define-public sss-gtk-config
  `((gtk-icon-theme-name . "Delft-Darkest")
    (gtk-theme-name . ,(cond
                        ((equal? sss-palette-ef-cyprus sss-active-palette)
                         "Yaru-sage"
                         )
                        (else "Yaru-sage-dark")
                        ))
    (gtk-font-name . "Liberation Sans 11")
    (gtk-key-theme-name . "Emacs")
    (gtk-enable-event-sounds . 0)
    (gtk-cursor-theme-name . "Yaru")
    (gtk-enable-input-feedback-sounds . 0)
    ))
