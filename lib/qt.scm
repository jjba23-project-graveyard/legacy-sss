;;; SSS - Supreme Sexp System

;; Copyright (C) 2024 Josep Jesus Bigorra Algaba

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

(define-module (sss qt)
  #:use-module (gnu)
  #:use-module (sss palette)
  #:use-module (sss process))

(define-public sss-qt6ct-config
  (string-append "[Appearance]\n"
                 (mk-kv-conf-lines `((color_scheme_path . "/run/current-system/profile/share/qt6ct/colors/airy.conf")
                                     (custom_palette . false)
                                     (icon_theme unquote
                                                 (cond
                                                   ((equal?
                                                     sss-palette-ef-cyprus
                                                     sss-active-palette)
                                                    "Yaru-sage")
                                                   ((equal?
                                                     sss-palette-ef-dream
                                                     sss-active-palette)
                                                    "Yaru-magenta-dark")
                                                   (else "Yaru-sage-dark")))
                                     (standard_dialogs . default)
                                     (style . kvantum)))
                 "\n[Fonts]\n"
                 (mk-kv-conf-lines `((fixed . "\"Monaspace Neon,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular\"")
                                     (general . "\"Monaspace Neon,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular\"")))
                 "\n[Interface]\n"
                 (mk-kv-conf-lines `((activate_item_on_single_click . 0)
                                     (buttonbox_layout . 3)
                                     (cursor_flash_time . 1000)
                                     (dialog_buttons_have_icons . 1)
                                     (double_click_interval . 400)
                                     (gui_effects . "@Invalid()")
                                     (keyboard_scheme . 2)
                                     (menus_have_icons . true)
                                     (show_shortcuts_in_context_menus . true)
                                     (stylesheets . "@Invalid()")
                                     (toolbutton_style . 4)
                                     (underline_shortcut . 1)
                                     (wheel_scroll_lines . 3)))))

(define-public sss-qt5ct-config
  (string-append "[Appearance]\n"
                 (mk-kv-conf-lines `((color_scheme_path . "/run/current-system/profile/share/qt6ct/colors/airy.conf")
                                     (custom_palette . false)
                                     (icon_theme unquote
                                                 (cond
                                                   ((equal?
                                                     sss-palette-ef-cyprus
                                                     sss-active-palette)
                                                    "Yaru-sage")
                                                   ((equal?
                                                     sss-palette-ef-dream
                                                     sss-active-palette)
                                                    "Yaru-magenta-dark")
                                                   (else "Yaru-sage-dark")))
                                     (standard_dialogs . default)
                                     (style . kvantum)))
                 "\n[Fonts]\n"
                 (mk-kv-conf-lines `((fixed . "\"Monaspace Neon,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular\"")
                                     (general . "\"Monaspace Neon,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular\"")))
                 "\n[Interface]\n"
                 (mk-kv-conf-lines `((activate_item_on_single_click . 0)
                                     (buttonbox_layout . 3)
                                     (cursor_flash_time . 1000)
                                     (dialog_buttons_have_icons . 1)
                                     (double_click_interval . 400)
                                     (gui_effects . "@Invalid()")
                                     (keyboard_scheme . 2)
                                     (menus_have_icons . true)
                                     (show_shortcuts_in_context_menus . true)
                                     (stylesheets . "@Invalid()")
                                     (toolbutton_style . 4)
                                     (underline_shortcut . 1)
                                     (wheel_scroll_lines . 3)))))

