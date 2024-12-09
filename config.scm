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

(use-modules (gnu)
             (guix)
             (gnu system privilege)
             (gnu services)
             (guix packages))

(use-modules (nongnu packages linux)
             (nongnu system linux-initrd))

(load "./lib/proc.scm")
(load "./per-host.scm")
(load "./system/packages.scm")

(use-modules (sss-packages))

(use-service-modules networking desktop audio shepherd dbus base
                     xorg desktop configuration avahi nix xorg networking
                     sound cups mcron pm sddm)

(use-package-modules certs nfs mate lxqt libusb linux glib
                     sugar suckless scanner xdisorg avahi xfce
                     pulseaudio kde-plasma kde-frameworks kde gnome
                     freedesktop cups admin glib base idutils display-managers)


(define sss-joe-user-account
  (user-account
   (name "joe")
   (group "users")
   (supplementary-groups '("wheel" "netdev" "audio" "video" "input"))))

(define sss-manon-user-account
  (user-account
   (name "manon")
   (group "users")
   (supplementary-groups '("audio" "video" "netdev" "input"))))

(define (wikimusic-fetch-backups)
  (syscall "mkdir -p /home/joe/Documenten/wikimusic-backups && scp -r joe@wolk-jjba:/srv/wikimusic/backups/ /home/joe/Documenten/wikimusic-backups/"))

(define wikimusic-fetch-backups-job
  #~(job '(next-hour '(2 4 6 8 10 12 14 16 18 20))
         (lambda ()
           (wikimusic-fetch-backups))
         "wikimusic-fetch-backups"
         #:user "joe"))


(define sss-cron-jobs-service
  (simple-service 'sss-cron-jobs
                  mcron-service-type
                  (list wikimusic-fetch-backups-job
                        )))

(define sss-joe-mpd
  (service mpd-service-type
           (mpd-configuration
            (music-directory "/home/joe/Muziek")
            (playlist-directory "/home/joe/Muziek/Playlists"))))

(define sss-joe-subuid
  (simple-service
   'podman-subuid-subgid
   ;; If subuid/subgid will be needed somewhere else, the service must be
   ;; created to handle it.
   etc-service-type
   `(("subuid"
      ,(plain-file
        "subuid"
        (string-append "joe" ":100000:65536\n")))
     ("subgid"
      ,(plain-file
        "subgid"
        (string-append "joe" ":100000:65536\n"))))))

(define sss-iptables
  (service iptables-service-type
           (iptables-configuration)))

(define* (sss-desktop-services-for-system
          #:optional
          (system (or (%current-target-system)
                      (%current-system))))

  (cons*
   ;; Add udev rules for MTP devices so that non-root users can access
   ;; them.
   (simple-service 'mtp udev-service-type (list libmtp))
   ;; Add udev rules for scanners.
   (service sane-service-type)
   ;; Add polkit rules, so that non-root users in the wheel group can
   ;; perform administrative tasks (similar to "sudo").
   polkit-wheel-service

   (service cups-service-type
            (cups-configuration
             (web-interface? #t)
             (default-paper-size "Letter")
             (extensions (list cups-filters hplip-minimal))))

   ;; Allow desktop users to also mount NTFS and NFS file systems
   ;; without root.
   (simple-service 'mount-setuid-helpers privileged-program-service-type
                   (map file-like->setuid-program
                        (list (file-append nfs-utils "/sbin/mount.nfs")
                              (file-append ntfs-3g "/sbin/mount.ntfs-3g"))))


   (service sddm-service-type
            (sddm-configuration
             (theme "maya")))
   ;; (service lightdm-service-type
   ;;          (lightdm-configuration
   ;;           (allow-empty-passwords? #t)
   ;;           (xdmcp? #t)
   ;;           (vnc-server? #f)
   ;;           (debug? #t)
   ;;           (seats
   ;;            (list (lightdm-seat-configuration
   ;;                   (name "*")
   ;;                   (user-session "sway"))))))

   ;; The global fontconfig cache directory can sometimes contain
   ;; stale entries, possibly referencing fonts that have been GC'd,
   ;; so mount it read-only.
   fontconfig-file-system-service

   ;; NetworkManager and its applet.
   (service network-manager-service-type)
   (service wpa-supplicant-service-type)
   (simple-service 'network-manager-applet
                   profile-service-type
                   (list network-manager-applet))
   (service modem-manager-service-type)
   (service usb-modeswitch-service-type)

   ;; The D-Bus clique.
   (service avahi-service-type)
   (service udisks-service-type)
   (service upower-service-type)
   (service accountsservice-service-type)
   (service cups-pk-helper-service-type)
   (service colord-service-type)
   (service geoclue-service-type)
   (service polkit-service-type)
   (service dbus-root-service-type)
   (service elogind-service-type
            (elogind-configuration
             (kill-user-processes? #t)))

   (service
    openntpd-service-type
    (openntpd-configuration
     (listen-on '("127.0.0.1" "::1"))
     (sensor '("udcf0 correction 70000"))
     (constraint-from '("www.gnu.org"))
     (constraints-from '("https://www.google.com/"))))

   (service x11-socket-directory-service-type)

   (service bluetooth-service-type
            (bluetooth-configuration
             (experimental #t)
             (auto-enable? #t)))

   %base-services))

(define-syntax sss-desktop-services
  (identifier-syntax (sss-desktop-services-for-system)))

(operating-system
 (host-name "guixvm")
 (timezone "Europe/Amsterdam")

 (locale "nl_NL.utf8")
 (keyboard-layout (keyboard-layout "us"))
 
 (bootloader (bootloader-configuration
	      (bootloader grub-efi-bootloader)
	      (targets '("/boot/efi"))))
 
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (list linux-firmware))
 (kernel-arguments
  (list "console=ttyS0,115200"
        "noquiet"
        "nosplash"))
 (sudoers-file (local-file "system/sudoers"))
 
 (file-systems
  (append
   sss-filesystems
   %base-file-systems))
 
 (users
  (cons* sss-joe-user-account
         sss-manon-user-account
         %base-user-accounts))
 
 (packages
  (append sss-system-packages
          %base-packages))
 
 (services
  (cons* 
   (service nix-service-type)
   (service power-profiles-daemon-service-type)
   sss-iptables
   sss-joe-subuid
   sss-joe-mpd
   sss-cron-jobs-service
   sss-desktop-services
   )))




