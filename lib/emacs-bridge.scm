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
  #:use-module (srfi srfi-64))

(begin
  (define* (sss-bridge-emacs #:key active-palette
                             user-name
                             user-full-name
                             user-email
                             user-initials)
    (define sss-bridge-emacs-vars
      `((user-personal-name . ,(format #f "\"~a\"" user-name))
        (user-personal-full-name . ,(format #f "\"~a\"" user-full-name))
        (user-personal-email . ,(format #f "\"~a\"" user-email))
        (user-personal-initials . ,(format #f "\"~a\"" user-initials))
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
    
    (with-output-to-string (lambda ()
                             (display "(setq-default")
                             (for-each (lambda (v)
                                         (display (format #f "\n    ~a ~a"
                                                          (car v)
                                                          (cdr v))))
                                       sss-bridge-emacs-vars)
                             (display ")\n"))))
  (export sss-bridge-emacs))

(test-begin "Emacs bridge tests")
(test-assert "bridge is correctly computes"
  (equal? (string-append "(setq-default\n    user-personal-name \"John\"\n"
                         "    user-personal-full-name \"John Doe\"\n"
                         "    user-personal-email \"john@doe.com\"\n"
                         "    user-personal-initials \"JD\"\n"
                         "    sss-emacs-theme 'ef-bio)\n")
          (sss-bridge-emacs #:active-palette 'ef-dream
                            #:user-name "John"
                            #:user-full-name "John Doe"
                            #:user-email "john@doe.com"
                            #:user-initials "JD")))
(test-end)
