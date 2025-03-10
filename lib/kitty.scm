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

(load "./palette.scm")
(load "./process.scm")

(define-module (sss kitty)
  #:use-module (gnu)
  #:use-module (gnu home services)
  #:use-module (sss palette)
  #:use-module (sss process))

;; TODO allow defining bindings in an Emacs-like way
;; so C instead of ctrl, M instead of alt
(define sss-kitty-keybindings
  `(("ctrl+equal" . "change_font_size all +1.0")
    ("ctrl+plus" . "change_font_size all +1.0")
    ("ctrl+underscore" . "change_font_size all -1.0")
    ("ctrl+minus" . "change_font_size all -1.0")
    ("alt+w" . copy_to_clipboard)
    ("ctrl+y" . paste_from_clipboard)
    ("alt+<" . scroll_home)
    ("alt+>" . scroll_end)
    ("alt+v" . scroll_page_up)
    ("ctrl+v" . scroll_page_down)))

(define (serialize-kitty-binding b)
  `(,(format #f "map ~a"
             (car b)) unquote
    (cdr b)))

(begin
  (define* (sss-kitty-config #:key palette)
    (append `((clear_all_shortcuts . yes))
            (map (lambda (b)
                   (serialize-kitty-binding b)) sss-kitty-keybindings)
            `((font_family . "Adwaita Mono") (font_size . "11.0")
              (bold_font . auto)
              (italic_font . auto)
              (bold_italic_font . auto)
              (scrollback_lines . 2000000)
              (enable_audio_bell . no)
              (foreground unquote
                          (sss-get-color palette
                                         'text))
              (background unquote
                          (sss-get-color palette
                                         'background))
              (background_opacity . "0.8")
              (cursor unquote
                      (sss-get-color palette
                                     'primary))
              (cursor_shape . block)
              (cursor_text_color . background)
              (window_padding_width . "10.0"))))
  (export sss-kitty-config))

(begin
  (define* (sss-kitty-svc #:key palette)
    `((".config/kitty/kitty.conf" ,(plain-file "kitty.conf"
                                               (mk-rec-kv-conf-lines (sss-kitty-config
                                                                      #:palette
                                                                      palette)
                                                                     #:template
                                                                     "~a ~a\n")))))
  (export sss-kitty-svc))
