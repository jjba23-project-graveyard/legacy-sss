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

(define-module (sss packages universe)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss packages font)
  #:use-module (sss packages net)
  #:use-module (sss packages music)
  #:use-module (sss packages qt)
  #:use-module (sss packages hypr)
  #:use-module (sss packages tree-sitter)
  #:use-module (sss packages universal-session)
  #:use-module (sss packages dict)
  #:use-module (sss packages dev)
  #:use-module (sss packages shell)
  #:use-module (sss packages container)
  #:use-module (sss packages theme)
  #:use-module (sss packages latex)
  #:use-module (sss packages libs)
  #:use-module (sss packages wm)
  #:use-module (sss packages terminal-emulator)

  #:use-module (nongnu packages fonts)
  #:use-module (nongnu packages messaging)
  #:use-module (nongnu packages k8s)
  #:use-module (nongnu packages chrome)
  #:use-module (nongnu packages music)
  #:use-module (gnu services nix)
  #:use-module (guix git-download)
  #:use-module (guix build-system font)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system guile)
  #:use-module (guix build-system qt)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix build-system go)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system meson)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:export (sss-system-packages emacs-packages other-system-packages
                                browser-packages coreutils-packages))

(use-package-modules admin
                     android
                     aspell
                     astronomy
                     audio
                     autotools
                     base
                     bash
                     bittorrent
                     chromium
                     cinnamon
                     cmake
                     commencement
                     compression
                     cpp
                     cups
                     curl
                     databases
                     disk
                     display-managers
                     emacs
                     emacs-xyz
                     enchant
                     engineering
                     file-systems
                     firmware
                     fonts
                     fontutils
                     freedesktop
                     games
                     gcc
                     gdb
                     gettext
                     gimp
                     gl
                     glib
                     ghostscript
                     gnome
                     gnome-xyz
                     gnupg
                     gnuzilla
                     golang
                     graphics
                     gsasl
                     gtk
                     guile
                     guile-xyz
                     haskell-apps
                     image
                     image-viewers
                     imagemagick
                     inkscape
                     kde
                     kde-frameworks
                     kde-plasma
                     kde-systemtools
                     kde-utils
                     kerberos
                     libreoffice
                     linux
                     lisp
                     lisp-xyz
                     llvm
                     lua
                     lxde
                     lxqt
                     mpd
                     multiprecision
                     music
                     ncurses
                     networking
                     node
                     nss
                     package-management
                     parallel
                     perl
                     pkg-config
                     polkit
                     pulseaudio
                     python
                     python-web
                     python-xyz
                     qt
                     rust-apps
                     scanner
                     screen
                     shells
                     shellutils
                     sqlite
                     ssh
                     terminals
                     texinfo
                     texlive
                     text-editors
                     tls
                     version-control
                     video
                     vim
                     virtualization
                     vnc
                     vpn
                     web
                     web-browsers
                     wm
                     xdisorg
                     xfce
                     xorg)

(define coreutils-packages
  (list htop
        btop
        emacs-pgtk
        vim
        git
        openssh
        openssl
        clang
        dbus
        ncurses
        screen
        tar
        zip
        unzip
        gmp
        gcc
        gcc-toolchain
        curl
        ripgrep
        net-tools
        dstat
        dconf-editor
        (specification->package "make")
        nix
        coreutils
        seatd
        libseat
        elogind
        pango
        cairo
        xorg-server))

(define browser-packages
  (list (specification->package "firefox")
        (specification->package "google-chrome-beta")))

(define* other-system-packages
  (list android-file-transfer
        autoconf
        automake
        binutils
        blender
        blueman
        bluez
        bsd-games
        cheese
        cmatrix
        desktop-file-utils
        direnv
        drill
        emacs-pinentry
        evince
        exfat-utils
        exfatprogs
        fastfetch
        feh
        (specification->package "ffmpegthumbs")
        flameshot
        flatpak
        freecad
        fuse-exfat
        fyi
        fyi
        gdb
        geany
        (specification->package "gettext")
        ghcid
        gimp
        gnome-calculator
        gnome-calendar
        gnome-characters
        gnome-clocks
        gnome-font-viewer
        gnome-system-monitor
        gparted
        gthumb
        gtk
        hplip
        httpie
        icedove
        imagemagick
        inkscape
        jq
        kubectl
        libreoffice
        light
        lm-sensors
        lxsession
        mpv
        mpv-mpris
        nemo
        netcat
        nginx
        obs
        ovmf-x86-64
        pamixer
        parallel
        pavucontrol
        perl
        pinentry
        pinentry-tty
        pipewire
        pkg-config
        power-profiles-daemon
        powertop
        qemu
        reaper
        remmina
        sqlitebrowser
        stellarium
        stress
        stress-ng
        sysstat
        tmon
        transmission
        transmission-remote-gtk
        tree
        tumbler
        unixodbc
        virt-manager
        watchexec
        xarchiver
        cups
        cups-filters
        ghostscript
        xsane
        xdg-user-dirs
        xf86-input-libinput
        xf86-video-fbdev
        xxd
        grimblast
        xz
        yt-dlp))

(define emacs-packages
  (list emacs-jinx))

(define* (sss-system-packages #:key (per-host-packages '()))
  "System package collection for SSS. Add packages here to install them system wide"
  (append (map (lambda (x)
                 (specification->package x)) per-host-packages)
          other-system-packages
          (wm-packages)
          (universal-session-packages)
          (font-packages)
          (dev-packages)
          (container-packages)
          (tree-sitter-packages)
          coreutils-packages
          (hypr-packages)
          (terminal-emulator-packages)
          browser-packages
          (latex-packages)
          (shell-packages)
          (libs-packages)
          (dict-packages)
          (net-packages)
          (music-packages)
          (qt-packages)
          (theme-packages)))

