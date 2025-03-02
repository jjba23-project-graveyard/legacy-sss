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
  (define* (sss-bridge-emacs-vars #:key active-palette
                                  user-name
                                  user-full-name
                                  user-email
                                  user-initials)
    `((user-personal-name unquote user-name)
      (user-personal-full-name unquote user-full-name)
      (user-personal-email unquote user-email)
      (user-personal-initials unquote user-initials)
      (sss-emacs-theme unquote
                       (cond
                         ((equal? active-palette
                                  'sss-palette-ef-dream)
                          "'ef-dream")
                         ((equal? active-palette
                                  'sss-palette-ef-cyprus)
                          "'ef-cyprus")
                         ((equal? active-palette
                                  'sss-palette-ef-autumn)
                          "'ef-autumn")
                         ((equal? active-palette
                                  'sss-palette-heavy-metal)
                          "'ef-tritanopia-dark")
                         ((equal? active-palette
                                  'sss-palette-solarized-light)
                          "'solarized-light")
                         (else "'ef-bio")))))
  (export sss-bridge-emacs-vars))

(begin
  (define* (sss-bridge-emacs #:key active-palette
                             user-name
                             user-full-name
                             user-email
                             user-initials)
    (with-output-to-string (lambda ()
                             (display "(setq-default ")
                             (for-each (lambda (v)
                                         (display (format #f "~a ~a\n"
                                                          (car v)
                                                          (cdr v))))
                                       (sss-bridge-emacs-vars #:active-palette
                                                              active-palette))
                             (display ")"))))
  (export sss-bridge-emacs))
