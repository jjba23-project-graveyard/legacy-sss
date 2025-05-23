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
             (gnu home services ssh)
             (gnu home services gnupg)
             (gnu home services shepherd)
             (gnu home services sound)
             (gnu home services desktop)
             (json)
             (sxml simple)
             (sss prelude)
             (sss process)
             (sss foot)
             (sss git)
             (sss vars)
             (sss mako)
             (sss enchant)
             (sss fontconfig)
             (sss bash)
             (sss gtk)
             (sss nix)
             (sss containers)
             (sss wallpaper)
             (sss portals)
             (sss qt)
             (sss channels)
             (sss mime)
             (sss openpgp)
             (sss waybar)
             (sss rofi)
             (sss ssh)
             (sss labwc))

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
                   (sss-nix-svc)
                   (sss-rofi-svc #:palette (setting-from-registry 'palette))
                   (sss-mime-svc)
                   (sss-waybar-svc #:palette (setting-from-registry 'palette)
                                   #:sans-font (setting-from-registry 'sans-font)
                                   #:with-memory #f
                                   #:labwc-session #t
                                   #:sans-font (setting-from-registry 'sans-font))
                   (sss-portals-svc)
                   (sss-mako-svc #:palette (setting-from-registry 'palette)
                                 #:sans-font (setting-from-registry 'sans-font))
                   (sss-containers-svc)
                   (sss-wallpaper-svc #:clone-dir (setting-from-registry 'clone-dir)
                                      #:palette (setting-from-registry 'palette))
                   (sss-labwc-svc #:extra-startups sss-labwc-extra-startups))))

(display "
>>= configuring Manon's home environment...
")

(home-environment
 (services
  (append (list sss-home-files-service
                (sss-home-vars-service #:palette (setting-from-registry 'palette)
                                       #:clone-dir (setting-from-registry 'clone-dir)
                                       #:lang sss-lang)
                (sss-bash-service #:clone-dir (setting-from-registry 'clone-dir))
                sss-openpgp-conf
                (service home-dbus-service-type)
                (service home-pipewire-service-type)
                sss-fontconfig-service-type
                sss-channels-service) %base-home-services)))

