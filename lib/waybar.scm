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

(define-module (sss waybar)
  #:use-module (gnu)
  #:use-module (sss palette))

;; Waybar power menu, encoding XML as Scheme - SXML - s-expressions
(define-public sss-waybar-power-menu
  '(*TOP* (*PI* xml "version=\"1.0\" encoding=\"UTF-8\"")
          (interface (object (@ (class "GtkMenu")
                                (id "menu"))
                             (child (object (@ (class "GtkMenuItem")
                                               (id "suspend"))
                                            (property (@ (name "label"))
                                                      "Suspend")))
                             (child (object (@ (class "GtkMenuItem")
                                               (id "hibernate"))
                                            (property (@ (name "label"))
                                                      "Hibernate")))
                             (child (object (@ (class "GtkSeparatorMenuItem")
                                               (id "delimiter1"))))
                             (child (object (@ (class "GtkMenuItem")
                                               (id "shutdown"))
                                            (property (@ (name "label"))
                                                      "Shutdown")))
                             (child (object (@ (class "GtkMenuItem")
                                               (id "reboot"))
                                            (property (@ (name "label"))
                                                      "Reboot")))))))

(define sss-waybar-power-button
  `(custom/power (format . "⏻ ")
                 (tooltip . #f)
                 (menu . "on-click")
                 (menu-file . "$HOME/.config/waybar/power_menu.xml")
                 (menu-actions (shutdown . "sudo halt")
                               (reboot . "sudo reboot")
                               (suspend . "sudo loginctl suspend")
                               (hibernate . "sudo loginctl hibernate"))))

;;- SSS/GNU
(define sss-waybar-start-button
  `(custom/sss-waybar-start-button (format . "SSS/GNU")
                                   (on-click . "rofi -show drun")))

