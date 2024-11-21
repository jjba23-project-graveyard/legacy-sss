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

(load "../../lib/proc.scm")
(load "./sway.scm")

(use-modules (gnu home)
             (gnu services)
             (guix gexp)
             (gnu packages gnupg)
             (gnu packages admin)
             (gnu home services)
             (gnu home services shells)
             (gnu home services sway)
             (gnu home services ssh)
             (gnu home services gnupg)
             (gnu home services shepherd)
             (gnu home services sound)
             (gnu home services desktop)
             (gnu home services fontutils))

(use-modules (sss-joe-sway)
             (sss-proc))


(define sss-fancy-bash-service
  (simple-service
   'sss-fancy-bash
   home-bash-service-type
   (home-bash-extension
    (environment-variables '())
    (bashrc `(,(local-file "bash/bashrc.sh"))))))

(define (emacs-conf-file file)
  (format #f ".emacs.d/~a" file ))

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

(define sss-mako-conf-location
  "/home/joe/Ontwikkeling/Persoonlijk/sss/home/joe/generated/mako")

(define sss-mako-conf
  '((sort . "-time")
    (max-history . "7")
    (on-button-left . "dismiss")
    (on-button-right . "invoke-default-action")
    (background-color . "#111111BB")
    (border-color . "#00552FBB")
    (text-color . "#FFFFFFFF")
    (font . "Intel One Mono 10")
    (width . "400")
    (icons . "1")
    (default-timeout . 12)
    ))

(define sss-gtk3-conf-location
  "/home/joe/Ontwikkeling/Persoonlijk/sss/home/joe/generated/gtk-3.0-settings.ini")

(define sss-gtk3-conf
  '((gtk-icon-theme-name . "Delft-Darkest")
    (gtk-theme-name . "Yaru-sage-dark")
    (gtk-font-name . "Liberation Sans 11")
    (gtk-key-theme-name . "Emacs")
    (gtk-enable-event-sounds . "0")
    (gtk-cursor-theme-name . "Yaru")
    (gtk-enable-input-feedback-sounds . "0")
    ))

(define sss-audio-service
  (service home-pipewire-service-type))

(define sss-home-vars-service
  (simple-service 'some-useful-env-vars-service
                  home-environment-variables-service-type
                  `(("GUIX_LOCPATH" . "$home/.guix-profile/lib/locale")                  
                    ("LANG" . "nl_NL.UTF-8")
                    ("XDG_CURRENT_DESKTOP" . "sway")
                    ("XDG_SESSION_TYPE" . "wayland")
                    ("WLR_NO_HARDWARE_CURSORS" . "1")
                    ("MOZ_ENABLE_WAYLAND" . "1")
                    ("QT_QPA_PLATFORM" . "wayland")
                    ("RTC_USE_PIPEWIRE" . "true")
                    ("SDL_VIDEODRIVER" . "wayland")
                    ("QT_WAYLAND_DISABLE_WINDOWDECORATION" . "1")
                    ("_JAVA_AWT_WM_NONREPARENTING" . "1")
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

(define sss-joe-fontconfig-service-type
  (simple-service 'additional-fonts-service
                  home-fontconfig-service-type
                  (list "~/.nix-profile/share/fonts"
                        '(alias
                          (family "monospace")
                          (prefer
                           (family "Intel One Mono"))))))


;;
;; start run
;;

(display "\n>>= generating xmodmap configuration...\n")
(mk-conf
 sss-xmodmap-conf-location
 (lambda ()
   (write-xmodmap-conf sss-xmodmap-conf
                       sss-xmodmap-conf-location)))

(display "\n>>= generating GTK 3 configuration...\n")
(mk-conf
 sss-gtk3-conf-location
 (lambda ()
   (write-gtk3-conf sss-gtk3-conf
                    sss-gtk3-conf-location)))

(display "\n>>= generating mako configuration...\n")
(mk-conf
 sss-mako-conf-location
 (lambda ()
   (write-equal-kv-conf sss-mako-conf
                        sss-mako-conf-location)))


;; (display "\n>>= setting up nix env...\n")
;; (syscall "ln -sfv /nix/var/nix/profiles/per-user/joe/profile /home/joe/.nix-profile")

;; (display "\n>>= installing nix packages\n")
;; (syscall "NIXPGS_ALLOW_UNFREE=1 nix profile upgrade --impure '.*'")
;; (for-each
;;  (lambda(x) (nix-profile-install x))
;;  '("vivaldi"
;;    "prismlauncher"
;;    "yaml-language-server"
;;    "jdt-language-server"
;;    "nil"
;;    "black"
;;    "pyright"
;;    "marksman"
;;    "_1password-gui"
;;    "_1password-cli"
;;    "stack"
;;    "sbt"
;;    "scala_2_13"
;;    "firefox"
;;    "thunderbird"
;;    "postman"
;;    "vscode-langservers-extracted"
;;    "nwg-look"
;;    ))


(define sss-home-files-service
  (service home-files-service-type
	   `((".xmodmap" ,(local-file  sss-xmodmap-conf-location))
             (".config/gtk-3.0/settings.ini" ,(local-file sss-gtk3-conf-location))
             (".config/guix/channels.scm" ,(local-file "channels.scm"))             
             (".gitconfig" ,(local-file "git/gitconfig.ini"))
             (".gitconfig-personal" ,(local-file "git/gitconfig-personal.ini"))
             (".gitconfig-work" ,(local-file "git/gitconfig-work.ini"))
             (".gitignore-global" ,(local-file "git/gitignore-global"))
             (".gitmessage-personal" ,(local-file "git/gitmessage-personal"))
             (".gitmessage-work" ,(local-file "git/gitmessage-work"))
             (".config/nix/nix.conf" ,(local-file "nix/nix.conf"))
             (".config/nixpkgs/config.nix" ,(local-file "nix/nixpkgs.nix"))
             (".config/conky/conky.conf" ,(local-file "conky/conkyrc.lua"))
             (".config/waybar/config.jsonc" ,(local-file "waybar/config.jsonc"))
             (".config/waybar/style.css" ,(local-file "waybar/style.css"))
             (".config/fuzzel/fuzzel.ini" ,(local-file "fuzzel/fuzzel.ini"))
             (".config/xdg-desktop-portal/portals.conf" ,(local-file "portals/portals.conf"))
             (".config/foot/foot.ini" ,(local-file "foot/foot.ini"))
             (".config/mako/config" ,(local-file sss-mako-conf-location))
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
   sss-joe-sway-service-type
   sss-joe-fontconfig-service-type
   
   )))

;;(".config/sway/config" ,(apply mixed-text-file (cons "sway-config" sss-sway-config)))
