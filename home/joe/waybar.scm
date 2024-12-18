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

(load "./palette.scm")

(define-module (sss-waybar)
  #:use-module (gnu)
  #:use-module (sss-palette))

;; Waybar power menu
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

;; My WayBar configurations, defined in Guile Scheme
;;
;; TODO list additional things and docs separately
;; for now here
;; 
;; (mpd) - (format .  "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} -
;; {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S})
;; ⸨{songPosition}|{queueLength}⸩ {volume}% ")
;; 
;; (clock) - (format-alt . "{:%Y-%m-%d}")
;;
(define-public sss-waybar-conf
  `((position . bottom) (height . 42)
    (spacing . 16)
    (margin-bottom . 10)
    (margin-right . 12)
    (margin-left . 12)
    (modules-left . #(clock sway/workspaces sway/mode sway/scratchpad custom/media sway/window))
    (modules-center)
    (modules-right . #(mpd idle_inhibitor pulseaudio network power-profiles-daemon cpu memory temperature backlight keyboard-state sway/language battery #{battery#bat2}# tray custom/power))
    (sway/workspaces (disable-scroll . #t)
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
                                   ;; ("urgent" . "") ("focused" . "")
                                   ))
    (keyboard-state (numlock . #t)
                    (capslock . #t)
                    (format . "{name} {icon} ")
                    (format-icons (locked . "\uf023")
                                  (unlocked . "\uf09c")))
    (sway/mode (format . "<span style=\"italic\">{}</span>"))
    (sway/scratchpad (format . "{icon} {count}")
                     (show-empty . #f)
                     (format-icons . #("" "\uf2d2"))
                     (tooltip . #t)
                     (tooltip-format . "{app}: {title}"))
    (mpd (format unquote
                 (string-append
                  "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}"
                  "{artist} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) "
                  "⸨{songPosition}|{queueLength}⸩ \uf001"))
         (format-disconnected . "Disconnected \uf001")
         (format-stopped . "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped \uf001")
         (unknown-tag . "N/A")
         (interval . 5)
         (consume-icons (on . "\uf0c4 "))
         (random-icons (off . "<span color=\"#f53c3c\">\uf074</span> ")
                       (on . "\uf074 "))
         (repeat-icons (on . "\uf01e "))
         (single-icons (on . "\uf01e1 "))
         (state-icons (paused . "\uf04c")
                      (playing . "\uf04b"))
         (tooltip-format . "MPD (connected)")
         (tooltip-format-disconnected . "MPD (disconnected)"))
    (idle_inhibitor (format . "{icon}")
                    (format-icons (activated . "\uf06e")
                                  (deactivated . "\uf070")))
    (tray (spacing . 10))
    (clock (format . "{:%H:%M %z - SSS/GNU - %a, %d %B %Y}")
           (tooltip-format . "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>")
           (interval . 60))
    (cpu (format . "{usage}% \uf2db")
         (tooltip . #f))
    (memory (format . "{}% \uf0c9"))
    (temperature (critical-threshold . 80)
                 (format . "{temperatureC}°C {icon}")
                 (format-icons . #("\uf2c9")))
    (backlight (format . "{percent}% {icon}")
               (format-icons . #("\ue38d" "\ue3d3" "\ue3d1" "\ue3cf" "\ue3ce" "\ue3cd" "\ue3ca" "\ue3c8" "\ue39b")))
    (battery (states (warning . 30)
                     (critical . 15))
             (format . "{capacity}% {icon}")
             (format-full . "{capacity}% {icon}")
             (format-charging . "{capacity}% \uf5e7")
             (format-plugged . "{capacity}% \uf1e6")
             (format-alt . "{time} {icon}")
             (format-icons . #("\uf244" "\uf243" "\uf242" "\uf241" "\uf240")))
    (#{battery#bat2}# (bat . "BAT2"))
    (power-profiles-daemon (format . "{icon}")
                           (tooltip-format . "Power profile: {profile}\nDriver: {driver}")
                           (tooltip . #t)
                           (format-icons (default . "\uf0e7")
                                         (performance . "\uf0e7")
                                         (balanced . "\uf24e")
                                         (power-saver . "\uf06c")))
    (network (format-wifi . "{essid} ({signalStrength}%) \uf1eb")
             (format-ethernet . "{ipaddr}/{cidr} \uf796")
             (tooltip-format . "{ifname} via {gwaddr} \uf796")
             (format-linked . "{ifname} (No IP) \uf796")
             (format-disconnected . "Disconnected ⚠")
             (format-alt . "{ifname}: {ipaddr}/{cidr}"))
    (pulseaudio (format . "{volume}% {icon} {format_source}")
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
                (on-click . "pavucontrol"))
    (custom/power (format . "⏻ ")
                  (tooltip . #f)
                  (menu . "on-click")
                  (menu-file . "$HOME/.config/waybar/power_menu.xml")
                  (menu-actions (shutdown . "sudo halt")
                                (reboot . "sudo reboot")
                                (suspend . "sudo loginctl suspend")
                                (hibernate . "sudo loginctl hibernate")))))

(define-public sss-waybar-css
  `((module (background . transparent)
            (padding-top . "6px")
            (padding-top . "6px")
            (padding-right . "12px")
            (padding-left . "12px")
            (padding-bottom . "6px")
            (font-family . "FontAwesome, Monaspace Neon")
            (font-weight . 500)
            (color unquote
                   (sss-get-color 'text)))
    ("#workspaces button" (font-size . "11pt"))
    ("#clock.date, #clock.time" (font-size . "9pt"))
    ("window#waybar" (background unquote
                                 (sss-hex-to-rgba (sss-get-color 'background)
                                                  #:alpha 0.75))
     (padding . "12px")
     (border-radius . "10px")
     (font-family . "FontAwesome, Monaspace Neon")
     (color unquote
            (sss-get-color 'text))
     (border unquote
             (format #f "2px solid ~a"
                     (sss-get-color 'primary-d))))
    (tooltip (background unquote
                         (sss-get-color 'background-l))
             (border-radius . 0))
    ("#workspaces" (padding-right . 0))
    ("#workspaces button" (padding . "4px")
     (color unquote
            (sss-get-color 'text)))
    ("#clock" (padding-right . "90px")
     (padding-left . "16px"))
    ("#workspaces button.active" (border unquote
                                         (format #f "2px solid ~a"
                                                 (sss-get-color 'primary-l)))
     (color unquote
            (sss-get-color 'background))
     (border-radius . 0)
     (margin-top . "2px")
     (transition . none))
    ("#workspaces button.focused" (color unquote
                                         (sss-get-color 'primary-l)))
    ("#workspaces button.urgent" (color . "#ef6560"))
    ("#workspaces button.hover" (color unquote
                                       (sss-get-color 'text))
     (background unquote
                 (sss-hex-to-rgba (sss-get-color 'background)
                                  #:alpha 0.7)))
    ("window#waybar.empty #window" (padding . 0)
     (margin . 0)
     (opacity . 0))
    ("#tray" (margin-right . "4px"))
    ("#keyboard-state" (font-size . "9pt"))
    ("#network" (font-size . "9pt"))
    ("#mpd" (font-size . "9pt"))
    ("#pulseaudio" (font-size . "9pt"))
    ("#cpu" (font-size . "9pt"))
    ("#memory" (font-size . "9pt"))))

