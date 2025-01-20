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

;; Code:

(use-modules (gnu system file-systems))

;;; SSS defaults section

;; set default values for optional `per-host.scm' values
;; which can be overriden on a host-per-host basis

;; system language
(define sss-lang "en_US")

;; system timezone
(define sss-timezone "Europe/Amsterdam")

;; location where you cloned SSS Git repository
(define sss-clone-dir
  "/home/joe/Ontwikkeling/Persoonlijk/sss")

;; packages that should only be installed in the current host
(define sss-per-host-packages
  '())

;; active system color palette (overridden by per-host)
(define-public sss-active-palette
  'sss-palette-ef-dream)

;;; end SSS defaults section

;; load user preferences per-host
(load "../per-host.scm")

(load "../lib/path.scm")
(use-modules (sss path))

;; Autoload all Scheme modules in lib and subdirectories
;; All modules should have the `.scm' extension
(load-lib-modules)

;; Autoload all Scheme modules in home/<user> and subdirectories
;; Some special modules and files are skipped, such as `home.scm'
;; All modules should have the `.scm' extension
(load-home-modules "joe")

;; Load Guile modules
(use-modules (gnu home)
             (gnu services)
             (guix gexp)
             (gnu packages admin)
             (gnu home services)
             (gnu home services shells)
             (gnu home services ssh)
             (gnu home services gnupg)
             (gnu home services shepherd)
             (gnu home services sound)
             (gnu home services desktop)
             (json)
             (sxml simple))

;; Load SSS modules
(use-modules (sss sway)
             (sss process)
             (sss foot)
             (sss fuzzel)
             (sss git)
             (sss vars)
             (sss mako)
             (sss byggsteg)
             (sss enchant)
             (sss fontconfig)
             (sss bash)
             (sss gtk)
             (sss portals)
             (sss qt)
             (sss xmodmap)
             (sss openpgp)
             (sss waybar)
             (sss rofi)
             (sss ssh)
             (sss bridge emacs)
             (sss qutebrowser))

(define joe-ssh-hosts
  (list (openssh-host (name "wolk-jjba")
                      (user "joe")
                      (host-name "37.60.232.48")
                      (port 2323)
                      (identity-file "~/.ssh/wolk-jjba"))
        (openssh-host (name "personal.github.com")
                      (user "joe")
                      (host-name "github.com")
                      (identity-file "~/.ssh/gitlab_prive"))
        (openssh-host (name "gitlab.com")
                      (user "joe")
                      (host-name "gitlab.com")
                      (identity-file "~/.ssh/gitlab_prive"))
        (openssh-host (name "codeberg.org")
                      (user "joe")
                      (host-name "codeberg.org")
                      (identity-file "~/.ssh/gitlab_prive"))
        (openssh-host (name "work.github.com")
                      (user "joe")
                      (host-name "github.com")
                      (identity-file "~/.ssh/work_id"))))

