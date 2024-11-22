;; WIP defining foot config in Scheme

(define-module (sss-joe-foot)
  #:use-module (gnu)
  #:use-module (gnu services configuration)
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module (gnu services configuration)
  #:use-module (srfi srfi-26)
  #:use-module (srfi srfi-1)
  )

(define (serialize-string field-name value)
  #~(string-append #$(uglify-field-name field-name) " = " #$value "\n"))

(define (serialize-sss-foot-bell field-name value)
  #~(string-append 
     #$(serialize-configuration
        configuration sss-foot-bell-fields))
  )

;; Turn field names, which are Scheme symbols into strings
(define (uglify-field-name field-name)
  (let ((str (symbol->string field-name)))
    ;; field? -> is-field
    (if (string-suffix? "?" str)
        (string-append "is-" (string-drop-right str 1))
        str)))

(define-configuration sss-foot-bell
  (urgent (string "no") "")
  (notify (string "no") "")
  (visual (string "no") "")
  )

(define-configuration sss-foot
  (font (string "Intel One Mono:size=10") "")
  (dpi-aware (string "yes") "")
  (pad (string "12x12") "" )
  (bell (sss-foot-bell) "")
  )

(define my-foot
  (sss-foot))
