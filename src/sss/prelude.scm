;;; SSS - Supreme Sexp System

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

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

(define-module (sss prelude)
  #:use-module (sss defaults)
  #:use-module (sss overrides)
  #:export (log-exprs get-setting))

(define-syntax-rule (log-exprs exp ...)
  (begin
    (format #t "~a: ~S\n"
            'exp exp) ...))

(define (get-setting setting)
  (let* ((sss-default-var-name (format #f "sss-default-~a" setting))
         (sss-default (module-variable (resolve-module '(sss defaults))
                                       (string->symbol sss-default-var-name)))
         (user-override-var-name (format #f "sss-override-~a" setting))
         (user-override (module-variable (resolve-module '(sss overrides))
                                         (string->symbol
                                          user-override-var-name))))
    (display (format #f "sss-default: ~a: ~a" sss-default-var-name sss-default))
    (newline)
    (display (format #f "user-override: ~a: ~a" user-override-var-name
                     user-override))
    (newline)
    (catch #t
           (lambda ()
             (if (equal? #f user-override)
                 (variable-ref sss-default)
                 (variable-ref user-override)))
           (lambda (key . args)
             (variable-ref sss-default)))))

(get-setting 'lang)
(get-setting 'hyprland-extra-startups)
(get-setting 'hostname)
