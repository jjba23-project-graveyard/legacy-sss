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

;; load SSS defaults
(load "../system/sss-defaults.scm")

;; load user preferences per-host
(load "../per-host.scm")

;; show input settings
(load "../system/show-settings.scm")
(sss-show-settings)

(load "../lib/path.scm")

;; Autoload all Scheme modules in lib and subdirectories
;; All modules should have the `.scm' extension
(load-lib-modules)

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
             (sss openpgp)
             (sss waybar)
             (sss rofi)
             (sss ssh)
             (sss bridge emacs)
             (sss labwc)
             (sss qutebrowser))

;; Define user's home files (a.k.a. dotfiles)
(define sss-home-files-service
  (service home-files-service-type
           `( ;GTK 3 settings
              (".config/gtk-3.0/settings.ini" ,(plain-file "settings.ini"
                                                           (string-append
                                                            "[Settings]\n"
                                                            (mk-kv-conf-lines (sss-gtk3-config
                                                                               #:sss-active-palette
                                                                               sss-active-palette
                                                                               #:fixed-theme
                                                                               "Numix"
                                                                               #:fixed-icon-theme
                                                                               "Delft")))))

             ;; GTK 4 settings
             (".config/gtk-4.0/settings.ini" ,(plain-file "settings.ini"
                                                          (string-append
                                                           "[Settings]\n"
                                                           (mk-kv-conf-lines (sss-gtk4-config
                                                                              #:sss-active-palette
                                                                              sss-active-palette
                                                                              #:fixed-theme
                                                                              "Numix"
                                                                              #:fixed-icon-theme
                                                                              "Delft")))))

             ;; Guix channels configuration
             (".config/guix/channels.scm" ,(local-file "../lib/channels.scm"))

             ;; Global Git ignore and message configuration
             (".gitignore-global" ,(plain-file "gitignore-global"
                                               (mk-lines sss-gitignore-global)))

             ;; Nix configuration
             ;; Nix configuration with experimental features
             (".config/nix/nix.conf" ,(plain-file "nix.conf"
                                                  (mk-rec-kv-conf-lines `((experimental-features . "nix-command flakes"))
                                                   #:template
                                                   spaced-equal-conf-pair)))
             ;; Loads Nixpkgs configuration locally
             (".config/nixpkgs/config.nix" ,(local-file
                                             "../lib/nix/nixpkgs.nix"))

             ;; Rofi config
             (".config/rofi/config.rasi" ,(plain-file "config.rasi"
                                                      sss-rofi-config))
             ;; Rofi styling
             (".config/rofi/sss-theme.rasi" ,(plain-file "sss-theme.rasi"
                                                         (mk-css-conf-lines
                                                          sss-rofi-theme)))

             ;; Waybar configuration (for status bar)
             (".config/waybar/config.jsonc" ,(plain-file "config.jsonc"
                                                         (scm->json-string (sss-waybar-conf
                                                                            #:with-ip
                                                                            #f
                                                                            #:with-sway-workspaces
                                                                            #f
                                                                            #:with-memory
                                                                            #f)
                                                                           #:pretty
                                                                           #t)))

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

             ;; XDG desktop portal configuration (for flatpak apps)
             (".config/xdg-desktop-portal/portals.conf" ,(plain-file
                                                          "portals.conf"
                                                          (string-append
                                                           "[preferred]\n"
                                                           (mk-kv-conf-lines
                                                            sss-portals-config))))

             ;; Mako (notification daemon) configuration
             (".config/mako/config" ,(plain-file "config"
                                                 (mk-kv-conf-lines (sss-mako-config
                                                                    #:sss-active-palette
                                                                    sss-active-palette))))

             (".config/labwc/rc.xml" ,labwc-rc)
             (".config/labwc/menu.xml" ,labwc-menu)
             (".config/labwc/autostart" ,labwc-autostart)

             ;; Containers configuration (for Docker, Podman, etc.)
             ;; Specifies container registries
             (".config/containers/registries.conf" ,(plain-file
                                                     "registries.conf"
                                                     "unqualified-search-registries = ['docker.io', 'registry.fedoraproject.org', 'registry.access.redhat.com', 'registry.centos.org']"))
             ;; Container security policy
             (".config/containers/policy.json" ,(plain-file "policy.json"
                                                 "{\"default\": [{\"type\": \"insecureAcceptAnything\"}]}")))))

;; Configure user's Guix home environment
(display "\n>>= configuring home environment...\n")
(home-environment
  (packages (list pfetch))
  (services
   (list sss-home-files-service
         (sss-home-vars-service #:sss-clone-dir sss-clone-dir
                                #:sss-lang sss-lang)
         (sss-bash-service #:sss-clone-dir sss-clone-dir)
         sss-openpgp-conf
         (service home-dbus-service-type)
         (service home-pipewire-service-type)
         sss-fontconfig-service-type)))

