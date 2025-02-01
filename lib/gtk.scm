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

(define-module (sss gtk)
  #:use-module (gnu)
  #:use-module (sss palette))

(begin
  (define* (sss-gtk3-config #:key sss-active-palette
                            (fixed-theme #f)
                            (fixed-icon-theme #f))
    `((gtk-icon-theme-name unquote
                           (cond
                             ((not (equal? #f fixed-icon-theme))
                              fixed-icon-theme)
                             ((equal? 'sss-palette-ef-cyprus
                                      sss-active-palette)
                              "Yaru-sage")
                             ((equal? 'sss-palette-heavy-metal
                                      sss-active-palette)
                              "Yaru-red-dark")
                             ((equal? 'sss-palette-ef-dream sss-active-palette)
                              "Yaru-magenta-dark")
                             (else "Yaru-sage-dark")))
      (gtk-theme-name unquote
                      (cond
                        ((not (equal? #f fixed-theme))
                         fixed-theme)
                        ((equal? 'sss-palette-ef-cyprus sss-active-palette)
                         "Yaru-sage")
                        ((equal? 'sss-palette-heavy-metal sss-active-palette)
                         "Yaru-red-dark")
                        ((equal? 'sss-palette-ef-dream sss-active-palette)
                         "Yaru-magenta-dark")
                        (else "Yaru-sage-dark")))
      (gtk-font-name . "Inter 11")
      (gtk-key-theme-name . "Emacs")
      (gtk-enable-event-sounds . 0)
      (gtk-cursor-theme-name . "Yaru")
      (gtk-cursor-theme-size . 24)
      (gtk-enable-input-feedback-sounds . 0)
      (gtk-application-prefer-dark-theme unquote
                                         (cond
                                           ((equal? sss-palette-ef-cyprus
                                                    sss-active-palette)
                                            0)
                                           ((equal? sss-palette-ef-dream
                                                    sss-active-palette)
                                            0)
                                           (else 1)))))
  (export sss-gtk3-config))

(begin
  (define* (sss-gtk4-config #:key sss-active-palette
                            (fixed-theme #f)
                            (fixed-icon-theme #f))
    `((gtk-icon-theme-name unquote
                           (cond
                            ((not (equal? #f fixed-icon-theme))
                             fixed-icon-theme)
                            ((equal? 'sss-palette-ef-cyprus
                                     sss-active-palette)
                             "Yaru-sage")
                            ((equal? 'sss-palette-heavy-metal
                                     sss-active-palette)
                             "Yaru-red-dark")
                            ((equal? 'sss-palette-ef-dream sss-active-palette)
                             "Yaru-magenta-dark")
                            (else "Yaru-sage-dark")))
      (gtk-theme-name unquote
                      (cond
                       ((not (equal? #f fixed-theme))
                        fixed-theme)
                       ((equal? 'sss-palette-ef-cyprus sss-active-palette)
                        "Yaru-sage")
                       ((equal? 'sss-palette-heavy-metal sss-active-palette)
                        "Yaru-red-dark")
                       ((equal? 'sss-palette-ef-dream sss-active-palette)
                        "Yaru-magenta-dark")
                       (else "Yaru-sage-dark")))
      (gtk-font-name . "Inter 11")
      (gtk-enable-event-sounds . 0)
      (gtk-cursor-theme-name . "Yaru")
      (gtk-cursor-theme-size . 24)
      (gtk-enable-input-feedback-sounds . 0)
      (gtk-application-prefer-dark-theme unquote
                                         (cond
                                          ((equal? 'sss-palette-ef-cyprus
                                                   sss-active-palette)
                                           0)
                                          ((equal? 'sss-palette-ef-dream
                                                   sss-active-palette)
                                           1)
                                          (else 1)))))
  (export sss-gtk4-config))
