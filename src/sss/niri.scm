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

(define-module (sss niri)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss palette)
  #:use-module (sss prelude)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-13)
  #:export (niri-config niri-capability
                        rule
                        make-rule
                        rule?
                        rule-selector
                        rule-declarations
                        set-rule-selector!
                        declaration
                        make-declaration
                        declaration?
                        declaration-property
                        declaration-value
                        rul
                        dec))

(define-record-type rule
  (make-rule selector declarations) rule?
  (selector rule-selector set-rule-selector!)
  (declarations rule-declarations set-rule-declarations!))

(define* (rul selector . args)
  (make-rule selector
             (flatten-list args)))

(define-record-type declaration
  (make-declaration property value) declaration?
  (property declaration-property)
  (value declaration-value))

(define dec
  make-declaration)

(define* (niri-config #:key palette
                      sans-font
                      mono-font
                      keyboard-layout
                      caps-to-ctrl?)
  (list (rul 'input
             (list (rul 'keyboard
                        (list (rul 'xkb
                                   (list (dec 'layout keyboard-layout)))))))))

(define* (niri-capability #:key palette
                          sans-font
                          mono-font
                          keyboard-layout
                          caps-to-ctrl?)
  `((".config/niri/config.kdl" ,(plain-file "config.kdl"
                                            (serialize-kdl (niri-config
                                                            #:palette palette
                                                            #:sans-font
                                                            sans-font
                                                            #:mono-font
                                                            mono-font
                                                            #:keyboard-layout
                                                            keyboard-layout
                                                            #:caps-to-ctrl?
                                                            caps-to-ctrl?))))))

(define* (serialize-kdl xs
                        #:key (indent ""))
  (let* ((new-indent (format #f "~a~a" indent "  ")))
    (cond
      ((list? xs)
       (map (lambda (x)
              (serialize-kdl x
                             #:indent new-indent)) xs))
      ((rule? xs)
       (format #f
               "~a {\n~a~a\n~a}"
               (rule-selector xs)
               indent
               (cond
                 ((rule? (rule-declarations xs))
                  (serialize-kdl (rule-declarations xs)
                                 #:indent new-indent))
                 ((list? (rule-declarations xs))
                  (string-join (map (lambda (xx)
                                      (cond
                                        ((rule? xx)
                                         (serialize-kdl xx
                                                        #:indent new-indent))
                                        ((declaration? xx)
                                         (serialize-declaration xx))
                                        (else (format #f "~a" xx)))

                                      )
                                    (rule-declarations xs)) " "))
                 (else (begin
                         (serialize-declaration (rule-declarations xs)))))
               indent))
      ((declaration? xs)
       (serialize-declaration xs))
      (else (format #f "~a" xs)))))

(define (serialize-declaration xs)
  (format #f "~a:~a;"
          (declaration-property xs)
          (declaration-value xs)))

(define niri-cfg
  (niri-config #:palette 'dracula
               #:sans-font "IBM Plex Sans"
               #:mono-font "IBM Plex Mono"
               #:keyboard-layout "us"
               #:caps-to-ctrl? #t))

(display (string-join (serialize-kdl niri-cfg) "\n"))

