;;; SSS - Supreme Sexp System

(load "./home/joe/palette.scm")
(load "./home/joe/sway.scm")

(define-module (sss-doc)
  #:use-module (gnu)
  #:use-module (sss-sway)
  #:use-module (sss-palette))

(define-public sss-manual-lines
  `("#+title: SSS/GNU system - Manual & Documentation

"
    "You are reading the auto-generated manual for SSS. This manual documents the SSS/GNU system and its functionalities.

"
    "** Sway\n\n"
    "*** Keybindings\n\n"
    ,(with-output-to-string (lambda ()
                              (display "| keybind | command |\n")
                              (display "|------|------|\n")
                              (for-each (lambda (x)
                                          (display (format #f
                                                           "| ~a | =~a= |\n"
                                                           (car x)
                                                           (cond
                                                             ((and (string? (cdr
                                                                             x))
                                                                   (>= (string-length
                                                                        (cdr x))
                                                                       32))
                                                              (string-take (cdr
                                                                            x)
                                                                           32))
                                                             ((not (string? (cdr
                                                                             x)))
                                                              "")
                                                             (else (cdr x))))))
                                        sss-sway-keybindings)
                              (display "|------|------|\n\n\n")))
    "*** Variables\n\n"
    ,(with-output-to-string (lambda ()
                              (display "| variable | value |\n")
                              (display "|------|------|\n")
                              (for-each (lambda (x)
                                          (display (format #f
                                                           "| ~a | =~a= |\n"
                                                           (car x)
                                                           (cond
                                                             ((and (string? (cdr
                                                                             x))
                                                                   (>= (string-length
                                                                        (cdr x))
                                                                       44))
                                                              (string-take (cdr
                                                                            x)
                                                                           44))
                                                             ((not (string? (cdr
                                                                             x)))
                                                              "")
                                                             (else (cdr x))))))
                                        sss-sway-variables)
                              (display "|------|------|\n\n\n")))))

(define-public (sss-write-manual)
  (with-output-to-file "./docs/Manual/README.org"
    (lambda ()
      (for-each (lambda (x)
                  (display x)) sss-manual-lines))))

