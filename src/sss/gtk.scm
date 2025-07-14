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

(define-module (sss gtk)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss palette)
  #:use-module (sss prelude)
  #:export (gtk3-config gtk4-config gtk3-capability gtk4-capability
                        gtk4-adwstylemanager-config gtk-dconf-settings))

(define* (gtk3-config #:key palette sans-font)
  `((gtk-enable-event-sounds . 0) (gtk-enable-input-feedback-sounds . 0)
    (gtk-cursor-theme-name unquote
                           (get-cursor-theme palette))
    (gtk-cursor-theme-size . 24)
    (gtk-application-prefer-dark-theme unquote
                                       (if (is-dark-palette palette)
                                           'true
                                           'false))))

(define* (gtk4-config #:key palette sans-font)
  `((gtk-enable-event-sounds . 0) (gtk-enable-input-feedback-sounds . 0)
    (gtk-cursor-theme-name unquote
                           (get-cursor-theme palette))
    (gtk-cursor-theme-size . 24)
    (gtk-application-prefer-dark-theme unquote
                                       (if (is-dark-palette palette)
                                           'true
                                           'false))))

(define* (gtk3-capability #:key palette sans-font)
  `((".config/gtk-3.0/settings.ini" ,(plain-file "settings.ini"
                                                 (string-append "[Settings]\n"
                                                                (mk-kv-conf-lines
                                                                 (gtk3-config
                                                                  #:palette
                                                                  palette
                                                                  #:sans-font
                                                                  sans-font)))))))

(define* (gtk4-capability #:key palette sans-font mono-font)
  `((".config/gtk-4.0/settings.ini" ,(plain-file "settings.ini"
                                                 (string-append "[Settings]\n"
                                                                (mk-kv-conf-lines
                                                                 (gtk4-config
                                                                  #:palette
                                                                  palette
                                                                  #:sans-font
                                                                  sans-font)))))))

(define* (gtk-dconf-settings #:key palette sans-font mono-font)
  `( ;Basename of the default keybinding theme used by gtk+.
     ("/org/gnome/desktop/interface/gtk-key-theme" . "'Emacs'")
    ;; Size of the cursor used as cursor theme.
    ("/org/gnome/desktop/interface/cursor-size" . 24)
    ;; Cursor theme name. Used only by Xservers that support the Xcursor extension.
    ("/org/gnome/desktop/interface/cursor-theme" unquote
     (format #f "'~a'"
             (get-cursor-theme palette)))
    ;; Basename of the default theme used by gtk+.
    ("/org/gnome/desktop/interface/gtk-theme" unquote
     (format #f "'~a'"
             (get-gtk-theme palette)))
    ;; Icon theme to use for the panel, nautilus etc.
    ("/org/gnome/desktop/interface/icon-theme" unquote
     (format #f "'~a'"
             (get-icon-theme palette)))
    ;; Whether animations should be displayed. Note: This is a global key,
    ;; it changes the behaviour of the window manager, the panel etc.
    ("/org/gnome/desktop/interface/enable-animations" . true)
    ;; The preferred accent color for the user interface. Valid values are
    ;; "blue", "teal", "green", "yellow", "orange", "red", "pink", "purple", "slate".
    ("/org/gnome/desktop/interface/accent-color" unquote
     (get-gtk-accent-color palette))
    ;; The preferred color scheme for the user interface. Valid values are “default”, “prefer-dark”, “prefer-light”.
    ("/org/gnome/desktop/interface/color-scheme" unquote
     (if (is-dark-palette palette) "'prefer-dark'" "'prefer-light'"))
    ;; Name of the default font used by gtk+.
    ("/org/gnome/desktop/interface/font-name" unquote
     (format #f "'~a 11'" sans-font))
    ;; Name of the default font used for reading documents.
    ("/org/gnome/desktop/interface/document-font-name" unquote
     (format #f "'~a 11'" sans-font))
    ;; Name of a monospaced (fixed-width) font for use in locations like
    ;; terminals.
    ("/org/gnome/desktop/interface/monospace-font-name" unquote
     (format #f "'~a 11'" mono-font))))
