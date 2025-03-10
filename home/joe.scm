;;; SSS - Supreme Sexp System

;; Copyright (C) 2025 - Josep Bigorra, jjba23 <jjbigorra@gmail.com>

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

(use-modules (gnu)
             (gnu bootloader)
             (gnu system file-systems))

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
             (gnu home services desktop))

;; Load SSS modules
(use-modules (sss process)
             (sss foot)
             (sss kitty)
             (sss git)
             (sss vars)
             (sss mako)
             (sss enchant)
             (sss fontconfig)
             (sss hyprland hyprlang)
             (sss hyprland hyprland)
             (sss hyprland hyprlock)
             (sss bash)
             (sss mime)
             (sss fish)
             (sss gtk)
             (sss nyxt)
             (sss portals)
             (sss qt)
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
           (append (sss-kitty-svc #:palette sss-active-palette)
                   (sss-gtk3-svc #:palette sss-active-palette)
                   (sss-gtk4-svc #:palette sss-active-palette)
                   (sss-git-svc)
                   (sss-waybar-svc #:palette sss-active-palette)
                   (sss-rofi-svc #:palette sss-active-palette)
                   (sss-foot-svc #:palette sss-active-palette)
                   (sss-hyprland-svc #:palette sss-active-palette
                                     #:clone-dir sss-clone-dir
                                     #:keyboard-layout sss-keyboard-layout
                                     #:caps-to-ctrl sss-keyboard-caps-to-ctrl
                                     #:monitors sss-hyprland-monitors
                                     #:extra-startups
                                     sss-hyprland-extra-startups
                                     #:with-blur #t
                                     #:with-shadow #t)
                   (sss-mime-svc)
                   (sss-nyxt-svc)
                   (sss-fish-svc #:clone-dir sss-clone-dir
                                 #:palette sss-active-palette)
                   (sss-mako-svc #:palette sss-active-palette)
                   (sss-qutebrowser-svc #:palette sss-active-palette)
                   `(
                     
                     ;; Guix channels configuration
                     (".config/guix/channels.scm" ,(local-file
                                                    "../lib/channels.scm"))

                     ;; Nix configuration
                     ;; Nix configuration with experimental features
                     (".config/nix/nix.conf" ,(plain-file "nix.conf"
                                                          (mk-rec-kv-conf-lines `
                                                           ((experimental-features . "nix-command flakes"))
                                                           #:template
                                                           spaced-equal-conf-pair)))
                     ;; Loads Nixpkgs configuration locally
                     (".config/nixpkgs/config.nix" ,(local-file
                                                     "../lib/nix/nixpkgs.nix"))

                     ;; XDG desktop portal configuration (for flatpak apps)
                     (".config/xdg-desktop-portal/portals.conf" ,(plain-file
                                                                  "portals.conf"
                                                                  (string-append
                                                                   "[preferred]\n"
                                                                   (mk-kv-conf-lines
                                                                    sss-portals-config))))

                     ;; Qt6 configuration
                     (".config/qt6ct/qt6ct.conf" ,(plain-file "qt6ct.conf"
                                                              (sss-qt6ct-config
                                                               #:active-palette
                                                               sss-active-palette)))

                     ;; Conky config
                     (".config/conky/conky.conf" ,(local-file
                                                   "../lib/conky/conky.lua"))

                     ;; Enchant spell checker configuration
                     ;; Enchant dictionary ordering
                     (".enchant" ,(plain-file "enchant"
                                              (mk-lines sss-enchant-ordering)))
                     (".config/enchant/en_US.dic" ,(plain-file "en_US.dic"
                                                               (mk-lines
                                                                sss-enchant-dict-en)))
                     ;; Hyprland configuration
                     
                     (".config/hypr/hyprlock.conf" ,(plain-file
                                                     "hyprlock.conf"
                                                     (sss-hyprlock-config
                                                      #:clone-dir
                                                      sss-clone-dir)))

                     ;; Containers configuration (for Docker, Podman, etc.)
                     ;; Specifies container registries
                     (".config/containers/registries.conf" ,(plain-file
                                                             "registries.conf"
                                                             "unqualified-search-registries = ['docker.io', 'registry.fedoraproject.org', 'registry.access.redhat.com', 'registry.centos.org']"))
                     ;; Container security policy
                     (".config/containers/policy.json" ,(plain-file
                                                         "policy.json"
                                                         "{\"default\": [{\"type\": \"insecureAcceptAnything\"}]}"))

                     ;; Emacs initialization file
                     (".emacs.d/init.el" ,(local-file "../lib/emacs/init.el"))
                     ;; Emacs bridge with SSS
                     (".emacs.d/sss-bridge.el" ,(plain-file "sss-bridge.el"
                                                            (sss-bridge-emacs
                                                             #:active-palette
                                                             sss-active-palette
                                                             #:user-name "Joe"
                                                             #:user-full-name
                                                             "Josep Bigorra"
                                                             #:user-email
                                                             "jjbigorra@gmail.com"
                                                             #:user-initials
                                                             "JJBA"
                                                             #:clone-dir
                                                             sss-clone-dir
                                                             #:notes-roam-dir
                                                             "$HOME/Ontwikkeling/Persoonlijk/private-notes/Roam")))
                     ;; Emacs early initialization file
                     (".emacs.d/early-init.el" ,(local-file
                                                 "../lib/emacs/early-init.el"))))))

;; Configure user's Guix home environment
(display "\n>>= configuring home environment...\n")
(home-environment
  (packages (list pfetch))
  (services
   (list sss-home-files-service
         (sss-ssh-service #:hosts joe-ssh-hosts)
         (sss-home-vars-service #:clone-dir sss-clone-dir
                                #:lang sss-lang)
         (sss-bash-service #:clone-dir sss-clone-dir)
         sss-openpgp-conf
         (service home-dbus-service-type)
         (service home-pipewire-service-type)
         sss-fontconfig-service-type)))

