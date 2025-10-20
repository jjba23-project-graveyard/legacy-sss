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
                        serialize-kdl
                        serialize-bindings
                        serialize-declaration
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
                        prop
                        make-declaration-prop
                        declaration-prop
                        declaration-prop-props
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

(define-record-type declaration-prop
  (make-declaration-prop props) declaration-prop?
  (props declaration-prop-props))

(define prop
  make-declaration-prop)

(define* (niri-input-config #:key caps-to-ctrl? keyboard-layout)
  (rul 'input
       (rul 'keyboard
            (rul 'xkb
                 (dec 'layout keyboard-layout)
                 (dec 'options
                      (if caps-to-ctrl? "ctrl:nocaps" "")))
            (dec 'numlock #t))
       (rul 'touchpad
            (dec 'tap #t))
       (dec 'warp-mouse-to-focus #t)))

(define* (niri-layout-config #:key palette)
  (rul 'layout
       (dec 'gaps 16)
       (dec 'center-focused-column "never")
       (rul 'preset-column-widths
            (dec 'proportion 0.333333)
            (dec 'proportion 0.5)
            (dec 'proportion 0.666666))
       (rul 'default-column-width
            (dec 'proportion 0.5))
       (rul 'focus-ring
            (dec 'width 4)
            (dec 'active-color
                 (get-color palette
                            'primary))
            (dec 'inactive-color
                 (get-color palette
                            'background-l)))
       (rul 'shadow
            (dec 'on #t)
            (dec 'draw-behind-window
                 'true)
            (dec 'softness 30)
            (dec 'spread 5)
            (dec 'offset
                 (prop '((x 0)
                         (y 5))))
            (dec 'color "#0007"))
       (rul 'struts
            (dec 'left 12)
            (dec 'right 12)
            (dec 'top 12)
            (dec 'bottom 12))))

(define (niri-intro)
  "// ====== SSS Niri configuration ======
//
// auto-generated file, DO NOT EDIT!")

(define (spawn-sh cmd)
  (format #f "spawn-sh \"~a\"" cmd))

(define (niri-bindings)
  (list (bnd #:mod "s"
             #:bind "K"
             #:cmd "close-window")
        (bnd #:mod "s"
             #:bind "O"
             #:cmd "toggle-overview")
        (bnd #:mod "s"
             #:bind "?"
             #:cmd "show-hotkey-overlay")
        (bnd #:mod "XF86AudioRaiseVolume"
             #:cmd (spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
             #:allow-when-locked? #t)
        (bnd #:mod "XF86AudioLowerVolume"
             #:cmd (spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
             #:allow-when-locked? #t)
        (bnd #:mod "XF86AudioMute"
             #:cmd (spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
             #:allow-when-locked? #t)
        (bnd #:mod "XF86AudioPlay"
             #:cmd (spawn-sh "playerctl play-pause")
             #:allow-when-locked? #t)
        (bnd #:mod "XF86AudioStop"
             #:cmd (spawn-sh "playerctl stop")
             #:allow-when-locked? #t)
        (bnd #:mod "XF86AudioPrev"
             #:cmd (spawn-sh "playerctl previous")
             #:allow-when-locked? #t)
        (bnd #:mod "XF86AudioNext"
             #:cmd (spawn-sh "playerctl next")
             #:allow-when-locked? #t)
        (bnd #:mod "XF86MonBrightnessUp"
             #:cmd (spawn-sh "sudo light -A 5")
             #:allow-when-locked? #t)
        (bnd #:mod "XF86MonBrightnessDown"
             #:cmd (spawn-sh "sudo light -U 5")
             #:allow-when-locked? #t)
        ;;
        (bnd #:mod "s-S"
             #:bind "Q"
             #:cmd "quit")
        (bnd #:mod "C-M"
             #:bind "DEL"
             #:cmd "quit")

        ;;
        (bnd #:mod "s"
             #:bind "T"
             #:cmd (spawn-sh "alacritty msg create-window || alacritty"))
        (bnd #:mod "s"
             #:bind "RET"
             #:cmd (spawn-sh "alacritty msg create-window || alacritty"))
        (bnd #:mod "s-S"
             #:bind "B"
             #:cmd (spawn-sh "herd trigger set-random-wallpaper"))
        (bnd #:mod "s-S"
             #:bind "T"
             #:cmd (spawn-sh
                    "emacsclient -ce '(eshell \\\"new\\\")(rename-buffer (concat \\\"*eshell: \\\" (float-time) \\\"*\\\"))'"))
        (bnd #:mod "s"
             #:bind "E"
             #:cmd (spawn-sh "emacsclient -c"))
        (bnd #:mod "s-S"
             #:bind "E"
             #:cmd (spawn-sh "alacritty \\\"emacsclient -c\\\""))
        (bnd #:mod "s"
             #:bind "I"
             #:cmd (spawn-sh "google-chrome-beta"))
        (bnd #:mod "s"
             #:bind "B"
             #:cmd (spawn-sh "nautilus -w"))
        (bnd #:mod "s"
             #:bind "space"
             #:cmd "toggle-window-floating")
        ;;
        (bnd #:mod "s"
             #:bind "."
             #:cmd "screenshot")
        (bnd #:mod "s-S"
             #:bind "."
             #:cmd "screenshot-screen")
        (bnd #:mod "C-M"
             #:bind "."
             #:cmd "screenshot-window")
        ;;
        ))

(define (niri-translate-mod mod)
  (cond
    ((equal? "s" mod)
     "Mod")
    ((equal? "s-S" mod)
     "Mod+Shift")
    ((equal? "C-M" mod)
     "Ctrl+Alt")
    ((equal? "M" mod)
     "Alt")
    (else mod)))

(define (niri-translate-bind bind)
  (cond
    ((equal? "mouse-left" bind)
     "mouse:272")
    ((equal? "mouse-right" bind)
     "mouse:273")
    ((equal? "DEL" bind)
     "Delete")
    ((equal? "RET" bind)
     "Enter")
    (else bind)))

(define (serialize-bindings xs)
  (string-join (map (lambda (b)
                      (format #f
                              "~a~a~a{ ~a; }"
                              (niri-translate-mod (assoc-ref b
                                                             'mod))
                              (if (not (assoc-ref b
                                                  'bind)) ""
                                  (format #f "+~a"
                                          (niri-translate-bind (assoc-ref b
                                                                          'bind))))
                              (if (assoc-ref b
                                             'allow-when-locked?)
                                  " allow-when-locked=true " " ")
                              (assoc-ref b
                                         'cmd))) xs) "\n  "))

(define* (bnd #:key mod bind cmd
              (allow-when-locked? #f))
  `((mod unquote mod)
    (bind unquote bind)
    (cmd unquote cmd)
    (allow-when-locked? unquote allow-when-locked?)))

(define* (niri-config #:key palette
                      sans-font
                      mono-font
                      keyboard-layout
                      caps-to-ctrl?)
  (list (niri-intro)
        (niri-input-config #:caps-to-ctrl? caps-to-ctrl?
                           #:keyboard-layout keyboard-layout)
        (niri-layout-config #:palette palette)
        (rul 'hotkey-overlay
             (dec 'skip-at-startup #t))
        (rul 'animations
             (dec 'slowdown 0.7))
        (rul 'binds
             (serialize-bindings (niri-bindings)))))

(define* (niri-capability #:key palette
                          sans-font
                          mono-font
                          keyboard-layout
                          caps-to-ctrl?)
  `((".config/niri/config.kdl" ,(plain-file "config.kdl"
                                            (string-join (serialize-kdl (niri-config
                                                                         #:palette
                                                                         palette
                                                                         #:sans-font
                                                                         sans-font
                                                                         #:mono-font
                                                                         mono-font
                                                                         #:keyboard-layout
                                                                         keyboard-layout
                                                                         #:caps-to-ctrl?
                                                                         caps-to-ctrl?))
                                                         "\n")))))

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
                                    (rule-declarations xs))
                               (format #f "\n~a" indent)))
                 (else (begin
                         (serialize-declaration (rule-declarations xs)))))
               (string-drop indent 2)))
      ((declaration? xs)
       (serialize-declaration xs))
      (else (format #f "~a" xs)))))

(define (serialize-declaration xs)
  (format #f "~a ~a"
          (declaration-property xs)
          (cond
            ((eq? #t
                  (declaration-value xs))
             "")
            ((declaration-prop? (declaration-value xs))
             (string-join (map (lambda (p)
                                 (format #f "~a=~a"
                                         (car p)
                                         (cadr p)))
                               (declaration-prop-props (declaration-value xs)))
                          " "))
            ((string? (declaration-value xs))
             (format #f "\"~a\""
                     (declaration-value xs)))
            (else (declaration-value xs)))))



