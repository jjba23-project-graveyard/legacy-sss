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

(load "../../lib/proc.scm")
(load "./sway.scm")
(load "./foot.scm")
(load "./fuzzel.scm")
(load "./git.scm")
(load "./waybar.scm")
(load "./vars.scm")
(load "./ssh.scm")
(load "./mako.scm")
(load "./byggsteg.scm")
(load "./fontconfig.scm")
(load "./bash.scm")
(load "./gtk.scm")
(load "./openpgp.scm")
(load "./portals.scm")
(load "./xmodmap.scm")
(load "./enchant.scm")
(load "./qt.scm")
(load "./qutebrowser.scm")

(use-modules (gnu home)
             (gnu services)
             (guix gexp)
             (gnu packages admin)
             (gnu home services)
             (gnu home services shells)
             (gnu home services gnupg)
             (gnu home services shepherd)
             (gnu home services sound)
             (gnu home services desktop))

(use-modules (sss-sway)
             (sss-proc)
             (sss-foot)
             (sss-fuzzel)
             (sss-git)
             (sss-vars)
             (sss-mako)
             (sss-byggsteg)
             (sss-enchant)
             (sss-fontconfig)
             (sss-bash)
             (sss-gtk)
             (sss-portals)
             (sss-qt)
             (sss-xmodmap)
             (sss-openpgp)
             (sss-waybar)
             (sss-ssh)
             (sss-qutebrowser))

(use-modules (json))
(use-modules (sxml simple))

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
                                                           (mk-kv-conf-lines
                                                            sss-gtk3-config))))

             ;; GTK 4 settings
             (".config/gtk-4.0/settings.ini" ,(plain-file "settings.ini"
                                                          (string-append
                                                           "[Settings]\n"
                                                           (mk-kv-conf-lines
                                                            sss-gtk4-config))))

             ;; Guix channels configuration
             (".config/guix/channels.scm" ,(local-file "channels.scm"))

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
             (".config/nixpkgs/config.nix" ,(local-file "nix/nixpkgs.nix"))

             ;; Waybar configuration (for status bar)
             (".config/waybar/config.jsonc" ,(plain-file "config.jsonc"
                                                         (scm->json-string
                                                          sss-waybar-conf
                                                          #:pretty #t)))
             ;; Waybar styling
             (".config/waybar/style.css" ,(plain-file "waybar.css"
                                                      (mk-css-conf-lines
                                                       sss-waybar-css)))
             ;; Waybar Power menu from Scheme to XML format
             (".config/waybar/power_menu.xml" ,(plain-file "power_menu.xml"
                                                           (with-output-to-string (lambda ()
                                                                                    
                                                                                    
                                                                                    (sxml->xml
                                                                                     sss-waybar-power-menu)))))

             ;; Fuzzel (application launcher) configuration
             (".config/fuzzel/fuzzel.ini" ,(plain-file "fuzzel.ini"
                                                       (mk-rec-kv-conf-lines
                                                        sss-fuzzel-config)))

             ;; XDG desktop portal configuration (for flatpak apps)
             (".config/xdg-desktop-portal/portals.conf" ,(plain-file
                                                          "portals.conf"
                                                          (string-append
                                                           "[preferred]\n"
                                                           (mk-kv-conf-lines
                                                            sss-portals-config))))

             ;; Foot terminal configuration
             (".config/foot/foot.ini" ,(plain-file "foot.ini"
                                                   (mk-rec-kv-conf-lines
                                                    sss-foot-config)))

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
                                                      sss-qt6ct-config))

             ;; Mako (notification daemon) configuration
             (".config/mako/config" ,(plain-file "config"
                                                 (mk-kv-conf-lines
                                                  sss-mako-config)))

             ;; Enchant spell checker configuration
             ;; Enchant dictionary ordering
             (".enchant" ,(plain-file "enchant"
                                      (mk-lines sss-enchant-ordering)))
             (".config/enchant/en_US.dic" ,(plain-file "en_US.dic"
                                                       (mk-lines
                                                        sss-enchant-dict-en)))
             ;; Qutebrowser configurations (web browser)
             (".config/qutebrowser/config.py" ,(plain-file "config.py"
                                                           sss-qutebrowser-config))
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
             ;; Emacs configuration files
             ;; Emacs initialization file
             (".emacs.d/init.el" ,(local-file "emacs/init.el"))
             ;; Emacs early initialization file
             (".emacs.d/early-init.el" ,(local-file "emacs/early-init.el")))))

(display "\n>>= configuring home environment...\n")
(home-environment
  (packages (list pfetch))
  (services
   (list sss-home-files-service
         sss-ssh-service
         sss-home-vars-service
         sss-bash-service
         sss-openpgp-conf
         (service home-dbus-service-type)
         (service home-pipewire-service-type)
         (service sss-byggsteg-service-type)
         sss-sway-service-type
         sss-fontconfig-service-type)))

