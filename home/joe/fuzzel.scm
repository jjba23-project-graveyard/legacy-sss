;;; fuzzel.scm

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
  #:use-module (sss-palette)
  )

(define-public sss-fuzzel-config
  `((font . "Intel One Mono:size=18")
    (terminal . "foot")
    (colors . ((background . (format #f "~add" (sss-get-color 'background)))
               (text . (format #f "~aff" (sss-get-color 'text)))
               (prompt . "bac2deff")
               (placeholder . "7f849cff")
               (input . (format #f "~aff" (sss-get-color 'text)))
               ("match" . "a6e3a1ff")
               (selection . "585b70ff")
               (selection-text . "cdd6f4ff")
               (selection-match . "a6e3a1ff")
               (counter . "7f849cff")
               (border . "a6e3a1ff")
               ))))
