;;; home.scm

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

(use-modules (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu packages emacs)
             (gnu home services sway)
             (gnu packages admin)
             (gnu packages terminals)
             (gnu home services shepherd)
             (gnu services)
             (guix gexp))
(use-modules (gnu home services ssh)
             (gnu home services gnupg)
             (gnu packages wm)
             (gnu packages gnupg))
(use-modules (gnu home services sound)
             (gnu home services desktop))
(use-modules (gnu services shepherd))


(load "./proc.scm")

(define sss-fancy-bash-service
  (simple-service
   'sss-fancy-bash
   home-bash-service-type
   (home-bash-extension
    (environment-variables '())
    (bashrc `(,(local-file "bash/bashrc.sh"))))))

(define (emacs-conf-file file)
  (format #f ".emacs.d/~a" file ))

(define sss-picom-conf-location
  "/home/joe/Ontwikkeling/Persoonlijk/sss/home/joe/generated/picom.conf")

(define sss-picom-conf
  '((backend . "\"xrender\"")
    (corner-radius . "14")
    (fading . "true")
    (fade-in-step . "0.24")
    (fade-out-step . "0.24")
    (shadow . "false")))
;;(shadow-radius . "8")
;;(shadow-opacity . "0.65")

(define sss-kitty-conf-location
  "/home/joe/Ontwikkeling/Persoonlijk/sss/home/joe/generated/kitty.conf")

(define sss-kitty-conf
  '((font_family . "Intel One Mono")
    (font_size . 12.0)
    (scrollback_lines . 10000000)
    (window_padding_width . 12)
    (background_opacity . "0.8")
    ("map alt+w" . copy_to_clipboard)
    ("map ctrl+y" . paste_from_clipboard)
    ("map alt+v" . scroll_page_up)
    ("map ctrl+v" . scroll_page_down)
    ("map alt+<" . scroll_home)
    ("map alt+>" . scroll_end)
    ))

(define sss-opengpg-conf
  (service home-gpg-agent-service-type
           (home-gpg-agent-configuration
            (pinentry-program
             (file-append pinentry-emacs "/bin/pinentry-emacs"))
            (ssh-support? #t))))

(define sss-xmodmap-conf-location
  "/home/joe/Ontwikkeling/Persoonlijk/sss/home/joe/generated/xmodmap")

(define sss-xmodmap-conf
  '(("remove Lock" . "Caps_Lock")
    ("keysym Caps_Lock" . "Control_L")
    ("add Control" . "Control_L")
    ))


(define sss-gtk3-conf-location
  "/home/joe/Ontwikkeling/Persoonlijk/sss/home/joe/generated/gtk-3.0-settings.ini")

(define sss-gtk3-conf
  '((gtk-icon-theme-name . "Delft-Green-Darkest")
    (gtk-theme-name . "Yaru-sage-dark")
    (gtk-font-name . "Liberation Sans 12")
    (gtk-key-theme-name . "Emacs")
    (gtk-enable-event-sounds . "0")
    (gtk-cursor-theme-name . "Yaru-sage-dark")
    (gtk-enable-input-feedback-sounds . "0")
    ))

(define sss-audio-service
  (service home-pipewire-service-type))

(define sss-home-vars-service
  (simple-service 'some-useful-env-vars-service
                  home-environment-variables-service-type
                  `(
                    ;;("SBCL_HOME" . "$HOME/.guix-home/profile/lib/sbcl")
                    ("GUIX_LOCPATH" . "$home/.guix-profile/lib/locale")                  
                    ("LANG" . "nl_NL.UTF-8")
                    ("WLR_NO_HARDWARE_CURSORS" . "1")
                    ("LANGUAGE" . "nl_NL"))))




(define sss-ssh-service
  (service home-openssh-service-type
           (home-openssh-configuration
            (hosts
             (list
              (openssh-host (name "wolk-jjba")
                            (user "joe")
                            (host-name "37.60.232.48")
                            (port 2323)
                            (identity-file "~/.ssh/wolk-jjba"))
              (openssh-host (name "personal.github.com")
                            (user "joe")
                            (host-name "github.com")
                            (identity-file "~/.ssh/gitlab_prive"))
              (openssh-host (name "work.github.com")
                            (user "joe")
                            (host-name "github.com")
                            (identity-file "~/.ssh/work_id"))))
            (authorized-keys '()))))

(define (sss-byggsteg-service config)
  (list
   (shepherd-service
    (documentation "Run byggsteg as a daemon")
    (provision '(byggsteg))
    (requirement '())
    (start #~(make-forkexec-constructor
              '("make" "server")
              #:directory "/home/joe/Ontwikkeling/Persoonlijk/byggsteg"
              #:environment-variables
              (list
               "PATH=/home/joe/.nix-profile/bin:/home/joe/.guix-home/profile/bin:/home/joe/.guix-home/profile/sbin:/run/privileged/bin:/home/joe/.config/guix/current/bin:/home/joe/.guix-profile/bin:/run/current-system/profile/bin:/run/current-system/profile/sbin"
               "GIT_SSL_NO_VERIFY=1"
               "LANG=nl_NL.UTF-8")))
    (stop #~(make-kill-destructor))
    (auto-start? #t)
    (respawn? #t)
    )))

(define sss-byggsteg-service-type
  (service-type
   (name 'byggsteg)
   (description "Run byggsteg as a daemon")
   (extensions
    (list (service-extension
           home-shepherd-service-type
           sss-byggsteg-service)))
   (default-value '())
   ))

(define sss-sway-service-type
  (service home-sway-service-type
           (sway-configuration
            (gestures
             `((swipe:3:right . "workspace next_on_output")
               (swipe:3:left  . "workspace prev_on_output")
               (swipe:3:down  . "move to scratchpad")
               (swipe:3:up    . "scratchpad show"))
             )
            (startup-programs
             (list
              #~(string-append
                 #$swayidle "/bin/swayidle -w \\\n    "
                 ;; 300: lock screen.
                 "timeout 300 '" #$swaylock "/bin/swaylock "
                 "--indicator-radius 75 \\\n    "
                 "-i " #$sway
                 "/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png \\\n    "
                 "-f -c 000000' \\\n    "
                 ;; 600: lock + screen off.
                 "timeout 600 '" #$sway "/bin/swaymsg \"output * power off\"' \\\n    "
                 ;; Resume + sleep.
                 "resume '" #$sway "/bin/swaymsg \"output * power on\"' \\\n    "
                 "before-sleep '" #$swaylock "/bin/swaylock -f -c 000000'")
              "emacs --daemon"
              "waybar"
              )
             )
            (outputs
             (list (sway-output
                    (identifier '*)
                    (background (file-append sway
                                             "\
/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png")))))
            (variables
             `((mod   . "Mod4")
               (left  . "Left")
               (down  . "Down")
               (up    . "Up")
               (right . "Right")
               (term  . ,(file-append foot "/bin/foot"))
               (menu  . "fuzzel")))

            (modes
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
            
            ;; (variables `((mod . "Mod4")
            ;;              (term . ,(file-append foot "/bin/foot"))
            ;;              (Term . ,#~(string-append #$foot "/bin/foot"))))
            (keybindings
             `(($mod+Return . "exec $term")
               ($mod+k . "kill")
               ($mod+slash . "exec $menu")
               ($mod+e . "exec emacsclient -c")
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
               ($mod+minus . "scratchpad show")
               ($mod+r . "mode \"resize\""))
             )
            )
           ))

(define sss-joe-clone-repos
  (list
   "private-notes"
   "sss"
   "jointhefreeworld"
   "wikimusic-ssr"
   "wikimusic-api"
   "wolk-jjba"
   "zzspec"
   "byggsteg"
   "rephs"
   "welkomscherm.el"
   "free-alacarte"
   "scala-rank"
   "cloud-infra"
   "yggdrasil-schema"
   "modusregel"
   "keuringsdienst"
   "tekengrootte.el"
   "git-riddance.el"
   "hsresumebuilder"
   "wikimusic-api-spec"
   "wikimusic-model-hs"
   "yak"
   "social-media-jjba"
   "carvoeiro-water-fun"
   ))





;;
;; start run
;;

;; (display "\n>>= cloning personal repos...\n")
;; (for-each
;;  (lambda(x)
;;    (syscall
;;     (format #f "[ -d $HOME/Ontwikkeling/Persoonlijk/~a ] || git clone git@personal.github.com:jjba23/~a.git $HOME/Ontwikkeling/Persoonlijk/~a" x x x)))
;;  sss-joe-clone-repos)

(display "\n>>= generating picom configuration...\n")
(mk-conf
 sss-picom-conf-location
 (lambda ()
   (write-picom-conf sss-picom-conf
                     sss-picom-conf-location) ))

(display "\n>>= generating kitty configuration...\n")
(mk-conf
 sss-kitty-conf-location
 (lambda ()
   (write-kitty-conf sss-kitty-conf
                     sss-kitty-conf-location) ))

(display "\n>>= generating xmodmap configuration...\n")
(mk-conf
 sss-xmodmap-conf-location
 (lambda ()
   (write-xmodmap-conf sss-xmodmap-conf
                       sss-xmodmap-conf-location) ))

(display "\n>>= generating GTK 3 configuration...\n")
(mk-conf
 sss-gtk3-conf-location
 (lambda ()
   (write-gtk3-conf sss-gtk3-conf
                    sss-gtk3-conf-location) ))


(display "\n>>= setting up nix env...\n")
(syscall "ln -sfv /nix/var/nix/profiles/per-user/joe/profile /home/joe/.nix-profile")

(display "\n>>= installing nix packages\n")
(for-each
 (lambda(x) (nix-profile-install x))
 '("vivaldi"
   "prismlauncher"
   "yaml-language-server"
   "jdt-language-server"
   "nil"
   "black"
   "pyright"
   "marksman"
   "_1password-gui"
   "_1password"
   "stack"
   "sbt"
   "scala_2_13"
   "firefox"
   "thunderbird"
   "postman"
   "vscode-langservers-extracted"
   ))
;; (syscall "NIXPGS_ALLOW_UNFREE=1 nix profile upgrade --impure '.*'")


(define sss-home-files-service
  (service home-files-service-type
	   `((".config/kitty/kitty.conf" ,(local-file  sss-kitty-conf-location))
             (".stumpwm.d/init.lisp" ,(local-file "stumpwm/init.lisp"))
             (".stumpwm.d/keymaps.lisp" ,(local-file "stumpwm/keymaps.lisp"))
             (".stumpwm.d/colors.lisp" ,(local-file "stumpwm/colors.lisp"))
             (".stumpwm.d/autostarts.lisp" ,(local-file "stumpwm/autostarts.lisp"))
             (".config/picom.conf" ,(local-file sss-picom-conf-location))
             (".xmodmap" ,(local-file  sss-xmodmap-conf-location))
             (".config/gtk-3.0/settings.ini" ,(local-file sss-gtk3-conf-location))
             (".config/guix/channels.scm" ,(local-file "channels.scm"))
             (".config/rofi/config.rasi" ,(local-file "rofi/config.rasi"))
             (".gitconfig" ,(local-file "git/gitconfig.ini"))
             (".gitconfig-personal" ,(local-file "git/gitconfig-personal.ini"))
             (".gitconfig-work" ,(local-file "git/gitconfig-work.ini"))
             (".gitignore-global" ,(local-file "git/gitignore-global"))
             (".gitmessage-personal" ,(local-file "git/gitmessage-personal"))
             (".gitmessage-work" ,(local-file "git/gitmessage-work"))
             (".config/dunst/dunstrc" ,(local-file "dunst/dunstrc"))
             (".config/nix/nix.conf" ,(local-file "nix/nix.conf"))
             (".config/nixpkgs/config.nix" ,(local-file "nix/nixpkgs.nix"))
             (".config/conky/conky.conf" ,(local-file "conky/conkyrc.lua"))
             (".config/waybar/config.jsonc" ,(local-file "waybar/config.jsonc"))
             ;;(".config/sway/config" ,(local-file  sss-sway-conf-location))
             ;;(".config/sway/config" ,(apply mixed-text-file (cons "sway-config" sss-sway-config)))
             (,(emacs-conf-file "init.el") ,(local-file "emacs/init.el"))
	     (,(emacs-conf-file "early-init.el") ,(local-file "emacs/early-init.el")))))

(display "\n>>= configuring home environment...\n")
(home-environment
 (packages
  (list pfetch)) 
 (services
  (list 
   sss-home-files-service
   sss-ssh-service
   sss-home-vars-service
   sss-fancy-bash-service
   sss-opengpg-conf
   (service home-dbus-service-type)
   sss-audio-service
   (service sss-byggsteg-service-type)
   sss-sway-service-type
   )))



