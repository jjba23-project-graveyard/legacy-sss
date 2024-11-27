;;; waybar.scm

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
  #:use-module (sss-palette)
  )


;; Waybar power menu
(define-public sss-waybar-power-menu
  '(*TOP*
    (*PI* xml "version=\"1.0\" encoding=\"UTF-8\"")
    (interface
     (object (@(class "GtkMenu") (id "menu"))
             (child (object (@(class "GtkMenuItem") (id "suspend"))
                            (property (@(name "label")) "Suspend")))
             (child (object (@(class "GtkMenuItem") (id "hibernate"))
                            (property (@(name "label")) "Hibernate")))
             (child (object (@(class "GtkSeparatorMenuItem") (id "delimiter1"))))
             (child (object (@(class "GtkMenuItem") (id "shutdown"))
                            (property (@(name "label")) "Shutdown")))
             (child (object (@(class "GtkMenuItem") (id "reboot"))
                            (property (@(name "label")) "Reboot")))
             ))))

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
  `((position . bottom)
    (height . 42)
    (spacing . 16)
    (margin-bottom . 10)
    (margin-right . 12)
    (margin-left . 12)
    (modules-left . #(clock sway/workspaces sway/mode
                            sway/scratchpad custom/media sway/window))
    (modules-center . ())
    (modules-right . #(mpd idle_inhibitor pulseaudio
                           network power-profiles-daemon cpu
                           memory temperature backlight
                           keyboard-state sway/language battery
                           battery#bat2 tray custom/power))
    (sway/workspaces . ((disable-scroll . #t)
                        (all-outputs . #t)
                        (warp-on-scroll . #f)
                        (format . "{icon}")
                        (format-icons . (("1" . "I") ("2" . "II") ("3" . "III")
                                         ("4" . "IV") ("5" . "V") ("6" . "VI")
                                         ("7" . "VII") ("8" . "VIII") ("9" . "IX")
                                         ("10" . "X") ("default" . "")
                                         ;; ("urgent" . "") ("focused" . "")
                                         ))))
    (keyboard-state . ((numlock . #t)
                       (capslock . #t)
                       (format . "{name} {icon} ")
                       (format-icons . ((locked . "")
                                        (unlocked . "")))))
    (sway/mode . ((format . "<span style=\"italic\">{}</span>")))
    (sway/scratchpad . ((format . "{icon} {count}")
                        (show-empty . #f)
                        (format-icons . #("" ""))
                        (tooltip . #t)
                        (tooltip-format . "{app}: {title}")))
    (mpd . ((format . ,(string-append
                        "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}"
                        "{artist} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) "
                        "⸨{songPosition}|{queueLength}⸩ "))
            (format-disconnected . "Disconnected ")
            (format-stopped . "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ")
            (unknown-tag . "N/A")
            (interval . 5)
            (consume-icons . ((on . " ")))
            (random-icons . ((off . "<span color=\"#f53c3c\"></span> ")
                             (on . " ")))
            (repeat-icons . ((on . " ")))
            (single-icons . ((on . "1 ")))
            (state-icons . ((paused . "")
                            (playing . "")))
            (tooltip-format . "MPD (connected)")
            (tooltip-format-disconnected . "MPD (disconnected)")))
    (idle_inhibitor . ((format . "{icon}")
                       (format-icons . ((activated . "")
                                        (deactivated . "")))))
    (tray . ((spacing . 10)))    
    (clock . ((format . "{:%H:%M %z - SSS/GNU - %a, %d %B %Y}")
              (tooltip-format . "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>")
              (interval . 60)))
    (cpu . ((format . "{usage}% ")
            (tooltip . #f)))
    (memory . ((format . "{}% ")))
    (temperature . ((critical-threshold . 80)
                    (format . "{temperatureC}°C {icon}")
                    (format-icons . #(""))))
    (backlight . ((format . "{percent}% {icon}")
                  (format-icons . #("" "" "" "" "" "" "" "" ""))))
    (battery . ((states . ((warning . 30)
                           (critical . 15)))
                (format . "{capacity}% {icon}")
                (format-full . "{capacity}% {icon}")
                (format-charging . "{capacity}% ")
                (format-plugged . "{capacity}% ")
                (format-alt . "{time} {icon}")
                (format-icons . #("" "" "" "" ""))))
    (battery#bat2 . ((bat . "BAT2")))
    (power-profiles-daemon . ((format . "{icon}")
                              (tooltip-format . "Power profile: {profile}\nDriver: {driver}")
                              (tooltip . #t)
                              (format-icons . ((default . "")
                                               (performance . "")
                                               (balanced . "")
                                               (power-saver . "")))))
    (network . ((format-wifi . "{essid} ({signalStrength}%) ")
                (format-ethernet . "{ipaddr}/{cidr} ")
                (tooltip-format . "{ifname} via {gwaddr} ")
                (format-linked . "{ifname} (No IP) ")
                (format-disconnected . "Disconnected ⚠")
                (format-alt . "{ifname}: {ipaddr}/{cidr}")))
    (pulseaudio . ((format . "{volume}% {icon} {format_source}")
                   (format-bluetooth . "{volume}% {icon} {format_source}")
                   (format-bluetooth-muted . " {icon} {format_source}")
                   (format-muted . " {format_source}")
                   (format-source . "{volume}% ")
                   (format-source-muted . "")
                   (format-icons . ((headphone . "")
                                    (hands-free . "")
                                    (headset . "")
                                    (phone . "")
                                    (portable . "")
                                    (car . "")
                                    (default . #("" "" ""))
                                    ))
                   (on-click . "pavucontrol")))
    (custom/power . ((format . "⏻ ")
                     (tooltip . #f)
                     (menu . "on-click")
                     (menu-file . "$HOME/.config/waybar/power_menu.xml")
                     (menu-actions . ((shutdown . "sudo halt")
                                      (reboot . "sudo reboot")
                                      (suspend . "sudo loginctl suspend")
                                      (hibernate . "sudo loginctl hibernate")))))
    ))

(define-public sss-waybar-css
  `((module . ((background . transparent)
               (padding-top . "6px")
               (padding-top .  "6px")
               (padding-right .  "12px")
               (padding-left .  "12px")
               (padding-bottom .  "6px")
               (font-family .  "FontAwesome, Intel One Mono")
               (font-weight .  500)
               (color . ,(sss-get-color 'text))
               ))
    ("#workspaces button" . ((font-size . "11pt")))
    ("#clock.date, #clock.time" . ((font-size . "9pt")))
    ("window#waybar" . ((background . ,(sss-hex-to-rgba (sss-get-color 'background) #:alpha 0.75))
                        (padding . "12px")
                        (border-radius . "10px")
                        (font-family .  "FontAwesome, Intel One Mono")
                        (color . ,(sss-get-color 'text))
                        (border . ,(format #f "2px solid ~a" (sss-get-color 'primary-d)))))
    (tooltip . ((background . ,(sss-get-color 'background-l))
                (border-radius . 0)))
    ("#workspaces" . ((padding-right . 0)))
    ("#workspaces button" . ((padding . "4px")
                             (color . ,(sss-get-color 'text))))
    ("#clock" . ((padding-right . "90px")
                 (padding-left . "16px")))
    ("#workspaces button.active" . ((border . ,(format #f "2px solid ~a" (sss-get-color 'primary-l)))
                                    (color . ,(sss-get-color 'background))
                                    (border-radius . 0)
                                    (margin-top . "2px")
                                    (transition . none)))
    ("#workspaces button.focused" . ((color . ,(sss-get-color 'primary-l))))
    ("#workspaces button.urgent" . ((color . "#ef6560")))
    ("#workspaces button.hover" . ((color . ,(sss-get-color 'text))
                                   (background . ,(sss-hex-to-rgba (sss-get-color 'background) #:alpha 0.70))))
    ("window#waybar.empty #window" . ((padding . 0)
                                      (margin . 0)
                                      (opacity . 0)))
    ("#tray" . ((margin-right . "4px")))
    ("#keyboard-state" . ((font-size . "9pt")))
    ("#network" . ((font-size . "9pt")))
    ("#mpd" . ((font-size . "9pt")))
    ("#pulseaudio" . ((font-size . "9pt")))
    ("#cpu" . ((font-size . "9pt")))
    ("#memory" . ((font-size . "9pt")))
    ))



