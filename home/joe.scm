;;; SSS - Supreme Sexp System

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

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
             (gnu system file-systems)
             (gnu home)
             (gnu services)
             (guix gexp)
             (gnu packages admin)
             (gnu home services)
             (gnu home services shells)
             (gnu home services mcron)
             (gnu home services ssh)
             (gnu home services gnupg)
             (gnu home services shepherd)
             (gnu home services sound)
             (gnu home services desktop)
             (sss prelude)
             (sss process)
             (sss foot)
             (sss git)
             (sss vars)
             (sss mako)
             (sss channels)
             (sss fastfetch)
             (sss enchant)
             (sss nix)
             (sss fontconfig)
             (sss hyprland hyprlang)
             (sss hyprland hyprland)
             (sss hyprland hyprlock)
             (sss wallpaper)
             (sss bash)
             (sss containers)
             (sss mime)
             (sss fish)
             (sss gtk)
             (sss portals)
             (sss alacritty)
             (sss qt)
             (sss openpgp)
             (sss dirs)
             (sss waybar)
             (sss rofi)
             (sss ssh)
             (sss firefox)
             (sss emacs))

;; show active SSS per-host settings
(log-exprs (setting-from-registry 'lang)
           (setting-from-registry 'timezone)
           (setting-from-registry 'keyboard-layout)
           (setting-from-registry 'caps-to-ctrl?)
           (setting-from-registry 'hostname)
           (setting-from-registry 'clone-dir)
           (setting-from-registry 'palette)
           (setting-from-registry 'hyprland-monitors)
           (setting-from-registry 'hyprland-extra-startups)
           (setting-from-registry 'labwc-extra-startups)
           (setting-from-registry 'flatpak-user-remotes)
           (length (setting-from-registry 'flatpak-pkgs))
           (length (setting-from-registry 'extra-packages))
           (length (setting-from-registry 'nixpkgs)))

(define sss-home-files-service
  (service home-files-service-type
           (append (sss-gtk3-svc #:palette (setting-from-registry 'palette))
                   (sss-gtk4-svc #:palette (setting-from-registry 'palette))
                   (sss-git-svc)
                   (sss-waybar-svc #:palette (setting-from-registry 'palette)
                                   #:sans-font (setting-from-registry 'sans-font)
                                   #:with-memory #t
                                   #:hyprland-session #t)
                   (sss-rofi-svc #:palette (setting-from-registry 'palette))
                   (sss-alacritty-svc #:palette (setting-from-registry 'palette)
                                      #:mono-font (setting-from-registry 'mono-font))
                   (sss-foot-svc #:palette (setting-from-registry 'palette))
                   (sss-hyprland-svc #:palette (setting-from-registry 'palette)
                                     #:clone-dir (setting-from-registry 'clone-dir)
                                     #:keyboard-layout (setting-from-registry 'keyboard-layout)
                                     #:caps-to-ctrl (setting-from-registry 'caps-to-ctrl?)
                                     #:monitors (setting-from-registry 'hyprland-monitors)
                                     #:extra-startups (setting-from-registry 'hyprland-extra-startups)
                                     #:with-blur #t
                                     #:with-shadow #t)
                   (sss-hyprlock-svc #:clone-dir (setting-from-registry 'clone-dir))
                   (sss-wallpaper-svc #:clone-dir (setting-from-registry 'clone-dir)
                                      #:palette (setting-from-registry 'palette))
                   (sss-mime-svc)
                   (sss-dirs-svc)
                   (sss-firefox-svc #:palette (setting-from-registry 'palette))
                   (sss-fastfetch-svc #:clone-dir (setting-from-registry 'clone-dir))
                   (sss-fish-svc #:clone-dir (setting-from-registry 'clone-dir)
                                 #:palette (setting-from-registry 'palette))
                   (sss-mako-svc #:palette (setting-from-registry 'palette)
                                 #:sans-font (setting-from-registry 'sans-font))
                   (sss-emacs-svc #:palette (setting-from-registry 'palette)
                                  #:user-name "Joe"
                                  #:user-full-name "Josep Bigorra"
                                  #:user-initials "JJBA"
                                  #:user-email "jjbigorra@gmail.com"
                                  #:clone-dir (setting-from-registry 'clone-dir)
                                  #:notes-roam-dir
                                  "$HOME/hacking/private-notes/roam"
                                  #:sans-font (setting-from-registry 'sans-font)
                                  #:mono-font (setting-from-registry 'mono-font))
                   (sss-nix-svc)
                   (sss-qt6-svc #:palette (setting-from-registry 'palette))
                   (sss-containers-svc)
                   (sss-portals-svc)
                   (sss-enchant-svc))))

(display "
>>= configuring Joe's home environment...
")

(home-environment
  (services
   (append (list sss-home-files-service
                 (sss-ssh-service)
                 (sss-home-vars-service #:palette sss-palette
                                        #:clone-dir (setting-from-registry 'clone-dir)
                                        #:lang sss-lang)
                 (sss-bash-service #:clone-dir (setting-from-registry 'clone-dir))
                 sss-openpgp-conf
                 (simple-service 'sss-home-cron-service
                                 home-mcron-service-type
                                 '())
                 (sss-random-wallpaper-service #:username "joe")
                 (service home-dbus-service-type)
                 (service home-pipewire-service-type)
                 sss-fontconfig-service-type
                 sss-channels-service) %base-home-services)))

