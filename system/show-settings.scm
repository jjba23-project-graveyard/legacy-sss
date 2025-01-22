(define-syntax-rule (log-exprs exp ...)
  (begin
    (format #t "~a: ~S\n"
            'exp exp) ...))

(define (sss-show-settings)
  (log-exprs sss-lang
             sss-timezone
             sss-keyboard-layout
             sss-keyboard-caps-to-ctrl
             sss-hostname
             sss-clone-dir
             sss-per-host-packages
             sss-active-palette
             sss-nixpkgs))
