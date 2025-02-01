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

(define-module (sss mako)
  #:use-module (gnu)
  #:use-module (sss palette))

(begin
  (define* (sss-mako-config #:key sss-active-palette)
    `((sort . "-time") (max-history . 7)
      (on-button-left . dismiss)
      (on-button-right . invoke-default-action)
      (background-color unquote
                        (string-upcase (format #f "~abb"
                                               (sss-get-color
                                                sss-active-palette
                                                'background))))
      (border-color unquote
                    (string-upcase (format #f "~abb"
                                           (sss-get-color sss-active-palette
                                                          'primary))))
      (text-color unquote
                  (string-upcase (format #f "~abb"
                                         (sss-get-color sss-active-palette
                                                        'text))))
      (font . "Adwaita Mono 12")
      (width . 420)
      (icons . 1)
      (default-timeout . 12000)
      (ignore-timeout . 1)
      (border-radius . 10)))
  (export sss-mako-config))
