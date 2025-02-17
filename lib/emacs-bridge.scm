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

;; (load "./palette.scm")

(define-module (sss bridge emacs)
  #:use-module (gnu)
  ;; #:use-module (sss palette)
  )

;; TODO pass here more variables from per-host and SSS
(begin
  (define* (sss-bridge-emacs-vars #:key sss-active-palette)
    `((sss-emacs-theme unquote
                       (cond
                        ((equal? sss-active-palette
                                 'sss-palette-ef-dream)
                         "'ef-dream")
                        ((equal? sss-active-palette
                                 'sss-palette-ef-cyprus)
                         "'ef-cyprus")
                        ((equal? sss-active-palette
                                 'sss-palette-ef-autumn)
                         "'ef-autumn")
                        ((equal? sss-active-palette
                                 'sss-palette-heavy-metal)
                         "'ef-tritanopia-dark")
                        ((equal? sss-active-palette
                                 'sss-palette-solarized-light)
                         "'solarized-light")
                        (else "'ef-bio")))))
  (export sss-bridge-emacs-vars))

(begin
  (define* (sss-bridge-emacs #:key sss-active-palette)
    (with-output-to-string (lambda ()
                             (display "(setq ")
                             (for-each (lambda (v)
                                         (display (format #f "~a ~a\n"
                                                          (car v)
                                                          (cdr v))))
                                       (sss-bridge-emacs-vars
                                        #:sss-active-palette
                                        sss-active-palette))
                             (display ")"))))
  (export sss-bridge-emacs))
