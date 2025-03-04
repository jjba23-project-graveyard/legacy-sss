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

(define* (serialize-hypr-setting type setting
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

(define* (serialize-hypr-section #:key section settings
                                 (indent "")
                                 (nested #f))
  (let ((xs (string-join (map (lambda (x)
                                (cond
                                  ((list? (cdr x))
                                   (serialize-hypr-section #:section (car x)
                                                           #:settings (cdr x)
                                                           #:indent "  "
                                                           #:nested #t))
                                  (else (serialize-hypr-setting (car x)
                                                                (cdr x)
                                                                #:indent "  "
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
  (define* (sss-hypr-wallpaper #:key sss-clone-dir sss-active-palette)
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
  (export sss-hypr-wallpaper))

(define* (sss-hypr-startup-programs #:key sss-active-palette
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
                         "gsettings set org.gnome.desktop.interface gtk-theme '~a'"
                         gtk-theme-name)
                       ,(format #f
                         "gsettings set org.gnome.desktop.interface icon-theme '~a'"
                         icon-theme-name)
                       "gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'"
                       "gsettings set org.gnome.desktop.interface cursor-size 24"
                       "gsettings set org.gnome.desktop.interface font-name 'Inter'"))))
    xs))

(define* (sss-hypr-input #:key sss-keyboard-layout)
  `((follow_mouse . 1) (kb_layout unquote sss-keyboard-layout)
    (kb_options . "caps:ctrl_modifier")
    (touchpad (disable_while_typing . true)
              (natural_scroll . false)
              (scroll_factor . "1.0")
              (tap-to-click . true))))

(define* (sss-hypr-general #:key sss-active-palette)
  `((border_size . 2) (no_border_on_floating . false)
    (gaps_in . 8)
    (gaps_out . 18)
    (layout . dwindle)
    (resize_on_border . true)
    ("col.active_border" unquote
     (format #f "0xff~a"
             (string-drop (sss-get-color sss-active-palette
                                         'primary) 1)))))

(define sss-hypr-gestures
  `((workspace_swipe . true)))

(define sss-hypr-decoration
  `((rounding . 8) (active_opacity . "1.0")
    (inactive_opacity . "0.9")
    (dim_inactive . true)
    (dim_strength . "0.2")
    (blur (enabled . true)
          (size . 8))
    (shadow (enabled . true)
            (range . 4))))

(define sss-hypr-animations
  `((enabled . true) (first_launch_animation . true)))

(define sss-hypr-misc
  `((disable_hypr_logo . true) (disable_splash_rendering . true)
    (font_family . "Adwaita Sans")))

(define (sss-hypr-translate-mod mod)
  (cond
    ((equal? "s" mod)
     "SUPER")
    ((equal? "s-S" mod)
     "SUPER_SHIFT")
    ((equal? "M" mod)
     "ALT")
    (else "SUPER")))

(define* (sss-hypr-bind #:key bind dispatch
                        (cmd "")
                        (mod ""))
  (format #f
          "~a, ~a, ~a, ~a"
          (sss-hypr-translate-mod mod)
          bind
          dispatch
          cmd))

(define* (sss-hypr-no-cmd-bind #:key bind dispatch
                               (mod ""))
  (format #f "~a, ~a, ~a"
          (sss-hypr-translate-mod mod) bind dispatch))

(define sss-hypr-binds
  (append (map (lambda (kb)
                 (serialize-hypr-setting (car kb)
                                         (cdr kb)))
               `((bindel . ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
                 (bindel . ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
                 (bindl . ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
                 (bindel . ", XF86MonBrightnessDown, exec, sudo light -U 5")
                 (bindel . ", XF86MonBrightnessUp, exec, sudo light -A 5")
                 (bindl . ", XF86AudioPlay, exec, playerctl play-pause")
                 (bindl . ", XF86AudioNext, exec, playerctl next")
                 (bindl . ", XF86AudioPrev, exec, playerctl previous")))
          (map (lambda (kb)
                 (serialize-hypr-setting 'bind kb))
               `(,(sss-hypr-no-cmd-bind #:mod "s"
                                        #:bind "K"
                                        #:dispatch 'killactive) ,(sss-hypr-no-cmd-bind
                                                                  #:mod "s"
                                                                  #:bind "F"
                                                                  #:dispatch 'fullscreen)
                                        ,(sss-hypr-no-cmd-bind #:mod "s-S"
                                                               #:bind "Q"
                                                               #:dispatch 'exit)
                                        ,(sss-hypr-no-cmd-bind #:mod "s-S"
                                                               #:bind "L"
                                                               #:dispatch 'forcerendererreload)
                                        ;;
                                        ,(sss-hypr-bind #:mod "s"
                                                        #:bind "L"
                                                        #:dispatch 'exec
                                                        #:cmd (string-join '("hyprlock") " "))
                                        ,(sss-hypr-bind #:mod "s"
                                                        #:bind "T"
                                                        #:dispatch 'exec
                                                        #:cmd "footclient fish")
                                        ,(sss-hypr-bind #:mod "s"
                                                        #:bind "slash"
                                                        #:dispatch 'exec
                                                        #:cmd "rofi -show drun")
                                        "SUPER, E, exec, emacsclient -c"
                                        "SUPER_SHIFT, E, exec, emacsclient -t"
                                        "SUPER, period, exec, grimshot save screen"
                                        "SUPER_SHIFT, period, exec, grimshot copy screen"
                                        "SUPER, comma, exec, grimshot save area"
                                        "SUPER_SHIFT, comma, exec, grimshot copy area"
                                        "SUPER, I, exec, icecat"
                                        "SUPER_SHIFT, I, exec, google-chrome"
                                        "SUPER, B, exec, thunar"
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
                                        "SUPER, tab, cyclenext, "))))

(begin
  (define* (sss-hyprlock-config #:key sss-clone-dir)
    (let* ((serialized-img (serialize-hypr-section #:section 'image
                                                   #:settings `((monitor . "")
                                                                (path . ,(format #f "~a/resources/img/sss.png" sss-clone-dir))
                                                                (position . "0, 230")
                                                                (rounding . "-1")
                                                                (size . "200")
                                                                (border_size . 2)
                                                                (border_color . "rgba(160, 160, 160, 0.5)")
                                                                (halign . center)
                                                                (valign . center))))
           (serialized-clock (serialize-hypr-section #:section 'label
                                                     #:settings `((monitor . "")
                                                                  (text . "cmd[update:1000] echo \"<span foreground='##ffffff'>$(date)</span>\"")
                                                                  (color . "rgba(200, 200, 200, 1.0)")
                                                                  (font_size . 26)
                                                                  (font_family . "Adwaita Sans")
                                                                  (position . "0, 380")
                                                                  (halign . center)
                                                                  (valign . center))))
           (serialized-greeting (serialize-hypr-section #:section 'label
                                                        #:settings `((monitor . "")
                                                                     (text . "$USER @ SSS/GNU")
                                                                     (color . "rgba(200, 200, 200, 1.0)")
                                                                     (font_size . 20)
                                                                     (font_family . "Adwaita Sans")
                                                                     (position . "0, 80")
                                                                     (halign . center)
                                                                     (valign . center))))
           (serialized-greeting2 (serialize-hypr-section #:section 'label
                                                         #:settings `((monitor . "")
                                                                      (text . "Supreme Sexp System")
                                                                      (color . "rgba(180, 180, 180, 1.0)")
                                                                      (font_size . 14)
                                                                      (font_family . "Adwaita Sans")
                                                                      (position . "0, 40")
                                                                      (halign . center)
                                                                      (valign . center))))
           (serialized-animations (serialize-hypr-section #:section 'animations
                                                          #:settings `((enabled . true)
                                                                       (bezier . "linear, 1, 1, 0, 0")
                                                                       (animation . "fadeIn, 1, 5, linear")
                                                                       (animation . "fadeOut, 1, 5, linear"))))
           (serialized-input-field (serialize-hypr-section #:section 'input-field
                                                           #:settings `((monitor . "")
                                                                        (position . "0, -100")
                                                                        (fade_on_empty . false)
                                                                        (font_family . "Adwaita Sans"))))
           (serialized-general-field (serialize-hypr-section #:section 'general
                                                             #:settings `((hide_cursor . false)
                                                                          (grace . 0)
                                                                          (fractional_scaling . 2))))
           (serialized-background (serialize-hypr-section #:section 'background
                                                          #:settings `((path . screenshot)
                                                                       (blur_passes . 2)
                                                                       (color . "rgb(10, 10, 10)"))))
           (config-lines (append `("# ====== SSS Hyprlock configuration ======"
                                   "")
                                 `("# ====== UI elements ======" ""
                                   ,serialized-img
                                   ,serialized-clock
                                   ,serialized-greeting
                                   ,serialized-greeting2)
                                 `("# ====== Animations configuration ======"
                                   "")
                                 (list serialized-animations)
                                 `("# ====== InputField configuration ======"
                                   "")
                                 (list serialized-input-field)
                                 `("# ====== General configuration ======" "")
                                 (list serialized-general-field)
                                 `("# ====== Background configuration ======"
                                   "")
                                 (list serialized-background))))
      
      (string-join config-lines "\n")))
  (export sss-hyprlock-config))

(begin
  (define* (sss-hyprland-config #:key sss-clone-dir
                                sss-keyboard-layout
                                sss-keyboard-caps-to-ctrl
                                sss-active-palette
                                sss-hyprland-monitors
                                (sss-hyprland-extra-startups '()))
    (let* ((wall (sss-hypr-wallpaper #:sss-active-palette sss-active-palette
                                     #:sss-clone-dir sss-clone-dir))
           (startup-programs (sss-hypr-startup-programs #:sss-active-palette
                                                        sss-active-palette
                                                        #:wallpaper-setter (format
                                                                            #f
                                                                            (string-append
                                                                             "swww img ~a"
                                                                             " --transition-step 12"
                                                                             " --transition-fps 60"
                                                                             " --transition-type center")
                                                                            wall)))
           (serialized-startup-programs (map (lambda (startup-item)
                                               (serialize-hypr-setting 'exec-once
                                                startup-item))
                                             startup-programs))
           (serialized-input (serialize-hypr-section #:section 'input
                                                     #:settings (sss-hypr-input
                                                                 #:sss-keyboard-layout
                                                                 sss-keyboard-layout)))
           (serialized-general (serialize-hypr-section #:section 'general
                                                       #:settings (sss-hypr-general
                                                                   #:sss-active-palette
                                                                   sss-active-palette)))
           (serialized-decoration (serialize-hypr-section #:section 'decoration
                                                          #:settings
                                                          sss-hypr-decoration))
           (serialized-animations (serialize-hypr-section #:section 'animations
                                                          #:settings
                                                          sss-hypr-animations))
           (serialized-key-bindings (string-join sss-hypr-binds "\n"))
           (config-lines (append `("# ====== SSS Hypr configuration ======"
                                   "#"
                                   "# auto-generated file, DO NOT EDIT!"
                                   ""
                                   "# ====== Monitors ======"
                                   ,(string-join sss-hyprland-monitors "\n")
                                   ""
                                   "# ====== Startup programs ======")
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

