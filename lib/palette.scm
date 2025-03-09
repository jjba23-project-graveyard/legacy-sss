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
  #:use-module (gnu)
  #:use-module (srfi srfi-64))

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
             ((eq? palette
                   'sss-palette-ef-autumn)
              sss-palette-ef-autumn)
             ((eq? palette
                   'sss-palette-solarized-light)
              sss-palette-solarized-light)
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

(define-public sss-palette-ef-dream
  `((primary . "#675072") (primary-l . "#b0a0cf")
    (primary-d . "#a0a0cf")
    (text . "#efd5c5")
    (text-l . "#dec4b4")
    (background . "#232025")
    (background-l . "#322f34")))

(define-public sss-palette-ef-bio
  `((primary . "#00552f") (primary-l . "#3fb83f")
    (primary-d . "#0a4425")
    (text . "#dfefe6")
    (text-l . "#cfdfd5")
    (background . "#111111")
    (background-l . "#222522")))

(define-public sss-palette-ef-cyprus
  `((primary . "#b3d19d") (primary-l . "#c4f2af")
    (primary-d . "#557400")
    (text . "#242521")
    (text-l . "#353632")
    (background . "#fcf7ef")
    (background-l . "#f0ece0")))

(define-public sss-palette-ef-autumn
  `((primary . "#7a3b23") (primary-l . "#c0620e")
    (primary-d . "#d0730f")
    (text . "#dfcdcb")
    (text-l . "#cfbcba")
    (background . "#26211d")
    (background-l . "#36322f")))

(define-public sss-palette-solarized-light
  `((primary . "#e89149") (primary-l . "#f5883f")
    (primary-d . "#b7410e")
    (text . "#475d64")
    (text-l . "#586e75")
    (background . "#fdf6e3")
    (background-l . "#eee8d5")))

(define-public sss-palette-heavy-metal
  `((primary . "#b02930") (primary-l . "#f47360")
    (primary-d . "#d56f72")
    (text . "#ffe6d6")
    (text-l . "#efd5c5")
    (background . "#111111")
    (background-l . "#222522")))

(test-begin "sss-palette tests")

;; Test color retrieval
(test-equal "Retrieve primary color from ef-dream palette" "#675072"
            (sss-get-color 'sss-palette-ef-dream
                           'primary))

(test-equal "Retrieve text color from ef-bio palette" "#dfefe6"
            (sss-get-color 'sss-palette-ef-bio
                           'text))

(test-equal "Retrieve background-l color from ef-cyprus palette" "#f0ece0"
            (sss-get-color 'sss-palette-ef-cyprus
                           'background-l))

;; Test default palette selection
(test-equal "Retrieve primary color from default palette (ef-dream)" "#675072"
            (sss-get-color 'unknown-palette
                           'primary))

;; Test sss-hex-to-rgba conversion
(test-equal "Convert hex #ff5733 to rgba" "rgba(255, 87, 51, 1)"
            (sss-hex-to-rgba "#ff5733"))

(test-equal "Convert hex #008080 to rgba with alpha 0.5"
            "rgba(0, 128, 128, 0.5)"
            (sss-hex-to-rgba "#008080"
                             #:alpha 0.5))

(test-end)
