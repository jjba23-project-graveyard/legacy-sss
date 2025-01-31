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

(define-module (sss palette)
  #:use-module (gnu))

;; (sss-hex-to-rgba (sss-get-color sss-active-palette 'bg-main))

(define-public (sss-get-color palette sym)
  (let ((p (cond
             ((eq? palette
                   'sss-palette-ef-dream)
              sss-palette-ef-dream)
             ((eq? palette
                   'sss-palette-ef-bio)
              sss-palette-ef-bio)
             ((eq? palette
                   'sss-palette-heavy-metal)
              sss-palette-heavy-metal)
             ((eq? palette
                   'sss-palette-ef-cyprus)
              sss-palette-ef-cyprus)
             (else sss-palette-ef-dream))))
    (cdr (assoc sym p))))

(begin
  (define (hex-to-decimal n)
    (string->number (string-append "#x" n)))
  (define* (sss-hex-to-rgba hex
                            #:key (alpha 1))
    (let* ((digits (string-drop hex 1))
           (red (hex-to-decimal (string-take digits 2)))
           (green (hex-to-decimal (string-take (string-drop digits 2) 2)))
           (blue (hex-to-decimal (string-drop digits 4))))
      (format #f
              "rgba(~a, ~a, ~a, ~a)"
              red
              green
              blue
              alpha)))
  (export sss-hex-to-rgba))

(define-public sss-palette-ef-bio
  `((primary . "#00552f") (primary-l . "#3fb83f")
    (primary-d . "#0a4425")
    (text . "#cfdfd5")
    (background . "#111111")
    (background-l . "#222522")))

(define-public sss-palette-ef-cyprus
  `((primary . "#b3d19d") (primary-l . "#c4f2af")
    (primary-d . "#557400")
    (text . "#242521")
    (background . "#fcf7ef")
    (background-l . "#f0ece0")))

(define-public sss-palette-ef-dream
  `((primary . "#675072") (primary-l . "#b0a0cf")
    (primary-d . "#a0a0cf")
    (text . "#efd5c5")
    (background . "#232025")
    (background-l . "#322f34")))

(define-public sss-palette-heavy-metal
  `((primary . "#b02930") (primary-l . "#f47360")
    (primary-d . "#d56f72")
    (text . "#efd5c5")
    (background . "#111111")
    (background-l . "#222522")))
