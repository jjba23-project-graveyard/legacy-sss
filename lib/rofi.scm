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

(define-module (sss rofi)
  #:use-module (gnu)
  #:use-module (sss palette))

(define-public sss-rofi-config
  (string-append "configuration {
    font: \"Adwaita Mono 14\";
    show-icons: true;
    icon-theme:	\"Yaru\";
    display-drun: \"\";
    disable-history:false;
    fullscreen: false;
    hide-scrollbar: false;
    sidebar-mode: false;
}

@theme \"./sss-theme.rasi\""))

(begin
  (define* (sss-rofi-theme #:key sss-active-palette)
    `(("*" (foreground unquote
                       (sss-get-color sss-active-palette
                                      'text))
       (backlight unquote
                  (sss-hex-to-rgba (sss-get-color sss-active-palette
                                                  'background)
                                   #:alpha 0.8))
       (background-color . "transparent")
       (dark . "#1c1c1c")
       (black . "#3d352a")
       (lightblack . "#554444")
       (tlightblack . "#554444cc")
       (transparent . "rgba(0,0,0,0)")
       (red . "#cd5c5c")
       (lightred . "#cc5533")
       (green . "#86af80")
       (lightgreen . "#88cc22")
       (yellow . "#e8ae5b")
       (lightyellow . "#ffa75d")
       (blue . "#6495ed")
       (lightblue . "#87ceeb")
       (magenta . "#deb887")
       (lightmagenta . "#996600")
       (cyan . "#b0c4de")
       (tcyan . "#ccb0c4de")
       (lightcyan . "#b0c4de")
       (white . "#bbaa99")
       (lightwhite . "#ddccbb")
       (highlight . "underline bold #ffffff")
       (font . "\"Adwaita Mono 14\""))
      ("window" (location . "center")
       (anchor . "center")
       (transparency . "\"real\"")
       (padding . "10px")
       (border . "0px")
       (border-radius . "12px")
       (spacing . "0")
       (color . "@magenta")
       (background-color . "@transparent")
       (orientation . "horizontal")
       (children . "[ mainbox ]"))
      ("message" (font . "\"Adwaita Mono 14\"")
       (color . "@white")
       (border-color . "@foreground")
       (border . "0px 2px 2px 2px")
       (padding . "5px")
       (background-color . "@tcyan"))
      ("mainbox" (spacing . "0")
       (children . "[ inputbar, message, listview ]"))
      ("entry,prompt,case-indicator" (text-font . "inherit")
       (text-color . "inherit"))
      ("prompt" (margin . "0px 0.3em 0em 0em"))
      ("element" (padding . "3px")
       (vertical-align . "0.5")
       (border-radius . "2px")
       (background-color . "transparent")
       (color . "@foreground")
       (font . "inherit"))
      ("element-text" (background-color . "inherit")
       (text-color . "inherit"))
      ("listview" (padding . "8px")
       (border-color . "@foreground")
       (border-radius . "16px")
       (background-color unquote
                         (sss-hex-to-rgba (sss-get-color sss-active-palette
                                                         'background)
                                          #:alpha 0.8))
       (dynamic . "false")
       (lines . "20"))
      ("element selected.normal" (background-color . "@magenta")
       (text-color . "@black"))
      ("inputbar" (color unquote
                         (sss-get-color sss-active-palette
                                        'text))
       (padding . "11px")
       (margin-bottom . "6px")
       (border-radius . "16px")
       (background-color unquote
                         (sss-hex-to-rgba (sss-get-color sss-active-palette
                                                         'background-l)
                                          #:alpha 0.9)))))
  (export sss-rofi-theme))

;; inputbar {
;;           color: @lightgreen;
;;                  padding: 11px;
;;                  background-color: @tlightblack;
;;                  border: 2px 2px 2px 2px;
;;                  border-radius:  15px 15px 0px 0px;
;;                  border-color: @foreground;
;;                  font: "Source Code Pro 18";
;;                  }

;; prompt {
;;         margin:     0px 0.3em 0em 0em ;
;;                     }
;; listview {
;;                    border-radius: 0px 0px 15px 15px;
;;                    border: 0px 2px 2px 2px;

;;                    }

;; element selected.normal {
;;                          background-color: @blue;
;;                                            }
;; element normal active {
;;                        foreground: @lightblue;
;;                                    }
;; element normal urgent {
;;                        foreground: @lightred;
;;                                    }
;; element alternate normal {
;;                           }
;; element alternate active {
;;                           foreground: @lightblue;
;;                                       }
;; element alternate urgent {
;;                           foreground: @lightred;
;;                                       }
;; element selected active {
;;                          background-color: @lightblue;
;;                                            foreground: @dark;
;;                                            }
;; element selected urgent {
;;                          background-color: @lightred;
;;                                            foreground: @dark;
;;                                            }
;; element normal normal {

;;                        }
;; vertb {
;;        expand: false;
;;                children: [ dummy0, mode-switcher, dummy1  ];
;;                }
;; dummy0,  dummy1 {
;;                  expand: true;
;;                          }
;; mode-switcher {
;;                expand: false;
;;                        orientation: vertical;
;;                        spacing: 0px;
;;                        border: 0px 0px 0px 0px;
;;                        }
;; button {
;;         font: "FontAwesome 22";
;;               padding: 6px;
;;               border: 2px 0px 2px 2px;
;;               border-radius: 4px 0px 0px 4px;
;;               background-color: @tlightblack;
;;               border-color: @foreground;
;;               color: @foreground;
;;               horizontal-align: 0.5;
;;               }
;; button selected normal {
;;                         color: @dark;
;;                                border: 2px 0px 2px 2px;
;;                                background-color: @backlight;
;;                                border-color: @foreground;
;;                                }
;; error-message {
;;                expand: true;
;;                        background-color: red;
;;                        border-color: darkred;
;;                        border: 2px;
;;                        padding: 1em;
;;                        }
