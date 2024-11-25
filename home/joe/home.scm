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
(load "./sway.scm") (load "./foot.scm")
(load "./fuzzel.scm") (load "./git.scm")
(load "./waybar.scm")

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
             (sss-proc)
             (sss-joe-foot)
             (sss-fuzzel)
             (sss-git)
             (sss-waybar))

(use-modules (json))
(use-modules (sxml simple))

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

(define sss-xmodmap-config
  '(("remove Lock" . "Caps_Lock")
    ("keysym Caps_Lock" . "Control_L")
    ("add Control" . "Control_L")
    ))

(define sss-mako-config
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

(define sss-portals-config
  '(("default" . "gtk")
    ("org.freedesktop.impl.portal.Screenshot" . "wlr")
    ("org.freedesktop.impl.portal.ScreenCast" . "wlr")))

(define sss-gtk3-config
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

(define sss-home-vars
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
    ("LANGUAGE" . "nl_NL")))

(define sss-home-vars-service
  (simple-service 'some-useful-env-vars-service
                  home-environment-variables-service-type
                  sss-home-vars))

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



(define sss-home-files-service
  (service
   home-files-service-type
   `((".xmodmap"
      ,(plain-file "xmodmap"
                   (mk-kv-conf-lines sss-xmodmap-config
                                     #:template "~a = ~a\n")))
     (".config/gtk-3.0/settings.ini"
      ,(plain-file "settings.ini"
                   (string-append "[Settings]\n"
                                  (mk-kv-conf-lines sss-gtk3-config))))
     (".config/guix/channels.scm" ,(local-file "channels.scm"))             
     (".gitconfig"
      ,(plain-file "gitconfig.ini"
                   (mk-rec-kv-conf-lines sss-gitconfig
                                         #:template "~a = ~a\n")))
     (".gitconfig-personal"
      ,(plain-file "gitconfig-personal.ini"
                   (mk-rec-kv-conf-lines sss-gitconfig-personal
                                         #:template "~a = ~a\n")))
     (".gitconfig-work"
      ,(plain-file "gitconfig-work.ini"
                   (mk-rec-kv-conf-lines sss-gitconfig-work
                                         #:template "~a = ~a\n")))
     (".gitignore-global"
      ,(plain-file "gitignore-global"
                   (mk-lines sss-gitignore-global)))
     (".gitmessage-personal"
      ,(plain-file "gitmessage-personal" sss-gitmessage-personal))
     (".gitmessage-work"
      ,(plain-file "gitmessage-work" sss-gitmessage-work))
     (".config/nix/nix.conf" ,(local-file "nix/nix.conf"))
     (".config/nixpkgs/config.nix" ,(local-file "nix/nixpkgs.nix"))
     (".config/waybar/config.jsonc"
      ,(plain-file "config.jsonc"
                   (scm->json-string sss-waybar-conf #:pretty #t)))
     (".config/waybar/style.css" ,(local-file "waybar/style.css"))
     (".config/waybar/power_menu.xml"
      ,(plain-file "power_menu.xml"
                   (with-output-to-string
                     (lambda() (sxml->xml sss-waybar-power-menu))
                     )
                   ))
     (".config/fuzzel/fuzzel.ini"
      ,(plain-file "fuzzel.ini"
                   (mk-rec-kv-conf-lines sss-fuzzel-config)))
     (".config/xdg-desktop-portal/portals.conf"
      ,(plain-file "portals.conf"
                   (string-append "[preferred]\n"
                                  (mk-kv-conf-lines sss-portals-config))))
     (".config/foot/foot.ini"
      ,(plain-file "foot.ini"
                   (mk-rec-kv-conf-lines sss-joe-foot-config)))
     (".config/mako/config"
      ,(plain-file "config"
                   (mk-kv-conf-lines sss-mako-config)))
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


;; TODO improve Nix package management

;; (define nixpkgs-updated-at
;;   (read-line "resources/sss-state/nixpkgs-updated-at"))


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
