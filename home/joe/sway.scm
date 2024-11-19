;;; sway.scm

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

(define-module (sss-joe-sway)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages admin)
  #:use-module (gnu home services shepherd)
  #:use-module (guix gexp)
  #:use-module (gnu home services sway)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services desktop)
  )

(define sss-joe-sway-gestures
  `((swipe:3:right . "workspace next_on_output")
    (swipe:3:left  . "workspace prev_on_output")
    (swipe:3:down  . "move to scratchpad")
    (swipe:3:up    . "scratchpad show")))

(define sss-joe-sway-wallpaper
  "/home/joe/Ontwikkeling/Persoonlijk/sss/resources/wallpapers/some-forest.jpg")

(define sss-joe-sway-startup-programs
  (list
   ;; #~(string-append
   ;;    #$swayidle "/bin/swayidle -w \\\n    "
   ;;    ;; 300: lock screen.
   ;;    "timeout 300 '" #$swaylock "/bin/swaylock "
   ;;    "--indicator-radius 75 \\\n    "
   ;;    "-i " #$sway
   ;;    #$sss-joe-sway-wallpaper " \\\n    "
   ;;    "-f -c 000000' \\\n    "
   ;;    ;; 600: lock + screen off.
   ;;    "timeout 600 '" #$sway "/bin/swaymsg \"output * power off\"' \\\n    "
   ;;    ;; Resume + sleep.
   ;;    "resume '" #$sway "/bin/swaymsg \"output * power on\"' \\\n    "
   ;;    "before-sleep '" #$swaylock "/bin/swaylock -f -c 000000'")
   "lxsession"
   "mako"
   "emacs --daemon"
   "dbus-update-activation-environment --all"
   "waybar"))

(define sss-joe-sway-outputs
  (list (sway-output
         (identifier '*)
         (background sss-joe-sway-wallpaper))))

(define sss-joe-sway-variables
  `((mod   . "Mod4")
    (left  . "Left")
    (down  . "Down")
    (up    . "Up")
    (right . "Right")
    (editor . "emacsclient -c")
    (browser . "/home/joe/.nix-profile/bin/vivaldi")
    (term  . ,(file-append foot "/bin/foot"))
    (menu  . "wofi --show run")))

(define sss-joe-sway-modes
  (list
   (sway-mode
    (mode-name "resize")
    (keybindings
     '(($left  . "resize shrink width 10px")
       ($down  . "resize grow height 10px")
       ($up    . "resize shrink height 10px")
       ($right . "resize grow width 10px")                  
       (Return . "mode \"default\"")
       (Escape . "mode \"default\""))))))


(define sss-joe-sway-keybindings
  `(($mod+Return . "exec $term")
    ($mod+t . "exec $term")
    ($mod+period . "exec grimshot copy active")
    ($mod+k . "kill")
    ($mod+slash . "exec $menu")
    ($mod+i . "exec $browser")
    ($mod+e . "exec $editor")
    ($mod+Shift+c . "reload")
    ($mod+Shift+e
     . ,#~(string-append
           "exec " #$sway "/bin/swaynag -t warning -m \\\n    "
           "'You pressed the exit shortcut.  Do you really want to exit sway?"
           " This will end your Wayland session.' \\\n    "
           "-B 'Yes, exit sway' \\\n    '"
           #$sway "/bin/swaymsg exit'"))
    ($mod+$left . "focus left")
    ($mod+$down . "focus down")
    ($mod+$up . "focus up")
    ($mod+$right . "focus right")
    ($mod+Shift+$left . "move left")
    ($mod+Shift+$down . "move down")
    ($mod+Shift+$up . "move up")
    ($mod+Shift+$right . "move right")
    ($mod+1 . "workspace number 1")
    ($mod+2 . "workspace number 2")
    ($mod+3 . "workspace number 3")
    ($mod+4 . "workspace number 4")
    ($mod+5 . "workspace number 5")
    ($mod+6 . "workspace number 6")
    ($mod+7 . "workspace number 7")
    ($mod+8 . "workspace number 8")
    ($mod+9 . "workspace number 9")
    ($mod+0 . "workspace number 10")
    ($mod+Shift+1 . "move container to workspace number 1")
    ($mod+Shift+2 . "move container to workspace number 2")
    ($mod+Shift+3 . "move container to workspace number 3")
    ($mod+Shift+4 . "move container to workspace number 4")
    ($mod+Shift+5 . "move container to workspace number 5")
    ($mod+Shift+6 . "move container to workspace number 6")
    ($mod+Shift+7 . "move container to workspace number 7")
    ($mod+Shift+8 . "move container to workspace number 8")
    ($mod+Shift+9 . "move container to workspace number 9")
    ($mod+Shift+0 . "move container to workspace number 10")
    ($mod+b . "splith")
    ($mod+v . "splitv")
    ($mod+s . "layout stacking")
    ($mod+w . "layout tabbed")
    ($mod+h . "layout toggle split")
    ($mod+f . "fullscreen")
    ($mod+Shift+space . "floating toggle")
    ($mod+space . "focus mode_toggle")
    ($mod+a . "focus parent")
    ($mod+Shift+minus . "move scratchpad")
    ($mod+Shift+m . "sway output Virtual-1 mode 1920x1200")
    ($mod+minus . "scratchpad show")
    ($mod+r . "mode \"resize\"")))

(define sss-joe-sway-extra-content
  (list
   "gaps inner 12"
   "gaps outer 8"

   ;; class                 border  backgr. text    indicator child_border
   "client.focused          #00552f #00552f #ffffff #00552f   #00552f"
   "client.focused_inactive #00552f #00552f #ffffff #00552f   #00552f"
   "client.unfocused        #333333 #222222 #808f80 #222222   #222222"
   "client.urgent           #b02930 #b02930 #cfdfd5 #900000   #900000"
   "client.placeholder      #000000 #0c0c0c #cfdfd5 #000000   #0c0c0c"
   "client.background       #cfdfd5"
   ))

(define-public sss-joe-sway-service-type
  (service home-sway-service-type
           (sway-configuration
            (gestures sss-joe-sway-gestures)
            (startup-programs sss-joe-sway-startup-programs)
            (outputs sss-joe-sway-outputs)
            (variables sss-joe-sway-variables)
            (modes sss-joe-sway-modes)
            (keybindings sss-joe-sway-keybindings)
            (extra-content sss-joe-sway-extra-content))))
