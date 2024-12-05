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
(load "./sway.scm") (load "./foot.scm")
(load "./fuzzel.scm") (load "./git.scm")
(load "./waybar.scm") (load "./vars.scm")
(load "./ssh.scm") (load "./mako.scm")
(load "./byggsteg.scm") (load "./fontconfig.scm")
(load "./bash.scm") (load "./gtk.scm")
(load "./openpgp.scm") (load "../../doc.scm")
(load "./portals.scm") (load "./xmodmap.scm")
(load "./enchant.scm")

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

(use-modules (sss-sway) (sss-proc)
             (sss-foot) (sss-fuzzel)
             (sss-git) (sss-vars)
             (sss-mako) (sss-byggsteg)
             (sss-doc) (sss-enchant)
             (sss-fontconfig) (sss-bash)
             (sss-gtk) (sss-portals)
             (sss-xmodmap) (sss-openpgp)             
             (sss-waybar) (sss-ssh))

(use-modules (json))
(use-modules (sxml simple))


(define sss-home-files-service
  (service
   home-files-service-type
   `((".xmodmap"
      ,(plain-file "xmodmap"
                   (mk-kv-conf-lines sss-xmodmap-config
                                     #:template spaced-equal-conf-pair)))
     (".config/gtk-3.0/settings.ini"
      ,(plain-file "settings.ini"
                   (string-append "[Settings]\n"
                                  (mk-kv-conf-lines sss-gtk-config))))
     (".config/gtk-4.0/settings.ini"
      ,(plain-file "settings.ini"
                   (string-append "[Settings]\n"
                                  (mk-kv-conf-lines sss-gtk-config))))
     (".config/guix/channels.scm" ,(local-file "channels.scm"))             
     (".gitconfig"
      ,(plain-file "gitconfig.ini"
                   (mk-rec-kv-conf-lines sss-gitconfig
                                         #:template spaced-equal-conf-pair)))
     (".gitconfig-personal"
      ,(plain-file "gitconfig-personal.ini"
                   (mk-rec-kv-conf-lines sss-gitconfig-personal
                                         #:template spaced-equal-conf-pair)))
     (".gitconfig-work"
      ,(plain-file "gitconfig-work.ini"
                   (mk-rec-kv-conf-lines sss-gitconfig-work
                                         #:template spaced-equal-conf-pair)))
     (".gitignore-global"
      ,(plain-file "gitignore-global"
                   (mk-lines sss-gitignore-global)))
     (".gitmessage-personal"
      ,(plain-file "gitmessage-personal" sss-gitmessage-personal))
     (".gitmessage-work"
      ,(plain-file "gitmessage-work" sss-gitmessage-work))
     (".config/nix/nix.conf"
      ,(plain-file "nix.conf"
                   (mk-rec-kv-conf-lines
                    `((experimental-features . "nix-command flakes"))
                    #:template spaced-equal-conf-pair)))
     (".config/nixpkgs/config.nix" ,(local-file "nix/nixpkgs.nix"))
     (".config/waybar/config.jsonc"
      ,(plain-file "config.jsonc"
                   (scm->json-string sss-waybar-conf #:pretty #t)))
     (".config/waybar/style.css"
      ,(plain-file "waybar.css"
                   (mk-css-conf-lines sss-waybar-css)))
     (".config/waybar/power_menu.xml"
      ,(plain-file "power_menu.xml"
                   (with-output-to-string
                     (lambda() (sxml->xml sss-waybar-power-menu))
                     )))
     (".config/fuzzel/fuzzel.ini"
      ,(plain-file "fuzzel.ini"
                   (mk-rec-kv-conf-lines sss-fuzzel-config)))
     (".config/xdg-desktop-portal/portals.conf"
      ,(plain-file "portals.conf"
                   (string-append "[preferred]\n"
                                  (mk-kv-conf-lines sss-portals-config))))
     (".config/foot/foot.ini"
      ,(plain-file "foot.ini"
                   (mk-rec-kv-conf-lines sss-foot-config)))
     (".config/mako/config"
      ,(plain-file "config"
                   (mk-kv-conf-lines sss-mako-config)))
     (".enchant" ,(plain-file "enchant"
                              (mk-lines sss-enchant-ordering)))
     (".config/enchant/en_US.dic" ,(plain-file "en_US.dic"
                                               (mk-lines sss-enchant-dict-en)))
     (".config/qutebrowser/bindings.py" ,(local-file "qutebrowser/bindings.py"))
     (".config/qutebrowser/config.py" ,(local-file "qutebrowser/config.py"))
     (".emacs.d/init.el" ,(local-file "emacs/init.el"))
     (".emacs.d/early-init.el" ,(local-file "emacs/early-init.el")))))

(display "\n>>= generating manual...\n")
(sss-write-manual)

(display "\n>>= configuring home environment...\n")
(home-environment
 (packages
  (list pfetch)) 
 (services
  (list 
   sss-home-files-service
   sss-ssh-service
   sss-home-vars-service
   sss-bash-service
   sss-openpgp-conf
   (service home-dbus-service-type)
   (service home-pipewire-service-type)
   (service sss-byggsteg-service-type)
   sss-sway-service-type
   sss-fontconfig-service-type
   )))


