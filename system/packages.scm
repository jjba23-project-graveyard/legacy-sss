;;; packages.scm

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

(define-module (sss-packages)
  #:use-module (gnu)
  #:use-module (nongnu packages fonts)
  #:use-module (gnu services nix)
  #:use-module (guix git-download)
  #:use-module (guix build-system font)
  #:use-module (guix build-system copy)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (gnu packages wm)
  #:use-module (guix build-system meson)
  #:use-module ((guix licenses) #:prefix license:)

  )

(use-package-modules freedesktop base lxqt package-management
                     web linux gnuzilla ncurses xfce multiprecision gcc
                     aspell rust-apps inkscape gimp python-web mpd
                     python xdisorg imagemagick curl cups terminals
                     video image compression sqlite disk glib networking
                     fontutils lisp image-viewers gnome-xyz guile-xyz
                     compton ssh vpn version-control fonts pulseaudio
                     libreoffice wm docker lisp-xyz web-browsers audio
                     music display-managers file-systems tree-sitter lua
                     xorg admin screen node emacs lxde vim
                     haskell-apps gnome databases bittorrent shellutils)

(load "../per-host.scm")

(define sss-theme-packages
  (list
   yaru-theme
   delft-icon-theme
   ))

(define font-sss-intel-one-mono
  (package
   (name "font-sss-intel-one-mono")
   (version "1.4.0")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/intel/intel-one-mono")
                  (commit (string-append "V" version))))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "1snwxpcdxl62z1mcax19bmsmbw0hi6m0cqkxqz79ydynfch95sd0"))))
   ;;(outputs '("out" "ttf" "woff"))
   (build-system font-build-system)
   ;; (arguments
   ;;  `(#:phases %standard-phases))
   (home-page "https://github.com/intel/intel-one-mono")
   (synopsis "Expressive monospaced font family")
   (description
    "This package provides Intel One Mono, an expressive monospaced font
family that's built with clarity, legibility, and the needs of developers in
mind.")
   (license silofl1.1)))

(define sss-font-packages
  (list
   fontconfig
   font-google-roboto
   font-google-noto-emoji
   font-jetbrains-mono
   font-sss-intel-one-mono
   font-intel-one-mono
   font-liberation
   font-dejavu
   font-microsoft-web-core-fonts
   font-apple-sf-pro
   font-apple-sf-compact
   font-apple-sf-mono
   font-apple-new-york
   font-awesome
   font-fira-code
   font-apple-sf-symbols
   font-google-noto))

(define sss-wm-packages
  (list
   cl-asdf
   swayfx
   swaybg
   swaylock
   swayidle
   foot
   waybar-experimental
   wmenu
   
   mako
   fuzzel
   grimshot
   wl-color-picker
   qpwgraph
   wireplumber
   pipewire

   ;; Wayland portals
   xdg-desktop-portal
   xdg-desktop-portal-wlr
   xdg-desktop-portal-gtk
   
   
   ;; Compatibility for older Xorg applications
   xorg-server-xwayland

   ;; LXQt suite
   lxqt-policykit
   lxqt-session
   lxqt-config
   lxqt-admin
   lxqt-sudo
   lxqt-powermanagement
   lxqt-themes
   qterminal
   pcmanfm-qt
   lxqt

   ;; Flatpak and XDG utilities
   flatpak-xdg-utils
   xdg-utils
   xdg-dbus-proxy
   shared-mime-info
   (list glib "bin")
   ))


(define sss-treesitter-packages
  (list
   tree-sitter
   tree-sitter-bash
   tree-sitter-dockerfile
   tree-sitter-lua
   tree-sitter-haskell
   tree-sitter-css
   tree-sitter-html
   tree-sitter-nix
   tree-sitter-scala
   tree-sitter-markdown
   tree-sitter-typescript
   tree-sitter-scheme
   tree-sitter-java
   tree-sitter-javascript
   
   ))


(define sss-dev-packages
  (list
   (specification->package "openjdk@21.0.2")
   (specification->package "node@18.19.0")
   (specification->package "python")
   ))

(define sss-coreutils
  (list
   htop
   emacs-next-pgtk
   openssh
   dbus
   ncurses
   screen
   tar zip unzip
   gmp
   gcc
   curl
   ripgrep
   net-tools
   dstat
   dconf-editor
   (specification->package "make")
   nix
   coreutils
   xinit
   xorg-server
   ))

(define sss-music-packages
  (list
   spotifyd
   lilypond
   mpd
   mpd-mpc
   ncmpcpp
   cava
   ardour))

(define sss-other-system-packages
  (list
   (specification->package "firefox")
   icedove
   
   flatpak
   pipewire
   nginx
   watchexec
   git
   pavucontrol

   guile-fibers
   
   xz
   ispell
   (specification->package "bind")
   wireshark

   arandr
   httpie
   (specification->package "remmina")
   libnotify
   wdisplays
   
   shotcut
   openshot
   inkscape
   dunst
   fzf
   vlc
   sqlite
   postgresql

   obs
   libreoffice
   gimp
   imagemagick
   libwebp
   feh
   containerd
   xmodmap
   

   docker
   docker-compose
   gparted
   xrandr
   rofi
   slim
   lm-sensors
   exfatprogs
   exfat-utils
   fuse-exfat
   tmon
   
   thunar
   xarchiver
   ristretto
   orage
   sqlitebrowser
   direnv

   power-profiles-daemon

   transmission
   transmission-remote-gtk

   xf86-video-fbdev
   xf86-input-libinput
   lxsession
   pamixer

   ;; ghcid
   
   bluez
   hplip

   i3lock-fancy
   mpv
   mpv-mpris
   unixodbc
   tree
   fyi

   (specification->package "darkhttpd")
   openvpn
   network-manager-applet
   network-manager-openconnect
   network-manager-openvpn
   xxd
   (specification->package "tigervnc-server")
   (specification->package "tigervnc-client")
   ))

(define sss-guile-packages
  (list
   (specification->package "guile-json")
   ))

(define-public sss-system-packages
  (append
   sss-per-host-packages
   sss-other-system-packages
   sss-wm-packages
   sss-font-packages
   sss-dev-packages
   sss-guile-packages
   sss-treesitter-packages
   sss-coreutils
   sss-theme-packages))
