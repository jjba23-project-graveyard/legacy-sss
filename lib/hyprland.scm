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

(define-module (sss hyprland)
  #:use-module (sss palette))

(define* (serialize-hyprland-setting type setting #:key (indent ""))
  (format #f "~a~a=~a" indent type setting))

;; Define diverse wallpapers based on the active color scheme. 
(begin
  (define* (sss-hyprland-wallpaper #:key sss-clone-dir sss-active-palette)
    (cond
      ((equal? 'sss-palette-ef-cyprus sss-active-palette)
       (format #f "~a/resources/wallpapers/some-forest.jpg" sss-clone-dir))
      ((equal? 'sss-palette-ef-dream sss-active-palette)
       (format #f "~a/resources/wallpapers/1362745.png" sss-clone-dir))
      ((equal? 'sss-palette-heavy-metal sss-active-palette)
       (format #f "~a/resources/wallpapers/heavy-wall3.jpg" sss-clone-dir))
      ((equal? 'sss-palette-solarized-light sss-active-palette)
       (format #f "~a/resources/wallpapers/ofcoisp7abfe1.jpeg" sss-clone-dir))
      ((equal? 'sss-palette-ef-autumn sss-active-palette)
       (format #f "~a/resources/wallpapers/0mar2ygf59je1.jpeg" sss-clone-dir))
      (else (format #f "~a/resources/wallpapers/some-forest.jpg" sss-clone-dir))))
  (export sss-sway-wallpaper))

(define* (sss-hyprland-startup-programs #:key
                                        sss-active-palette
                                        (wallpaper-setter "")
                                        (extra-startups '()))
  (let* ((gtk-theme-name (cond
                          ((equal? 'sss-palette-ef-cyprus sss-active-palette)
                           "Yaru-sage")
                          ((equal? 'sss-palette-heavy-metal
                                   sss-active-palette)
                           "Yaru-red-dark")
                          ((equal? 'sss-palette-ef-dream sss-active-palette)
                           "Yaru-magenta-dark")
                          ((equal? 'sss-palette-ef-autumn sss-active-palette)
                           "Yaru-dark")
                          ((equal? 'sss-palette-solarized-light
                                   sss-active-palette)
                           "Yaru")
                          (else "Yaru-sage-dark")))
         (icon-theme-name (cond
                           ((equal? 'sss-palette-ef-cyprus sss-active-palette)
                            "Yaru-sage")
                           ((equal? 'sss-palette-heavy-metal
                                    sss-active-palette)
                            "Yaru-red-dark")
                           ((equal? 'sss-palette-ef-dream sss-active-palette)
                            "Yaru-magenta-dark")
                           ((equal? 'sss-palette-ef-autumn sss-active-palette)
                            "Yaru-dark")
                           ((equal? 'sss-palette-solarized-light
                                    sss-active-palette)
                            "Yaru")
                           (else "Yaru-sage-dark")))
         (xs (append extra-startups
                     `("lxsession" "mako"
                       "dbus-update-activation-environment --all"
                       "waybar"
                       "foot -s"
                       ,(format #f "swww-daemon & sleep 1 && ~a"
                                wallpaper-setter)
                       "emacs --daemon"
                       "transmission-daemon"
                       "conky -d"
                       "podman system service --time=0 unix:///tmp/podman.sock &"
                       ,(format #f
                                "gsettings set $gnome-schema gtk-theme '~a'"
                                gtk-theme-name)
                       ,(format #f
                                "gsettings set $gnome-schema icon-theme '~a'"
                                icon-theme-name)
                       "gsettings set $gnome-schema cursor-theme 'Yaru'"
                       "gsettings set $gnome-schema cursor-size 24"
                       "gsettings set $gnome-schema font-name 'Inter'"))))
    xs))

(define sss-hyprland-input-config
  `((follow_mouse . 0)))

(begin
  (define* (sss-hyprland-config #:key sss-clone-dir
                                sss-keyboard-layout
                                sss-keyboard-caps-to-ctrl
                                sss-active-palette
                                (sss-hyprland-extra-startups '()))
    (let* ((wall (sss-hyprland-wallpaper #:sss-active-palette
                                         sss-active-palette
                                         #:sss-clone-dir sss-clone-dir))
           (startup-programs (sss-hyprland-startup-programs
                              #:sss-active-palette
                              sss-active-palette
                              #:wallpaper-setter
                              (format #f
                                      (string-append
                                       "swww img ~a"
                                       " --transition-step 10"
                                       " --transition-fps 30"
                                       " --transition-type center")
                                      wall)))
           (serialized-startup-programs (map (lambda (startup-item)
                                               (serialize-hyprland-setting 'exec-once
                                                                           startup-item))
                                             startup-programs))
           (serialized-input-config (format #f "input {\n~a\n}"
                                            (string-join (map (lambda (x)
                                                                (serialize-hyprland-setting
                                                                 (car x)
                                                                 (cdr x)
                                                                 #:indent "  "))
                                                              sss-hyprland-input-config) "\n"))))
      (string-join (append
                    '("# ====== SSS Hyprland configuration ======"
                      "" ""
                      "# ====== Startup programs ======"
                      "")
                    serialized-startup-programs
                    '(""
                      "# ====== Input configuration ======"
                      "" )
                    (list serialized-input-config)) "\n")))
  (export sss-hyprland-config))

(display "================")(newline)
(display (sss-hyprland-config #:sss-active-palette 'ef-dream
                              #:sss-clone-dir "some"))