;; Define user's home files (a.k.a. dotfiles)
(define sss-home-files-service
  (service home-files-service-type
           `( ;XModmap configuration file for example for Caps to Lock
              (".xmodmap" ,(plain-file "xmodmap"
                                       (mk-kv-conf-lines sss-xmodmap-config
                                        #:template spaced-equal-conf-pair)))

             ;; GTK 3 settings
             (".config/gtk-3.0/settings.ini" ,(plain-file "settings.ini"
                                                          (string-append
                                                           "[Settings]\n"
                                                           (mk-kv-conf-lines (sss-gtk3-config
                                                                              #:sss-active-palette
                                                                              sss-active-palette)))))

             ;; GTK 4 settings
             (".config/gtk-4.0/settings.ini" ,(plain-file "settings.ini"
                                                          (string-append
                                                           "[Settings]\n"
                                                           (mk-kv-conf-lines (sss-gtk4-config
                                                                              #:sss-active-palette
                                                                              sss-active-palette)))))

             ;; Guix channels configuration
             (".config/guix/channels.scm" ,(local-file "../lib/channels.scm"))

             ;; Git configuration
             ;; Global Git configuration
             (".gitconfig" ,(plain-file "gitconfig.ini"
                                        (mk-rec-kv-conf-lines sss-gitconfig
                                         #:template spaced-equal-conf-pair)))
             ;; Personal Git configuration
             (".gitconfig-personal" ,(plain-file "gitconfig-personal.ini"
                                                 (mk-rec-kv-conf-lines
                                                  sss-gitconfig-personal
                                                  #:template
                                                  spaced-equal-conf-pair)))
             ;; Work Git configuration
             (".gitconfig-work" ,(plain-file "gitconfig-work.ini"
                                             (mk-rec-kv-conf-lines
                                              sss-gitconfig-work
                                              #:template
                                              spaced-equal-conf-pair)))

             ;; Global Git ignore and message configuration
             (".gitignore-global" ,(plain-file "gitignore-global"
                                               (mk-lines sss-gitignore-global)))
             ;; Personal Git commit message template
             (".gitmessage-personal" ,(plain-file "gitmessage-personal"
                                                  sss-gitmessage-personal))
             ;; Work-related Git commit message template
             (".gitmessage-work" ,(plain-file "gitmessage-work"
                                              sss-gitmessage-work))

             ;; Nix configuration
             ;; Nix configuration with experimental features
             (".config/nix/nix.conf" ,(plain-file "nix.conf"
                                                  (mk-rec-kv-conf-lines `((experimental-features . "nix-command flakes"))
                                                   #:template
                                                   spaced-equal-conf-pair)))
             ;; Loads Nixpkgs configuration locally
             (".config/nixpkgs/config.nix" ,(local-file
                                             "../lib/nix/nixpkgs.nix"))

             ;; Waybar configuration (for status bar)
             (".config/waybar/config.jsonc" ,(plain-file "config.jsonc"
                                                         (scm->json-string
                                                          sss-waybar-conf
                                                          #:pretty #t)))

             (".config/rofi/config.rasi" ,(plain-file "config.rasi"
                                                      sss-rofi-config))
             ;; Rofi styling
             (".config/rofi/sss-theme.rasi" ,(plain-file "sss-theme.rasi"
                                                         (mk-css-conf-lines
                                                          sss-rofi-theme)))

             ;; Waybar styling
             (".config/waybar/style.css" ,(plain-file "waybar.css"
                                                      (mk-css-conf-lines (sss-waybar-css
                                                                          #:sss-active-palette
                                                                          sss-active-palette))))
             ;; Waybar Power menu from Scheme to XML format
             (".config/waybar/power_menu.xml" ,(plain-file "power_menu.xml"
                                                           (with-output-to-string (lambda ()
                                                                                    
                                                                                    
                                                                                    (sxml->xml
                                                                                     sss-waybar-power-menu)))))

             ;; Fuzzel (application launcher) configuration
             (".config/fuzzel/fuzzel.ini" ,(plain-file "fuzzel.ini"
                                                       (mk-rec-kv-conf-lines (sss-fuzzel-config
                                                                              #:sss-active-palette
                                                                              sss-active-palette))))

             ;; XDG desktop portal configuration (for flatpak apps)
             (".config/xdg-desktop-portal/portals.conf" ,(plain-file
                                                          "portals.conf"
                                                          (string-append
                                                           "[preferred]\n"
                                                           (mk-kv-conf-lines
                                                            sss-portals-config))))

             ;; Foot terminal configuration
             (".config/foot/foot.ini" ,(plain-file "foot.ini"
                                                   (mk-rec-kv-conf-lines (sss-foot-config
                                                                          #:sss-active-palette
                                                                          sss-active-palette))))

             ;; Kvantum theme configuration
             (".config/Kvantum/kvantum.kvconfig" ,(plain-file
                                                   "kvantum.kvconfig"
                                                   (string-join (list
                                                                 "[General]"
                                                                 "theme=KvYaru-MATEDark")
                                                                "\n")))
             (".config/Kvantum/KvYaru-Green" ,(local-file
                                               "/run/current-system/profile/usr/share/Kvantum/KvYaru-Green"
                                               #:recursive? #t))
             (".config/Kvantum/KvYaru-MATE" ,(local-file
                                              "/run/current-system/profile/usr/share/Kvantum/KvYaru-MATE"
                                              #:recursive? #t))

             ;; Qt6 configuration
             (".config/qt6ct/qt6ct.conf" ,(plain-file "qt6ct.conf"
                                                      (sss-qt6ct-config
                                                       #:sss-active-palette
                                                       sss-active-palette)))

             ;; Qt5 configuration
             (".config/qt5ct/qt5ct.conf" ,(plain-file "qt5ct.conf"
                                                      (sss-qt5ct-config
                                                       #:sss-active-palette
                                                       sss-active-palette)))

             ;; Mako (notification daemon) configuration
             (".config/mako/config" ,(plain-file "config"
                                                 (mk-kv-conf-lines (sss-mako-config
                                                                    #:sss-active-palette
                                                                    sss-active-palette))))

             ;; Enchant spell checker configuration
             ;; Enchant dictionary ordering
             (".enchant" ,(plain-file "enchant"
                                      (mk-lines sss-enchant-ordering)))
             (".config/enchant/en_US.dic" ,(plain-file "en_US.dic"
                                                       (mk-lines
                                                        sss-enchant-dict-en)))
             ;; Qutebrowser configurations (web browser)
             (".config/qutebrowser/config.py" ,(plain-file "config.py"
                                                           (sss-qutebrowser-config
                                                            #:sss-active-palette
                                                            sss-active-palette)))
             (".config/qutebrowser/bookmarks/urls" ,(plain-file "urls"
                                                                (serialize-qutebrowser-urls
                                                                 sss-qutebrowser-bookmarks)))

             ;; Containers configuration (for Docker, Podman, etc.)
             ;; Specifies container registries
             (".config/containers/registries.conf" ,(plain-file
                                                     "registries.conf"
                                                     "unqualified-search-registries = ['docker.io', 'registry.fedoraproject.org', 'registry.access.redhat.com', 'registry.centos.org']"))
             ;; Container security policy
             (".config/containers/policy.json" ,(plain-file "policy.json"
                                                 "{\"default\": [{\"type\": \"insecureAcceptAnything\"}]}"))
             ;; Emacs initialization file
             (".emacs.d/init.el" ,(local-file "../lib/emacs/init.el"))
             ;; Emacs bridge with SSS
             (".emacs.d/sss-bridge.el" ,(plain-file "sss-bridge.el"
                                                    (sss-bridge-emacs
                                                     #:sss-active-palette
                                                     sss-active-palette)))
             ;; Emacs early initialization file
             (".emacs.d/early-init.el" ,(local-file
                                         "../lib/emacs/early-init.el")))))

;; Configure user's Guix home environment
(display "\n>>= configuring home environment...\n")
(home-environment
 (packages (list pfetch))
 (services
  (list sss-home-files-service
        (sss-ssh-service #:ssh-hosts joe-ssh-hosts)
        (sss-home-vars-service #:sss-clone-dir sss-clone-dir
                               #:sss-lang sss-lang)
        (sss-bash-service #:sss-clone-dir sss-clone-dir)
        sss-openpgp-conf
        (service home-dbus-service-type)
        (service home-pipewire-service-type)
        (service sss-byggsteg-service-type)
        (sss-sway-service-type #:sss-clone-dir sss-clone-dir)
        sss-fontconfig-service-type)))

