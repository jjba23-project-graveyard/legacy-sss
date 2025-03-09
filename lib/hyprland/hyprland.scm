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

(load "../palette.scm")
(load "./hyprlang.scm")

(define-module (sss hyprland hyprland)
  #:use-module (sss palette)
  #:use-module (sss hyprland hyprlang))

(define* (notify-cmd #:key title subtitle)
  (format #f
          (string-append "notify-send -i"
           " /run/current-system/profile/share/icons/Yaru/32x32/actions/dialog-yes.png"
           " \"~a\" \"~a\"" " >/dev/null 2>&1") title subtitle))

;; Define diverse wallpapers based on the active color scheme. 
(begin
  (define* (hypr-wallpaper #:key clone-dir active-palette)
    (cond
      ((equal? 'sss-palette-ef-cyprus active-palette)
       (format #f "~a/resources/wallpapers/some-forest.jpg" clone-dir))
      ((equal? 'sss-palette-ef-dream active-palette)
       (format #f "~a/resources/wallpapers/1362745.png" clone-dir))
      ((equal? 'sss-palette-heavy-metal active-palette)
       (format #f "~a/resources/wallpapers/heavy-wall3.jpg" clone-dir))
      ((equal? 'sss-palette-solarized-light active-palette)
       (format #f "~a/resources/wallpapers/ofcoisp7abfe1.jpeg" clone-dir))
      ((equal? 'sss-palette-ef-autumn active-palette)
       (format #f "~a/resources/wallpapers/0mar2ygf59je1.jpeg" clone-dir))
      (else (format #f "~a/resources/wallpapers/some-forest.jpg" clone-dir))))
  (export hypr-wallpaper))

(define* (hypr-startup-programs #:key active-palette
                                (wallpaper-setter "")
                                (extra-startups '()))
  (let* ((gtk-theme-name (cond
                           ((equal? 'sss-palette-ef-cyprus active-palette)
                            "Yaru-sage")
                           ((equal? 'sss-palette-heavy-metal active-palette)
                            "Yaru-red-dark")
                           ((equal? 'sss-palette-ef-dream active-palette)
                            "Yaru-magenta-dark")
                           ((equal? 'sss-palette-ef-autumn active-palette)
                            "Yaru-dark")
                           ((equal? 'sss-palette-solarized-light
                                    active-palette)
                            "Yaru")
                           (else "Yaru-sage-dark")))
         (icon-theme-name (cond
                            ((equal? 'sss-palette-ef-cyprus active-palette)
                             "Yaru-sage")
                            ((equal? 'sss-palette-heavy-metal active-palette)
                             "Yaru-red-dark")
                            ((equal? 'sss-palette-ef-dream active-palette)
                             "Yaru-magenta-dark")
                            ((equal? 'sss-palette-ef-autumn active-palette)
                             "Yaru-dark")
                            ((equal? 'sss-palette-solarized-light
                                     active-palette)
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

(define* (hypr-input #:key keyboard-layout caps-to-ctrl)
  `((follow_mouse . 1) (kb_layout unquote keyboard-layout)
    ,(if caps-to-ctrl
         `(kb_options . "caps:ctrl_modifier")
         `(kb_options . ""))
    (touchpad (disable_while_typing . true)
              (natural_scroll . false)
              (scroll_factor . "1.0")
              (tap-to-click . true))))

(define* (hypr-general #:key active-palette)
  `((border_size . 2) (no_border_on_floating . false)
    (gaps_in . 8)
    (gaps_out . 16)
    (layout . dwindle)
    (resize_on_border . true)
    ("col.active_border" unquote
     (format #f "0xff~a"
             (string-drop (sss-get-color active-palette
                                         'primary) 1)))))

(define hypr-gestures
  `((workspace_swipe . true)))

(define* (hypr-decoration #:key (with-blur #f)
                          (with-shadow #f))
  `((rounding . 8) (active_opacity . "1.0")
    (inactive_opacity . "0.9")
    (dim_inactive . true)
    (dim_strength . "0.1")
    (blur (enabled unquote
                   (if with-blur
                       'true
                       'false))
          (size . 8))
    (shadow (enabled unquote
                     (if with-shadow
                         'true
                         'false))
            (range . 4))))

(define hypr-animations
  `((enabled . true) (first_launch_animation . true)))

(define hypr-misc
  `((disable_hypr_logo . true) (disable_splash_rendering . true)
    (font_family . "Adwaita Sans")))

;;

(define hypr-media-binds
  (map (lambda (kb)
         (serialize-hypr-setting (car kb)
                                 (cdr kb)))
       `((bindel unquote
                 (hypr-bind #:dispatch 'exec
                            #:bind "XF86AudioRaiseVolume"
                            #:cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
         (bindel . ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
         (bindl . ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
         (bindel . ", XF86MonBrightnessDown, exec, sudo light -U 5")
         (bindel . ", XF86MonBrightnessUp, exec, sudo light -A 5")
         (bindl . ", XF86AudioPlay, exec, playerctl play-pause")
         (bindl . ", XF86AudioNext, exec, playerctl next")
         (bindl . ", XF86AudioPrev, exec, playerctl previous"))))

(define hypr-workspace-binds
  (map (lambda (wn)
         (serialize-hypr-setting 'bind
                                 (hypr-bind #:mod "s"
                                            #:bind (format #f "~a" wn)
                                            #:dispatch 'workspace
                                            #:cmd (format #f "~a" wn))))
       '(1 2
         3
         4
         5
         6
         7
         8
         9)))

(define hypr-movetoworkspace-binds
  (map (lambda (wn)
         (serialize-hypr-setting 'bind
                                 (hypr-bind #:mod "s-S"
                                            #:bind (format #f "~a" wn)
                                            #:dispatch 'movetoworkspacesilent
                                            #:cmd (format #f "~a" wn))))
       '(1 2
         3
         4
         5
         6
         7
         8
         9)))

(define* hypr-mouse-binds
  (map (lambda (kb)
         (serialize-hypr-setting 'bindm kb))
       (list (special-bind #:mod "s"
                           #:bind "mouse-left"
                           #:dispatch 'movewindow))))

(define* (hypr-common-exec-binds #:key wallpaper-setter)
  (map (lambda (kb)
         (serialize-hypr-setting 'bind kb))
       (list (special-bind #:mod "s"
                           #:bind "K"
                           #:dispatch 'killactive)
             (special-bind #:mod "s"
                           #:bind "F"
                           #:dispatch 'fullscreen)
             (special-bind #:mod "s-S"
                           #:bind "Q"
                           #:dispatch 'exit)

             (special-bind #:mod "s-S"
                           #:bind "L"
                           #:dispatch 'forcerendererreload)
             (exec-bind #:mod "s"
                        #:bind "L"
                        #:cmd "hyprlock")
             (exec-bind #:mod "s"
                        #:bind "T"
                        #:cmd "footclient fish")
             (exec-bind #:mod "s"
                        #:bind "slash"
                        #:cmd "rofi -show drun")
             (exec-bind #:mod "s-S"
                        #:bind "B"
                        #:cmd wallpaper-setter)
             (exec-bind #:mod "s"
                        #:bind "E"
                        #:cmd "emacsclient -c")
             (exec-bind #:mod "s-S"
                        #:bind "E"
                        #:cmd "emacsclient -t")

             (exec-bind #:mod "s"
                        #:bind "period"
                        #:cmd (format #f
                                      "grimshot save screen && sleep 1 && ~a"
                                      (notify-cmd #:title "Screenshot saved"
                                       #:subtitle
                                       "Saved screenshot of whole screen to file!")))

             (exec-bind #:mod "s-S"
                        #:bind "period"
                        #:cmd (format #f
                                      "grimshot copy screen && sleep 1 && ~a"
                                      (notify-cmd #:title "Screenshot copied"
                                       #:subtitle
                                       "Copied screenshot of whole screen!")))
             (exec-bind #:mod "s"
                        #:bind "comma"
                        #:cmd (format #f "grimshot save area && sleep 1 && ~a"
                                      (notify-cmd #:title
                                       "Screenshot area saved"
                                       #:subtitle
                                       "Saved screenshot of area to file!")))
             (exec-bind #:mod "s-S"
                        #:bind "comma"
                        #:cmd (format #f "grimshot copy area && sleep 1 && ~a"
                                      (notify-cmd #:title "Screenshot copied"
                                       #:subtitle "Copied screenshot of area!")))
             (exec-bind #:mod "s"
                        #:bind "I"
                        #:cmd "nyxt")
             (exec-bind #:mod "s-S"
                        #:bind "I"
                        #:cmd "google-chrome")
             (exec-bind #:mod "s"
                        #:bind "B"
                        #:cmd "thunar")

             (hypr-bind #:mod "s-S"
                        #:bind "space"
                        #:dispatch "togglefloating"
                        #:cmd "active")
             (hypr-bind #:mod "s-S"
                        #:bind "C"
                        #:dispatch "centerwindow"
                        #:cmd "")
             (hypr-bind #:mod "s"
                        #:bind "tab"
                        #:dispatch "cyclenext"
                        #:cmd ""))))

(define* (hypr-binds #:key wallpaper-setter)
  (append hypr-media-binds hypr-workspace-binds hypr-movetoworkspace-binds
          (hypr-common-exec-binds #:wallpaper-setter wallpaper-setter)
          hypr-mouse-binds))

(begin
  (define* (sss-hyprland-config #:key clone-dir
                                keyboard-layout
                                keyboard-caps-to-ctrl
                                active-palette
                                monitors
                                (extra-startups '())
                                (with-blur #f)
                                (with-shadow #f)
                                (window-rules (list (hypr-window-rule #:action 'float
                                                     #:class "pavucontrol"))))
    (let* ((wall (hypr-wallpaper #:active-palette active-palette
                                 #:clone-dir clone-dir))
           (wallpaper-setter (format #f
                                     (string-append "swww img ~a"
                                      " --transition-step 12"
                                      " --transition-fps 60"
                                      " --transition-type center") wall))
           (startup-programs (hypr-startup-programs #:active-palette
                                                    active-palette
                                                    #:wallpaper-setter
                                                    wallpaper-setter
                                                    #:extra-startups
                                                    extra-startups))
           (serialized-startup-programs (map (lambda (startup-item)
                                               (serialize-hypr-setting 'exec-once
                                                startup-item))
                                             startup-programs))
           (serialized-input (serialize-hypr-section #:section 'input
                                                     #:settings (hypr-input
                                                                 #:keyboard-layout
                                                                 keyboard-layout
                                                                 #:caps-to-ctrl
                                                                 keyboard-caps-to-ctrl)))
           (serialized-general (serialize-hypr-section #:section 'general
                                                       #:settings (hypr-general
                                                                   #:active-palette
                                                                   active-palette)))
           (serialized-decoration (serialize-hypr-section #:section 'decoration
                                                          #:settings (hypr-decoration
                                                                      #:with-blur
                                                                      with-blur
                                                                      #:with-shadow
                                                                      with-shadow)))
           (serialized-animations (serialize-hypr-section #:section 'animations
                                                          #:settings
                                                          hypr-animations))
           (serialized-key-bindings (string-join (hypr-binds
                                                             #:wallpaper-setter
                                                             wallpaper-setter)
                                                 "\n"))
           (serialized-window-rules (string-join (map (lambda (r)
                                                        (serialize-hypr-setting 'windowrulev2
                                                         r)) window-rules)
                                                 "\n"))
           (config-lines (append `("# ====== SSS Hypr configuration ======"
                                   "#"
                                   "# auto-generated file, DO NOT EDIT!"
                                   ""
                                   "# ====== Monitors ======"
                                   ,(string-join monitors "\n")
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
                                 `("" "# ====== Window rules ======"
                                   ,serialized-window-rules)
                                 `(""
                                   "# ====== End of SSS Hyprland configuration ======"
                                   ""))))
      
      (string-join config-lines "\n")))
  (export sss-hyprland-config))

