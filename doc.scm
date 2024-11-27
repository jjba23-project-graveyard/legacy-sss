(load "./home/joe/palette.scm")
(load "./home/joe/sway.scm")

(use-modules (gnu))
(use-modules (sss-sway)
             (sss-palette))

(for-each
 (lambda(x)
   (display (format #f "~a: ~a\n"  (car x) (cdr x)))
   )
 sss-sway-keybindings)

