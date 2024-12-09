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

(define-module (sss-mako)
  #:use-module (gnu)
  #:use-module (sss-palette)
  )

(define-public sss-mako-config
  `((sort . "-time")
    (max-history . 7)
    (on-button-left . dismiss)
    (on-button-right . invoke-default-action)
    (background-color . ,(string-upcase (format #f "~abb" (sss-get-color 'background))))
    (border-color . ,(string-upcase (format #f "~abb" (sss-get-color 'primary))))
    (text-color . ,(string-upcase (format #f "~abb" (sss-get-color 'text))))
    (font . "Monaspace Neon 10")
    (width . 420)
    (icons . 1)
    (default-timeout . 12000)
    (ignore-timeout . 1)
    (border-radius . 10)
    ))
