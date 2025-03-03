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

(define* (serialize-hyprland-setting type setting
                                     #:key (indent "")
                                     (nested #f))
  (if nested
      (format #f
              "~a~a~a = ~a"
              indent
              indent
              type
              setting)
      (format #f "~a~a = ~a" indent type setting)))

(define* (serialize-hyprland-section #:key section settings
                                     (indent "")
                                     (nested #f))
  (let ((xs (string-join (map (lambda (x)
                                (cond
                                  ((list? (cdr x))
                                   (serialize-hyprland-section #:section (car
                                                                          x)
                                                               #:settings (cdr
                                                                           x)
                                                               #:indent "  "
                                                               #:nested #t))
                                  (else (serialize-hyprland-setting (car x)
                                                                    (cdr x)
                                                                    #:indent
                                                                    "  "
                                                                    #:nested
                                                                    nested))))
                              settings) "\n")))
    (format #f
            "~a~a {\n~a\n~a}"
            indent
            section
            xs
            indent)))

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

(define* (sss-hyprland-startup-programs #:key sss-active-palette
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
                       "podman system service --time=0 unix:///tmp/podman.sock"
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

(define* (sss-hyprland-input #:key sss-keyboard-layout)
  `((follow_mouse . 1)
    (kb_layout unquote sss-keyboard-layout)
    (kb_options . "caps:ctrl_modifier")
    (touchpad (disable_while_typing . true)
              (natural_scroll . false)
              (scroll_factor . "1.0")
              (tap-to-click . true))))

(define sss-hyprland-general
  `((border_size . 1) (no_border_on_floating . false)
    (gaps_in . 6)
    (gaps_out . 16)
    (layout . dwindle)
    (resize_on_border . true)))

(define sss-hyprland-gestures
  `((workspace_swipe . true)))

(define sss-hyprland-decoration
  `((rounding . 6) (active_opacity . "1.0")
    (inactive_opacity . "0.9")
    (dim_inactive . true)
    (dim_strength . "0.2")
    (blur (enabled . true)
          (size . 8))
    (shadow (enabled . true)
            (range . 4))))

(define sss-hyprland-animations
  `((enabled . true) (first_launch_animation . true)))

(define sss-hyprland-misc
  `((disable_hyprland_logo . true) (disable_splash_rendering . true)
    (font_family . "Adwaita Sans")))

(define sss-hyprland-binds
  (append (map (lambda (kb)
                 (serialize-hyprland-setting (car kb)
                                             (cdr kb)))
               `((bindel . ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
                 (bindel . ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
                 (bindl . ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
                 (bindl . ", XF86AudioPlay, exec, playerctl play-pause")
                 (bindl . ", XF86AudioNext, exec, playerctl next")
                 (bindl . ", XF86AudioPrev, exec, playerctl previous")))
          (map (lambda (kb)
                 (serialize-hyprland-setting 'bind kb))
               `("SUPER, K, killactive" "SUPER, F, fullscreen"
                 "SUPER_SHIFT, Q, exit"
                 "SUPER_SHIFT, L, forcerendererreload"
                 ;;
                 "SUPER, T, exec, footclient"
                 "SUPER, slash, exec, rofi -show drun"
                 "SUPER, E, exec, emacsclient -c"
                 "SUPER_SHIFT, E, exec, emacsclient -t"
                 "SUPER, period, exec, grimshot save screen"
                 "SUPER_SHIFT, period, exec, grimshot copy screen"
                 "SUPER, comma, exec, grimshot save area"
                 "SUPER_SHIFT, comma, exec, grimshot copy area"
                 "SUPER, I, exec, icecat"
                 "SUPER_SHIFT, I, exec, google-chrome"
                 ;;
                 "SUPER, 1, workspace, 1"
                 "SUPER, 2, workspace, 2"
                 "SUPER, 3, workspace, 3"
                 "SUPER, 4, workspace, 4"
                 "SUPER, 5, workspace, 5"
                 "SUPER, 6, workspace, 6"
                 "SUPER, 7, workspace, 7"
                 "SUPER, 8, workspace, 8"
                 "SUPER, 9, workspace, 9"
                 ;;
                 "SUPER_SHIFT, 1, movetoworkspacesilent, 1"
                 "SUPER_SHIFT, 2, movetoworkspacesilent, 2"
                 "SUPER_SHIFT, 3, movetoworkspacesilent, 3"
                 "SUPER_SHIFT, 4, movetoworkspacesilent, 4"
                 "SUPER_SHIFT, 5, movetoworkspacesilent, 5"
                 "SUPER_SHIFT, 6, movetoworkspacesilent, 6"
                 "SUPER_SHIFT, 7, movetoworkspacesilent, 7"
                 "SUPER_SHIFT, 8, movetoworkspacesilent, 8"
                 "SUPER_SHIFT, 9, movetoworkspacesilent, 9"
                 ;;
                 "SUPER_SHIFT, space, togglefloating, active"
                 "SUPER_SHIFT, C, centerwindow, "
                 "SUPER, N, cyclenext, "
                 "SUPER, P, cyclenext, prev"))))

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
                              #:sss-active-palette sss-active-palette
                              #:wallpaper-setter (format #f
                                                         (string-append
                                                          "swww img ~a"
                                                          " --transition-step 12"
                                                          " --transition-fps 60"
                                                          " --transition-type center")
                                                         wall)))
           (serialized-startup-programs (map (lambda (startup-item)
                                               (serialize-hyprland-setting 'exec-once
                                                startup-item))
                                             startup-programs))
           (serialized-input (serialize-hyprland-section #:section 'input
                                                         #:settings (sss-hyprland-input
                                                                     #:sss-keyboard-layout
                                                                     sss-keyboard-layout)))
           (serialized-general (serialize-hyprland-section #:section 'general
                                #:settings sss-hyprland-general))
           (serialized-decoration (serialize-hyprland-section #:section 'decoration
                                   #:settings sss-hyprland-decoration))
           (serialized-animations (serialize-hyprland-section #:section 'animations
                                   #:settings sss-hyprland-animations))
           (serialized-key-bindings (string-join sss-hyprland-binds "\n"))
           (config-lines (append '("# ====== SSS Hyprland configuration ======"
                                   "#" "# auto-generated file, DO NOT EDIT!"
                                   "" "# ====== Startup programs ======")
                                 serialized-startup-programs
                                 `("" "# ====== General configuration ======"
                                   ,serialized-general)
                                 `("" "# ====== Input configuration ======"
                                   ,serialized-input)
                                 `(""
                                   "# ====== Decoration configuration ======"
                                   ,serialized-decoration)
                                 `(""
                                   "# ====== Animations configuration ======"
                                   ,serialized-animations)
                                 `("" "# ====== Key bindings ======"
                                   ,serialized-key-bindings)
                                 `(""
                                   "# ====== End of SSS Hyprland configuration ======"
                                   ""))))
      
      (string-join config-lines "\n")))
  (export sss-hyprland-config))

(newline)
(display (sss-hyprland-config #:sss-active-palette 'ef-dream
                              #:sss-keyboard-layout "us"
                              #:sss-clone-dir "some"))
