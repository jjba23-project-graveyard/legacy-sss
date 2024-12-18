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

(define-module (sss-fuzzel)
  #:use-module (gnu)
  #:use-module (sss-palette))

(define-public sss-fuzzel-colors
  `((background unquote
                (string-drop (format #f "~add"
                                     (sss-get-color 'background)) 1))
    (text unquote
          (string-drop (format #f "~aff"
                               (sss-get-color 'text)) 1))
    (prompt . "bac2deff")
    (placeholder . "7f849cff")
    (input unquote
           (string-drop (format #f "~aff"
                                (sss-get-color 'text)) 1))
    ("match" . "a6e3a1ff")
    (selection . "585b70ff")
    (selection-text . "cdd6f4ff")
    (selection-match . "a6e3a1ff")
    (counter . "7f849cff")
    (border . "a6e3a1ff")))

(define-public sss-fuzzel-config
  `((font . "Monaspace Neon:size=16") (terminal . "foot")
    (icon-theme . "Yaru-sage-dark")
    (list-executables-in-path . "yes")
    (lines . 15)
    (inner-pad . 8)
    (border (radius . 24))
    (colors unquote sss-fuzzel-colors)))
