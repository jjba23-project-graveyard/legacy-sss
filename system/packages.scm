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

(define-module (sss-packages)
  #:use-module (gnu)
  #:use-module (nongnu packages fonts)
  #:use-module (nongnu packages messaging)
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
  #:use-module (guix build-system meson)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses)
                #:prefix license:))

(use-package-modules freedesktop
                     base
                     lxqt
                     package-management
                     parallel
                     web
                     texinfo
                     autotools
                     perl
                     linux
                     gnuzilla
                     ncurses
                     xfce
                     rust
                     gnupg
                     multiprecision
                     gcc
                     aspell
                     gdb
                     rust-apps
                     inkscape
                     texlive
                     gimp
                     python-web
                     mpd
                     python
                     xdisorg
                     imagemagick
                     curl
                     cups
                     terminals
                     video
                     image
                     compression
                     sqlite
                     disk
                     glib
                     networking
                     fontutils
                     lisp
                     image-viewers
                     gnome-xyz
                     guile-xyz
                     guile
                     bash
                     nss
                     pkg-config
                     games
                     qt
                     virtualization
                     polkit
                     gtk
                     kde-plasma
                     kde-frameworks
                     kde-utils
                     wm
                     compton
                     ssh
                     vpn
                     version-control
                     fonts
                     pulseaudio
                     libreoffice
                     wm
                     lisp-xyz
                     web-browsers
                     audio
                     kde-systemtools
                     kde-multimedia
                     music
                     display-managers
                     file-systems
                     tree-sitter
                     lua
                     xorg
                     admin
                     screen
                     node
                     emacs
                     lxde
                     vim
                     astronomy
                     text-editors
                     enchant
                     emacs-xyz
                     containers
                     haskell-apps
                     gnome
                     databases
                     bittorrent
                     shellutils)

(load "../per-host.scm")

(define (sss/x86-only-pkg architecture pkg)
  (if (string-prefix? "x86_64" architecture)
      (specification->package pkg)
      '()))

(define-public sss-artanis
  (package
    (name "artanis")
    (version "1.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://gnu/artanis/artanis-" version ".tar.gz"))
       (sha256
        (base32 "1b7mab8izvli4152hzv4n2z67kw0kwm7pvh0m960whr77rdxwid4"))
       (modules '((guix build utils)))
       (snippet '(begin
                   (delete-file-recursively "artanis/third-party/json.scm")
                   (delete-file-recursively "artanis/third-party/redis.scm")
                   (substitute* '("artanis/artanis.scm" "artanis/lpc.scm"
                                  "artanis/i18n/json.scm" "artanis/oht.scm"
                                  "artanis/tpl/parser.scm")
                     (("(#:use-module \\()artanis third-party (json\\))" _
                       use-module json)
                      (string-append use-module json)))
                   (substitute* '("artanis/lpc.scm" "artanis/session.scm")
                     (("(#:use-module \\()artanis third-party (redis\\))" _
                       use-module redis)
                      (string-append use-module redis)))
                   (substitute* "artanis/oht.scm"
                     (("([[:punct:][:space:]]+)(->json-string)([[:punct:][:space:]]+)"
                       _ pre json-string post)
                      (string-append pre "scm" json-string post)))
                   (substitute* "artanis/artanis.scm"
                     (("[[:punct:][:space:]]+->json-string[[:punct:][:space:]]+")
                      ""))
                   #t))))
    (build-system gnu-build-system)
    (inputs (list bash-minimal guile-3.0 nspr nss))
    ;; FIXME the bundled csv contains one more exported procedure
    ;; (sxml->csv-string) than guile-csv. The author is maintainer of both
    ;; projects.
    ;; TODO: Add guile-dbi and guile-dbd optional dependencies.
    (propagated-inputs (list guile-json-4 guile-curl guile-readline
                             guile-redis))
    (native-inputs (list bash-minimal ;for the `source' builtin
                         pkg-config util-linux)) ;for the `script' command
    (arguments
     `(#:modules (((guix build guile-build-system)
                   #:select (target-guile-effective-version))
                  ,@%default-gnu-modules)
       #:imported-modules ((guix build guile-build-system)
                           ,@%default-gnu-imported-modules)
       #:make-flags
       ;; TODO: The documentation must be built with the `docs' target.
       (let* ((out (assoc-ref %outputs "out"))
              ;; We pass guile explicitly here since this executes before the
              ;; set-paths phase and therefore guile is not yet in PATH.
              (effective-version (target-guile-effective-version (assoc-ref
                                                                  %build-inputs
                                                                  "guile")))
              (scm (string-append out "/share/guile/site/" effective-version))
              (go (string-append out "/lib/guile/" effective-version
                                 "/site-ccache")))
         ;; Don't use (%site-dir) for site paths.
         (list (string-append "MOD_PATH=" scm)
               (string-append "MOD_COMPILED_PATH=" go)))
       #:test-target "test"
       #:phases (modify-phases %standard-phases
                  (add-after 'unpack 'patch-site-dir
                    (lambda* (#:key outputs #:allow-other-keys)
                      (substitute* "artanis/commands/help.scm"
                        (("\\(%site-dir\\)")
                         (string-append "\""
                                        (assoc-ref outputs "out")
                                        "/share/guile/site/"
                                        (target-guile-effective-version) "\"")))))
                  (add-after 'unpack 'patch-reference-to-libnss
                    (lambda* (#:key inputs #:allow-other-keys)
                      (substitute* "artanis/security/nss.scm"
                        (("ffi-binding \"libnss3\"")
                         (string-append "ffi-binding \""
                                        (assoc-ref inputs "nss")
                                        "/lib/nss/libnss3.so" "\""))
                        (("ffi-binding \"libssl3\"")
                         (string-append "ffi-binding \""
                                        (assoc-ref inputs "nss")
                                        "/lib/nss/libssl3.so\"")))))
                  (add-before 'install 'substitute-root-dir
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let ((out (assoc-ref outputs "out")))
                        (substitute* "Makefile"
                          ;; ignore the execution of bash.bashrc
                          ((" /etc/bash.bashrc")
                           " /dev/null"))
                        (substitute* "Makefile"
                          ;; set the root of config files to OUT
                          ((" /etc")
                           (string-append " " out "/etc")))
                        (mkdir-p (string-append out "/bin")))))
                  (add-after 'install 'wrap-art
                    (lambda* (#:key inputs outputs #:allow-other-keys)
                      (let* ((out (assoc-ref outputs "out"))
                             (effective-version (target-guile-effective-version))
                             (bin (string-append out "/bin"))
                             (scm (string-append out "/share/guile/site/"
                                                 effective-version))
                             (go (string-append out "/lib/guile/"
                                                effective-version
                                                "/site-ccache")))
                        (wrap-program (string-append bin "/art")
                          `("GUILE_LOAD_PATH" ":" prefix
                            (,scm ,(getenv "GUILE_LOAD_PATH")))
                          `("GUILE_LOAD_COMPILED_PATH" ":" prefix
                            (,go ,(getenv "GUILE_LOAD_COMPILED_PATH"))))))))))
    (synopsis "Web application framework written in Guile")
    (description
     "GNU Artanis is a web application framework written in Guile
Scheme.  A web application framework (WAF) is a software framework that is
designed to support the development of dynamic websites, web applications, web
services and web resources.  The framework aims to alleviate the overhead
associated with common activities performed in web development.  Artanis
provides several tools for web development: database access, templating
frameworks, session management, URL-remapping for RESTful, page caching, and
more.")
    (home-page "https://www.gnu.org/software/artanis/")
    (license (list license:gpl3+ license:lgpl3+))))
;dual license

(define-public font-monaspace
  (package
    (name "font-monaspace")
    (version "1.101")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://github.com/githubnext/monaspace/archive/refs/tags/v1.101.tar.gz")
       (sha256
        (base32 "076gx85and4xb262y0rbqvy7f6w732krzlh236xr7v3zbsw1h872"))))
    (build-system font-build-system)
    (home-page "https://monaspace.githubnext.com")
    (synopsis "An innovative superfamily of fonts for code")
    (description
     "The Monaspace type system is a monospaced type superfamily with some modern tricks up its sleeve.
     It consists of five variable axis typefaces. Each one has a distinct voice, but they are all metrics-compatible with one another,
     allowing you to mix and match them for a more expressive typographical palette.")
    (license license:silofl1.1)))

;; TODO install to right location where Kvantum can see it?
(define-public sss-kv-yaru-colors
  (package
    (name "kvantum-yaru-colors")
    (version "21.04")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/GabePoel/KvYaru-Colors.git")
             (commit "7df1a89610618e6d3a145ff44ed47f0aafdb4ae5")))
       (sha256
        (base32 "1d7ys8jyk8k34dbq807vvxj9xpq9jgi8yx3xkn1ypswx5mabl9ls"))))
    (build-system copy-build-system)
    (arguments
     (list
      #:install-plan #~'(("./src/" "/usr/share/Kvantum"))))
    (synopsis "Kvantum theme to match the Yaru colors theme!")
    (description
     "Kvantum themes to match the Yaru Colors and Yaru Remix themes! Check releases for latest stable version.")
    (home-page "https://github.com/GabePoel/KvYaru-Colors.git")
    (license license:gpl3+)))

(define sss-font-packages
  (list fontconfig
        font-google-roboto
        font-google-noto-emoji
        font-recursive
        font-microsoft-cascadia
        font-victor-mono
        font-jetbrains-mono
        font-intel-one-mono
        font-liberation
        font-dejavu
        font-microsoft-web-core-fonts
        font-awesome
        font-fira-code
        font-monaspace
        font-google-noto))

(define sss-wm-packages
  (list swaybg
        swaylock
        swayidle

        waybar-experimental
        wmenu

        mako
        fuzzel
        grimshot
        wl-color-picker
        qpwgraph
        wireplumber
        pipewire

        wl-clipboard

        ;; Wayland portals
        xdg-desktop-portal
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk

        ;; Compatibility for older Xorg applications
        xorg-server-xwayland

        polkit-gnome

        ;; Flatpak and XDG utilities
        flatpak-xdg-utils
        xdg-utils
        xdg-dbus-proxy
        shared-mime-info
        (list glib "bin")))

(define sss-treesitter-packages
  (list tree-sitter
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
        tree-sitter-javascript))

(define sss-terminal-emulator-packages
  (list foot))

(define sss-dev-packages
  (list (specification->package "openjdk@21.0.2")
        (specification->package "node@20.18.1")
        (specification->package "python")
        cl-asdf
        rust
        rust-analyzer))

(define sss-coreutils
  (list htop
        emacs-pgtk
        vim
        openssh
        dbus
        ncurses
        screen
        tar
        zip
        unzip
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
        seatd
        libseat
        elogind
        pango
        cairo
        xorg-server))

(define sss-theme-packages
  (list papirus-icon-theme
        yaru-theme
        gnome-themes-standard
        gnome-themes-extra
        adwaita-icon-theme
        sss-kv-yaru-colors))

(define sss-music-packages
  (list spotifyd lilypond mpd mpd-mpc ardour))

(define sss-browser-packages
  (list icecat icedove))

(define* (sss-other-system-packages #:key architecture)
  (list

        flatpak
        pipewire
        nginx
        watchexec
        git
        pavucontrol

        kcalc

        slurp

        kvantum
        qt5ct
        qtsvg
        ;; seems like qt wayland 6 and 5 are not yet compatible
        ;; this causes crashes in qt 5 and 6 apps
        ;; qtwayland
        qtwayland-5
        qt6ct

        geany

        gnome-font-viewer
        gnome-characters

        rofi-wayland

        xz
        ispell
        (specification->package "bind")
        wireshark

        gnome-tweaks
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

        gdk-pixbuf
        gtk

        qutebrowser

        gnome-calculator
        cheese
        gnome-system-monitor
        evince

        qemu

        obs
        libreoffice
        gimp
        imagemagick
        libwebp
        feh

        xmodmap

        gparted

        lm-sensors
        exfatprogs
        exfat-utils
        fuse-exfat
        tmon
        flameshot

        parallel

        thunar

        ffmpegthumbs
        xarchiver
        ristretto
        orage

        sqlitebrowser
        direnv

        bsd-games

        power-profiles-daemon
        libltdl
        scenefx
        swayfx

        gdb

        transmission
        transmission-remote-gtk

        xf86-video-fbdev
        xf86-input-libinput
        lxsession
        pamixer

        texinfo
        texlive

        (sss/x86-only-pkg architecture "ghcid")

        neofetch
        cmatrix

        bluez
        hplip

        autoconf
        automake
        perl

        mpv
        mpv-mpris
        unixodbc
        tree
        fyi

        enchant
        emacs-jinx
        aspell
        aspell-dict-nl
        aspell-dict-pt-pt
        aspell-dict-es
        aspell-dict-en
        aspell-dict-ca

        (sss/x86-only-pkg architecture "google-chrome-stable")
        (sss/x86-only-pkg architecture "reaper")
        (sss/x86-only-pkg architecture "stellarium")
        (sss/x86-only-pkg architecture "virt-manager")

        (specification->package "darkhttpd")

        openvpn
        network-manager-applet
        network-manager-openconnect
        network-manager-openvpn

        nautilus

        xxd))

(define sss-container-packages
  (list podman-compose podman passt slirp4netns))

(define-public sss-guile-dbi
  (package
    (name "guile-dbi")
    (version "2.1.8")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/opencog/guile-dbi")
             (commit (string-append "guile-dbi-" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "123m4j82bi60s1v95pjh4djb7bh6zdwmljbpyg7zq8ni2gyal7lw"))))
    (build-system gnu-build-system)
    (arguments
     `(#:make-flags '("LDFLAGS=\"-Wl,-allow-multiple-definition\"")
       #:modules (((guix build guile-build-system)
                   #:select (target-guile-effective-version))
                  ,@%default-gnu-modules)
       #:imported-modules ((guix build guile-build-system)
                           ,@%default-gnu-imported-modules)
       #:configure-flags (list (string-append "--with-guile-site-dir=" %output
                                              "/share/guile/site/"
                                              (target-guile-effective-version (assoc-ref
                                                                               %build-inputs
                                                                               "guile"))))
       #:phases (modify-phases %standard-phases
                  (add-after 'unpack 'chdir
                    (lambda _
                      ;; The upstream Git repository contains all the code, so change
                      ;; to the directory specific to guile-dbi.
                      (chdir "guile-dbi")))
                  (add-after 'install 'patch-extension-path
                    (lambda* (#:key inputs outputs #:allow-other-keys)
                      (let* ((out (assoc-ref outputs "out"))
                             (dbi.scm (string-append out "/share/guile/site/"
                                                     (target-guile-effective-version
                                                      (assoc-ref inputs
                                                                 "guile"))
                                                     "/dbi/dbi.scm"))
                             (ext (string-append out "/lib/libguile-dbi")))
                        (substitute* dbi.scm
                          (("libguile-dbi")
                           ext))))))))
    (native-inputs (list autoconf
                         automake
                         libtool
                         perl
                         texinfo
                         libltdl))
    (propagated-inputs (list guile-3.0))
    (synopsis "Guile database abstraction layer")
    (home-page "https://github.com/opencog/guile-dbi")
    (description
     "guile-dbi is a library for Guile that provides a convenient interface to
SQL databases.  Database programming with guile-dbi is generic in that the same
programming interface is presented regardless of which database system is used.
It currently supports MySQL, Postgres and SQLite3.")
    (license license:gpl2+)
    (native-search-paths
     (list (search-path-specification
            (variable "GUILE_DBD_PATH")
            (files '("lib")))))))

(define-public sss-guile-dbd-sqlite3
  (package
    (inherit sss-guile-dbi)
    (name "guile-dbd-sqlite3")
    (arguments
     (substitute-keyword-arguments (package-arguments sss-guile-dbi)
       ((#:phases phases)
        `(modify-phases ,phases
           (replace 'chdir
             (lambda _
               ;; The upstream Git repository contains all the code, so change
               ;; to the directory specific to guile-dbd-sqlite3.
               (chdir "guile-dbd-sqlite3")))
           (delete 'patch-extension-path)))))
    (inputs (list sqlite zlib))
    (native-inputs (modify-inputs (package-native-inputs sss-guile-dbi)
                     (prepend sss-guile-dbi ;only required for headers
                              pkg-config)))
    (synopsis "Guile DBI driver for SQLite")
    (description
     "guile-dbi is a library for Guile that provides a convenient interface to
SQL databases.  This package implements the interface for SQLite.")))

(define-public guile-uuid
  (let ((commit "64002d74025f577e1eeea7bc51218a2c7929631f")
        (revision "0"))
    (package
      (name "guile-uuid")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://codeberg.org/elb/guile-uuid.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1q6dqm2hzq75aa5mrrwgqdml864pdrxc98j7pyj1y0827phnzjfj"))))
      (build-system guile-build-system)
      (native-inputs (list guile-3.0 guile-gcrypt))
      (home-page "https://codeberg.org/elb/guile-uuid")
      (synopsis
       "Guile-UUID is a UUID generation and manipulation module for GNU Guile.")
      (description
       "This package implements RFC 9562 UUIDs, and can generate versions 1 and 3–8 from that specification.
        It provides parsing for UUIDs in standard hex-and-dash format of any variant and version.
        It can also query the variant and version of UUIDs from the RFC.
        Simple routines for converting between binary and hex-and-dash string UUIDs are included.")
      (license license:gpl3+))))

(define sss-guile-packages
  (list sss-artanis
        guile-fibers
        guile-json-4
        guile-sqlite3
        sss-guile-dbi
        guile-uuid
        sss-guile-dbd-sqlite3))

;; SYSTEM PACKAGES
;;
;; Add packages here to install them system wide
(begin
  (define* (sss-system-packages #:key (per-host-packages '())
                                (architecture (or (%current-target-system)
                                                  (%current-system))))
    (append per-host-packages
            (sss-other-system-packages #:architecture architecture)
            sss-wm-packages
            sss-font-packages
            sss-dev-packages
            sss-guile-packages
            sss-container-packages
            sss-treesitter-packages
            sss-coreutils
            sss-terminal-emulator-packages
            sss-browser-packages
            sss-theme-packages))
  (export sss-system-packages))
