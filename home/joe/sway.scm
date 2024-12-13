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
(load "../../system/packages.scm")

(define-module (sss-sway)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages admin)
  #:use-module (gnu home services shepherd)
  #:use-module (guix gexp)
  #:use-module (sss-packages)
  #:use-module (gnu home services sway)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services desktop)
  #:use-module (sss-palette)
  )


(define sss-sway-gestures
  `((swipe:3:right . "workspace next_on_output")
    (swipe:3:left  . "workspace prev_on_output")
    (swipe:3:down  . "move to scratchpad")
    (swipe:3:up    . "scratchpad show")))

(define sss-sway-floating-windows
  `("org.kde.kcalc"
    "org.gnome.Calculator"
    "pavucontrol"
    ))

(define sss-sway-wallpaper
  "/home/joe/Ontwikkeling/Persoonlijk/sss/resources/wallpapers/some-forest.jpg")

(define sss-sway-startup-programs
  (list
   ;; #~(string-append
   ;;    #$swayidle "/bin/swayidle -w \\\n    "
   ;;    ;; 300: lock screen.
   ;;    "timeout 300 '" #$swaylock "/bin/swaylock "
   ;;    "--indicator-radius 75 \\\n    "
   ;;    "-i " #$sway
   ;;    #$sss-sway-wallpaper " \\\n    "
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
   "waybar"
   "transmission-daemon"
   "foot -s"
   ))

(define sss-sway-startup-reload-programs
  (let
      ((gtk-theme-name (cond
                        ((equal? sss-palette-ef-cyprus sss-active-palette)
                         "Adwaita"
                         )
                        (else "Adwaita")
                        )))

    `(
      ,(format #f "gsettings set $gnome-schema gtk-theme '~a'" gtk-theme-name)
      "gsettings set $gnome-schema icon-theme 'Breeze-dark'"
      "gsettings set $gnome-schema cursor-theme 'Breeze_cursors'"
      "gsettings set $gnome-schema cursor-size 32"
      "gsettings set $gnome-schema font-name 'Monaspace Neon'"
      ))
  )


(define-public sss-sway-outputs
  (list (sway-output
         (identifier '*)
         (background sss-sway-wallpaper))))

(define-public sss-sway-variables
  `((mod   . "Mod4")
    (left  . "Left")
    (down  . "Down")
    (up    . "Up")
    (right . "Right")
    (gnome-schema . "org.gnome.desktop.interface")
    (editor . "emacsclient -c")
    (bloated-browser . "/home/joe/.nix-profile/bin/vivaldi")
    (browser . "qutebrowser")
    (term  . "footclient")
    (password-manager . "/home/joe/.nix-profile/bin/1password")
    (menu  . "fuzzel")))

(define sss-sway-modes
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


(define-public sss-sway-keybindings
  `(($mod+Return . "exec $term")
    ($mod+t . "exec $term")
    ($mod+shift+period . "exec grimshot copy")
    ($mod+period . "exec grimshot save")
    ($mod+k . "kill")
    ($mod+slash . "exec $menu")
    ($mod+i . "exec $browser")
    ($mod+Shift+i . "exec $bloated-browser")
    ($mod+e . "exec $editor")
    ($mod+minus . "exec $password-manager")
    ($mod+Shift+c . "reload")
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
    ($mod+Shift+s . "scratchpad show")
    ($mod+Shift+e
     . ,#~(string-append
           "exec " #$sway "/bin/swaynag -t warning -m \\\n    "
           "'You pressed the exit shortcut.  Do you really want to exit sway?"
           " This will end your Wayland session.' \\\n    "
           "-B 'Yes, exit sway' \\\n    '"
           #$sway "/bin/swaymsg exit'"))
    ($mod+r . "mode \"resize\"")))

(define sss-swayfx-config
  `(
    "corner_radius 12"
    "shadows enable"
    "blur enable"
    "default_dim_inactive 0.2"
    "dim_inactive_colors.unfocused #000000FF"
    "dim_inactive_colors.urgent #900000FF"
    ))

(define sss-sway-extra-content
  `(
    "gaps inner 12"
    "gaps outer 8"

    ;; class                 border  backgr. text    indicator child_border
    ,(format #f "client.focused ~a ~a ~a ~a ~a"
             (sss-get-color 'primary)
             (sss-get-color 'primary)
             (sss-get-color 'text)
             (sss-get-color 'primary)
             (sss-get-color 'primary))
    ,(format #f "client.focused_inactive ~a ~a ~a ~a ~a"
             (sss-get-color 'primary)
             (sss-get-color 'primary)
             (sss-get-color 'text)
             (sss-get-color 'primary)
             (sss-get-color 'primary))
    ,(format #f "client.unfocused ~a ~a #808f80 ~a ~a"
             (sss-get-color 'background-l)
             (sss-get-color 'background-l)
             (sss-get-color 'background-l)
             (sss-get-color 'background-l)
             )
    "client.urgent           #b02930 #b02930 #cfdfd5 #900000   #900000"
    "client.placeholder      #000000 #0c0c0c #cfdfd5 #000000   #0c0c0c"
    ,(format #f "client.background ~a" (sss-get-color 'text))
    ))

(define-public sss-sway-service-type
  (service home-sway-service-type
           (sway-configuration
            (packages (list sss-swayfx))
            (gestures sss-sway-gestures)
            (startup-programs sss-sway-startup-programs)
            (startup+reload-programs sss-sway-startup-reload-programs)
            (outputs sss-sway-outputs)
            (variables sss-sway-variables)
            (modes sss-sway-modes)
            (keybindings sss-sway-keybindings)
            (extra-content
             (append sss-swayfx-config
                     (map (lambda(w) (format #f "for_window [app_id=\"~a\"] floating enable" w))
                          sss-sway-floating-windows)
                     sss-sway-extra-content)))))
