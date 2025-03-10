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

(begin
  (define* (sss-kitty-config #:key palette)
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
      (clear_all_shortcuts . yes)
      (window_padding_width . "10.0")
      ("map alt+w" . copy_to_clipboard)
      ("map ctrl+y" . paste_from_clipboard)
      ("map alt+<" . scroll_home)
      ("map alt+>" . scroll_end)
      ("map alt+v" . scroll_page_up)
      ("map ctrl+v" . scroll_page_down)))
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