(define sss-waybar-audio-icon
  `(pulseaudio (format . "{volume}% {icon} {format_source}")
               (format-bluetooth . "{volume}% {icon}\uf294 {format_source}")
               (format-bluetooth-muted . "\uf6a9 {icon}\uf294 {format_source}")
               (format-muted . "\uf6a9 {format_source}")
               (format-source . "{volume}% \uf130")
               (format-source-muted . "\uf131")
               (format-icons (headphone . "\uf025")
                             (hands-free . "\uf590")
                             (headset . "\uf590")
                             (phone . "\uf095")
                             (portable . "\uf095")
                             (car . "\uf1b9")
                             (default . #("\uf026" "\uf027" "\uf028")))
               (on-click . "pavucontrol")))

(define sss-waybar-power-profiles
  `(power-profiles-daemon (format . "{icon}")
                          (tooltip-format . "Power profile: {profile}\nDriver: {driver}")
                          (tooltip . #t)
                          (format-icons (default . "\uf0e7")
                                        (performance . "\uf0e7")
                                        (balanced . "\uf24e")
                                        (power-saver . "\uf06c"))))

(define sss-waybar-battery-2
  `(#{battery#bat2}# (bat . "BAT2")))

(define sss-waybar-battery
  `(battery (states (warning . 30)
                    (critical . 15))
            (format . "{capacity}% {icon}")
            (format-full . "{capacity}% {icon}")
            (format-charging . "{capacity}% \uf5e7")
            (format-plugged . "{capacity}% \uf1e6")
            (format-alt . "{time} {icon}")
            (format-icons . #("\uf244" "\uf243" "\uf242" "\uf241" "\uf240"))))

(define sss-waybar-hyprland-workspaces
  `(hyprland/workspaces (disable-scroll . #t)
                        (all-outputs . #t)
                        (warp-on-scroll . #f)
                        (format . "{icon}")
                        (format-icons ("1" . "I")
                                      ("2" . "II")
                                      ("3" . "III")
                                      ("4" . "IV")
                                      ("5" . "V")
                                      ("6" . "VI")
                                      ("7" . "VII")
                                      ("8" . "VIII")
                                      ("9" . "IX")
                                      ("10" . "X")
                                      ("default" . "\uf111")
                                      )))

(define sss-waybar-clock
  `(clock (format . "{:%H:%M - %a, %d %B %Y}")
          (tooltip-format . "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>")
          (interval . 60)))

(define sss-waybar-ip
  `(network (format-wifi . "{essid} ({signalStrength}%) \uf1eb")
            (format-ethernet . "{ipaddr}/{cidr} \uf796")
            (tooltip-format . "{ifname} via {gwaddr} \uf796")
            (format-linked . "{ifname} (No IP) \uf796")
            (format-disconnected . "Disconnected ⚠")
            (format-alt . "{ifname}: {ipaddr}/{cidr}")))

(define sss-waybar-taskbar
  `(wlr/taskbar (format . "{icon} {title:.30}")
                (icon-size . 14)
                (icon-theme . "Adwaita")
                (tooltip-format . "{title}")
                (on-click . "activate")
                (on-click-middle . "minimize")))

(define sss-waybar-backlight
  `(backlight (format . "{percent}% {icon}")
              (format-icons . #("\ue38d" "\ue3d3" "\ue3d1" "\ue3cf" "\ue3ce" "\ue3cd" "\ue3ca" "\ue3c8" "\ue39b"))))


;; My WayBar configurations, defined in Guile Scheme, a status bar with a detailed, modular setup.
(begin
  (define* (sss-waybar-conf #:key (with-ip #f)
                            (with-hyprland-workspaces #f)
                            (with-memory #f)
                            (with-taskbar #f))
    (let ((modules-left (if with-taskbar
                            #(custom/sss-waybar-start-button clock wlr/taskbar)
                            #(custom/sss-waybar-start-button clock hyprland/workspaces custom/media hyprland/window))))
      `((position . bottom) (height . 42)
        (spacing . 12)
        (modules-left unquote modules-left)
        (modules-center)
        (modules-right . #(pulseaudio network power-profiles-daemon cpu memory backlight keyboard-state hyprland/language battery #{battery#bat2}# tray custom/power))
        ,sss-waybar-start-button
        ,(cond
          (with-hyprland-workspaces sss-waybar-hyprland-workspaces)
          (else `(hyprland/workspaces . null)))
        (keyboard-state (numlock . #t)
                        (capslock . #t)
                        (format . "{name} {icon} ")
                        (format-icons (locked . "\uf023")
                                      (unlocked . "\uf09c")))
        (hyprland/mode (format . "<span style=\"italic\">{}</span>"))
        (tray (spacing . 10))
        ,sss-waybar-clock
        (cpu (format . "{usage}% \uf2db")
             (tooltip . #f))
        ,(cond
          (with-memory `(memory (format . "{}% \uf0c9")))
          (else `(memory . null)))
        ,sss-waybar-backlight
        ,sss-waybar-battery
        ,sss-waybar-battery-2
        ,sss-waybar-power-profiles
        ,sss-waybar-taskbar
        ,(cond
          (with-ip sss-waybar-ip)
          (else `(network . null)))
        ,sss-waybar-audio-icon
        ,sss-waybar-power-button)))
  (export sss-waybar-conf))

;; Defines a CSS configuration for SSS Waybar using Scheme.
;; This configuration customizes various UI elements, such as background color,
;; padding, font styles, and colors, with dynamic values derived from functions
;; like `sss-get-color` and `sss-hex-to-rgba`.
;;
;; Key Features:
;; - Transparent background for the Waybar module with consistent padding.
;; - Specific styles for workspace buttons, clocks, and tooltips.
;; - Dynamic colors fetched from `sss-get-color` for consistency with theme settings.
;; - Use of transition effects and alpha blending to enhance UI responsiveness.
(begin
  (define* (sss-waybar-css #:key sss-active-palette)
    `((module (background . transparent)
              (padding-top . "6px")
              (padding-top . "6px")
              (padding-right . "12px")
              (padding-left . "12px")
              (padding-bottom . "6px")
              (font-family . "FontAwesome, Adwaita Mono")
              (font-weight . 500)
              (color unquote
                     (sss-get-color sss-active-palette
                                    'text)))
      ("#workspaces button" (font-size . "12pt"))
      ("#clock.date, #clock.time" (font-size . "10pt"))
      ("window#waybar" (background unquote
                                   (sss-hex-to-rgba (sss-get-color
                                                     sss-active-palette
                                                     'background)
                                                    #:alpha 0.8))
       (padding . "12px")
       (font-family . "FontAwesome, Adwaita Mono")
       (color unquote
              (sss-get-color sss-active-palette
                             'text)))
      (tooltip (background unquote
                           (sss-get-color sss-active-palette
                                          'background-l))
               (border-radius . 0))
      ("#custom-sss-waybar-start-button" (background unquote
                                                     (sss-hex-to-rgba (sss-get-color
                                                                       sss-active-palette
                                                                       'background)
                                                                      #:alpha
                                                                      1))
       (font-weight . 700)
       (margin . "8px")
       (padding-top . "4px")
       (padding-bottom . "4px")
       (padding-left . "8px")
       (padding-right . "8px")
       (border-radius . "10px"))
      ("#workspaces" (padding-right . 0))
      ("#workspaces button" (padding . "4px")
       (color unquote
              (sss-get-color sss-active-palette
                             'text)))
      ("#clock" (padding-right . "90px")
       (padding-left . "16px"))
      ("#workspaces button.active" (border unquote
                                           (format #f "2px solid ~a"
                                                   (sss-get-color
                                                    sss-active-palette
                                                    'primary-l)))
       (color unquote
              (sss-get-color sss-active-palette
                             'background))
       (border-radius . 0)
       (margin-top . "2px")
       (transition . none))
      ("#workspaces button.focused" (color unquote
                                           (sss-get-color sss-active-palette
                                                          'primary-l)))
      ("#workspaces button.urgent" (color . "#ef6560"))
      ("#workspaces button.hover" (color unquote
                                         (sss-get-color sss-active-palette
                                                        'text))
       (background unquote
                   (sss-hex-to-rgba (sss-get-color sss-active-palette
                                                   'background)
                                    #:alpha 0.7)))
      ("window#waybar.empty #window" (padding . 0)
       (margin . 0)
       (opacity . 0))
      ("#tray" (margin-right . "4px"))
      ("#keyboard-state" (font-size . "9pt"))
      ("#network" (font-size . "9pt"))
      ("#pulseaudio" (font-size . "9pt"))
      ("#cpu" (font-size . "9pt"))
      ("#memory" (font-size . "9pt"))))

  (export sss-waybar-css))
