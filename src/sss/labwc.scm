
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

(define-module (sss labwc)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sxml simple)
  #:use-module (sss palette)
  #:export (labwc-menu labwc-rc labwc-autostart labwc-config labwc-capability))

(define* (labwc-theme-config #:key sans-font)
  `((theme (name Numix)
           (icon Yaru)
           (titlebar (layout "icon:iconify,max,close")
                     (showTitle yes))
           (cornerRadius 8)
           (keepBorder yes)
           (dropShadows yes)
           (font (@ (place ActiveWindow))
                 (name ,sans-font)
                 (size 13)
                 (slant normal)
                 (weight normal))
           (font (@ (place InactiveWindow))
                 (name ,sans-font)
                 (size 13)
                 (slant normal)
                 (weight normal))
           (font (@ (place MenuHeader))
                 (name ,sans-font)
                 (size 13)
                 (slant normal)
                 (weight normal))
           (font (@ (place MenuItem))
                 (name ,sans-font)
                 (size 13)
                 (slant normal)
                 (weight normal))
           (font (@ (place OnScreenDisplay))
                 (name ,sans-font)
                 (size 13)
                 (slant normal)
                 (weight normal)))))

(define labwc-keyboard-config
  `((keyboard (layoutScope global)
              (repeatRate 25)
              (repeatDelay 600)
              ,(labwc-keybind #:bind "A-Tab"
                              #:name NextWindow)
              ,(labwc-keybind #:bind "A-S-Tab"
                              #:name PreviousWindow)
              ,(labwc-keybind #:bind "W-Return"
                              #:name Execute
                              #:command "xfce4-terminal")
              ,(labwc-keybind #:bind "W-t"
                              #:name Execute
                              #:command "xfce4-terminal")
              ,(labwc-keybind #:bind "W-/"
                              #:name Execute
                              #:command "rofi -show drun")
              ,(labwc-keybind #:bind "W-r"
                              #:name Execute
                              #:command "rofi -show run")
              ,(labwc-keybind #:bind "A-F3"
                              #:name Execute
                              #:command "rofi -show drun")
              ,(labwc-keybind #:bind "A-F4"
                              #:name Close)
              ,(labwc-keybind #:bind "W-l"
                              #:name Execute
                              #:command "hyprlock")
              ,(labwc-keybind #:bind "W-i"
                              #:name Execute
                              #:command "firefox")
              ,(labwc-keybind #:bind "W-b"
                              #:name Execute
                              #:command "nemo")
              ,(labwc-keybind #:bind "W-k"
                              #:name Close)
              ,(labwc-keybind #:bind "W-a"
                              #:name ToggleMaximize)
              (keybind (@ (key "A-Left"))
                       (action (@ (name MoveToEdge)
                                  (direction left))))
              (keybind (@ (key "A-Right"))
                       (action (@ (name MoveToEdge)
                                  (direction right))))
              (keybind (@ (key "A-Up"))
                       (action (@ (name MoveToEdge)
                                  (direction up))))
              (keybind (@ (key "A-Down"))
                       (action (@ (name MoveToEdge)
                                  (direction down))))
              (keybind (@ (key "W-Left"))
                       (action (@ (name SnapToEdge)
                                  (direction left))))
              (keybind (@ (key "W-Right"))
                       (action (@ (name SnapToEdge)
                                  (direction right))))
              (keybind (@ (key "W-Up"))
                       (action (@ (name SnapToEdge)
                                  (direction up))))
              (keybind (@ (key "W-Down"))
                       (action (@ (name SnapToEdge)
                                  (direction down))))
              (keybind (@ (key "A-Space"))
                       (action (@ (name ShowMenu)
                                  (menu client-menu)
                                  (atCursor no))))
              ,(labwc-keybind #:bind "XF86_AudioLowerVolume"
                              #:name Execute
                              #:command "amixer sset Master 5%-")
              ,(labwc-keybind #:bind "XF86_AudioRaiseVolume"
                              #:name Execute
                              #:command "amixer sset Master 5%+")
              ,(labwc-keybind #:bind "XF86_AudioMute"
                              #:name Execute
                              #:command "amixer sset Master toggle")
              ,(labwc-keybind #:bind "XF86_MonBrightnessUp"
                              #:name Execute
                              #:command "brightnessctl set 10%+")
              ,(labwc-keybind #:bind "XF86_MonBrightnessDown"
                              #:name Execute
                              #:command "brightnessctl set 10%-"))))

;; Work-in-progress: converting rc.xml to SXML
(define* (labwc-config #:key sans-font)
  `(*TOP* (*PI* xml "version=\"1.0\" encoding=\"UTF-8\"")
          (labwc_config (core (decoration server)
                              (gap 0)
                              (adaptiveSync no)
                              (allowTearing no)
                              (autoEnableOutputs yes)
                              (reuseOutputMode no)
                              (xwaylandPersistence yes))
                        (placement (policy cascade))
                        ,(labwc-theme-config #:sans-font sans-font)
                        (windowSwitcher (@ (show yes)
                                           (preview yes)
                                           (outlines yes)
                                           (allWorkspaces no))
                                        (fields (field (@ (content type)
                                                          (width "25%")))
                                                (field (@ (content
                                                           trimmed_identifier)
                                                          (width "25%")))
                                                (field (@ (content title)
                                                          (width "50%")))))
                        (resistance (screenEdgeStrength 20)
                                    (windowEdgeStrength 20)
                                    (unSnapThreshold 20)
                                    (unMaximizeThreshold 150))
                        (resize (popupShow Never)
                                (drawContents yes))
                        (focus (followMouse no)
                               (followMouseRequiresMovement yes)
                               (raiseOnFocus no))
                        (snapping (range 1)
                                  (overlay (@ (enabled yes))
                                           (delay (@ (inner 500)
                                                     (outer 500))))
                                  (topMaximize yes)
                                  (notifyClient always))
                        (desktops (popupTime 1000)
                                  (names (name Default)))
                        ,labwc-keyboard-config)))

(define* (labwc-keybind #:key bind name
                        (command #f))
  `((keybind (@ (key ,bind))
             ,(if (not command)
                  `((action (@ (name ,name))))
                  `((action (@ (name ,name)
                               (command ,command))))))))

(define labwc-menu
  `(*TOP* (*PI* xml "version=\"1.0\" encoding=\"UTF-8\"")
          (openbox_menu (menu (@ (id client-menu))
                              (item (@ (label "Minimize"))
                                    (action (@ (name Iconify))))
                              (item (@ (label "Maximize"))
                                    (action (@ (name ToggleMaximize))))
                              (item (@ (label "Fullscreen"))
                                    (action (@ (name ToggleFullscreen))))
                              (item (@ (label "Roll Up/Down"))
                                    (action (@ (name ToggleShade))))
                              (item (@ (label "Decorations"))
                                    (action (@ (name ToggleDecorations))))
                              (item (@ (label "Always on Top"))
                                    (action (@ (name ToggleAlwaysOnTop))))
                              ;; Any menu with the id "workspaces" will be hidden
                              ;; if there is only a single workspace available.
                              (menu (@ (id workspaces)
                                       (label "Workspace"))
                                    (item (@ (label "Move Left"))
                                          (action (@ (name SendToDesktop)
                                                     (to left))))
                                    (item (@ (label "Move Right"))
                                          (action (@ (name SendToDesktop)
                                                     (to right))))
                                    (item (@ (label
                                              "Always on Visible Workspace"))
                                          (action (@ (name ToggleOmnipresent)))))
                              (item (@ (label "Close"))
                                    (action (@ (name Close)))))
                        (menu (@ (id root-menu))
                              (item (@ (label "Web - Chrome"))
                                    (action (@ (name Execute)
                                               (command "google-chrome-beta"))))
                              (item (@ (label "Web - Firefox"))
                                    (action (@ (name Execute)
                                               (command "firefox"))))
                              (item (@ (label "Terminal"))
                                    (action (@ (name Execute)
                                               (command "xfce4-terminal"))))
                              (item (@ (label "File Manager"))
                                    (action (@ (name Execute)
                                               (command "nemo"))))
                              (item (@ (label "Text Editor"))
                                    (action (@ (name Execute)
                                               (command "geany"))))
                              (item (@ (label "Reconfigure"))
                                    (action (@ (name Reconfigure))))
                              (item (@ (label "Exit"))
                                    (action (@ (name Exit))))
                              (item (@ (label "Sleep"))
                                    (action (@ (name Execute)
                                               (command "loginctl suspend"))))
                              (item (@ (label "Power off"))
                                    (action (@ (name Execute)
                                               (command "loginctl poweroff"))))))))

(define labwc-rc
  (local-file "./labwc/rc.xml"))

(define (mk-labwc-autostart cmd)
  (format #f "~a >/dev/null 2>&1 &" cmd))

(define* (labwc-autostart #:key (extra-startups '()))
  (plain-file "autostart"
              (string-join (append extra-startups
                                   (map mk-labwc-autostart
                                        '("lxsession" "mako"
                                          "dbus-update-activation-environment --all"
                                          "transmission-daemon"
                                          "waybar"
                                          "herd trigger set-random-wallpaper"
                                          "transmission-daemon"
                                          "podman system service --time=0 unix:///tmp/podman.sock"
                                          "xdg-user-dirs-update"))) "\n")))

(define* (labwc-capability #:key extra-startups sans-font)
  `((".config/labwc/rc.xml" ,(plain-file "rc.xml"
                                         (with-output-to-string (lambda ()
                                                                  (sxml->xml (labwc-config
                                                                              #:sans-font
                                                                              sans-font))))))
    (".config/labwc/menu.xml" ,(plain-file "menu.xml"
                                           (with-output-to-string (lambda ()
                                                                    (sxml->xml
                                                                     labwc-menu)))))
    (".config/labwc/autostart" ,(labwc-autostart #:extra-startups
                                                 extra-startups))))

