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
  #:use-module (gnu services nix)
  #:use-module (guix git-download)
  #:use-module (guix build-system font)
  #:use-module (guix build-system copy)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix build-system meson)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:))

(use-package-modules freedesktop base lxqt package-management parallel
                     web linux gnuzilla ncurses xfce multiprecision gcc
                     aspell rust-apps inkscape gimp python-web mpd
                     python xdisorg imagemagick curl cups terminals
                     video image compression sqlite disk glib networking
                     fontutils lisp image-viewers gnome-xyz guile-xyz
                     guile bash nss pkg-config games qt virtualization
                     polkit gtk kde-plasma kde-frameworks kde-utils wm
                     compton ssh vpn version-control fonts pulseaudio
                     libreoffice wm lisp-xyz web-browsers audio
                     music display-managers file-systems tree-sitter lua
                     xorg admin screen node emacs lxde vim astronomy
                     text-editors enchant emacs-xyz containers
                     haskell-apps gnome databases bittorrent shellutils)

(load "../per-host.scm")

(define sss-theme-packages
  (list
   yaru-theme
   breeze-icons
   breeze
   breeze-gtk
   delft-icon-theme
   ))

(define-public sss-swayfx
  (package
   (inherit sway)
   (name "swayfx")
   (version "0.4")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/WillPower3309/swayfx")
                  (commit version)))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "0651gbkszc8wwkiiw983m3815cfyk4c9v4mpd1nqf27a0f6qjgsm"))))
   (build-system meson-build-system)
   (inputs (append
            (map (lambda(x) (specification->package x))
                 `("basu"
                   "cairo"
                   "gdk-pixbuf"
                   "json-c"
                   "libevdev"
                   "libinput-minimal"
                   "libxkbcommon"
                   "pcre2"
                   "scenefx"
                   "swaybg"
                   "wayland"
                   "wlroots@0.17.4"
                   )            
                 )
            (list pango))
           )
   (home-page "https://github.com/WillPower3309/swayfx")
   (synopsis "Sway Fork with extra options and effects")
   (description
    "Fork of Sway, a Wayland compositor compatible with i3.  SwayFX
adds extra options and effects to the original Sway, such as blur, rounded
corners, shadows, inactive window dimming, etc.")
   (license license:expat)))

(define-public sss-artanis
  (package
   (name "artanis")
   (version "1.0.0")
   (source (origin
            (method url-fetch)
            (uri (string-append "mirror://gnu/artanis/artanis-"
                                version ".tar.gz"))
            (sha256
             (base32
              "05sigqvm04x0r1gwpwrxjffb3i13bss3ff24frr477zqm54wv5d8"))
            (modules '((guix build utils)))
            (snippet
             '(begin
                (substitute* '("artanis/artanis.scm"
                               "artanis/lpc.scm"
                               "artanis/oht.scm"
                               "artanis/tpl/parser.scm")
                             (("(#:use-module \\()artanis third-party (json\\))" _
                               use-module json)
                              (string-append use-module json)))
                (substitute* '("artanis/lpc.scm"
                               "artanis/session.scm")
                             (("(#:use-module \\()artanis third-party (redis\\))" _
                               use-module redis)
                              (string-append use-module redis)))
                (substitute* "artanis/oht.scm"
                             (("([[:punct:][:space:]]+)(->json-string)([[:punct:][:space:]]+)"
                               _ pre json-string post)
                              (string-append pre
                                             "scm" json-string
                                             post)))
                (substitute* "artanis/artanis.scm"
                             (("[[:punct:][:space:]]+->json-string[[:punct:][:space:]]+")
                              ""))
                #t))))
   (build-system gnu-build-system)
   (inputs
    (list bash-minimal guile-3.0 nspr nss))
   ;; FIXME the bundled csv contains one more exported procedure
   ;; (sxml->csv-string) than guile-csv. The author is maintainer of both
   ;; projects.
   ;; TODO: Add guile-dbi and guile-dbd optional dependencies.
   (propagated-inputs
    (list guile-json-4 guile-curl guile-readline guile-redis))
   (native-inputs
    (list bash-minimal                           ;for the `source' builtin
          pkg-config
          util-linux))                           ;for the `script' command
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
             (effective-version (target-guile-effective-version
                                 (assoc-ref %build-inputs "guile")))
             (scm (string-append out "/share/guile/site/" effective-version))
             (go (string-append out "/lib/guile/" effective-version "/site-ccache")))
        ;; Don't use (%site-dir) for site paths.
        (list (string-append "MOD_PATH=" scm)
              (string-append "MOD_COMPILED_PATH=" go)))
      #:test-target "test"
      #:phases
      (modify-phases %standard-phases
                     (add-after 'unpack 'patch-site-dir
                                (lambda* (#:key outputs #:allow-other-keys)
                                  (substitute* "artanis/commands/help.scm"
                                               (("\\(%site-dir\\)")
                                                (string-append "\""
                                                               (assoc-ref outputs "out")
                                                               "/share/guile/site/"
                                                               (target-guile-effective-version)
                                                               "\"")))))
                     (add-after 'unpack 'patch-reference-to-libnss
                                (lambda* (#:key inputs #:allow-other-keys)
                                  (substitute* "artanis/security/nss.scm"
                                               (("ffi-binding \"libnss3\"")
                                                (string-append
                                                 "ffi-binding \""
                                                 (assoc-ref inputs "nss") "/lib/nss/libnss3.so"
                                                 "\""))
                                               (("ffi-binding \"libssl3\"")
                                                (string-append
                                                 "ffi-binding \"" (assoc-ref inputs "nss") "/lib/nss/libssl3.so\"")))))
                     (add-before 'install 'substitute-root-dir
                                 (lambda* (#:key outputs #:allow-other-keys)
                                   (let ((out  (assoc-ref outputs "out")))
                                     (substitute* "Makefile"   ;ignore the execution of bash.bashrc
                                                  ((" /etc/bash.bashrc") " /dev/null"))
                                     (substitute* "Makefile"   ;set the root of config files to OUT
                                                  ((" /etc") (string-append " " out "/etc")))
                                     (mkdir-p (string-append out "/bin")) )))
                     (add-after 'install 'wrap-art
                                (lambda* (#:key inputs outputs #:allow-other-keys)
                                  (let* ((out (assoc-ref outputs "out"))
                                         (effective-version (target-guile-effective-version))
                                         (bin (string-append out "/bin"))
                                         (scm (string-append out "/share/guile/site/" effective-version))
                                         (go (string-append out "/lib/guile/" effective-version
                                                            "/site-ccache")))
                                    (wrap-program (string-append bin "/art")
                                                  `("GUILE_LOAD_PATH" ":" prefix
                                                    (,scm ,(getenv "GUILE_LOAD_PATH")))
                                                  `("GUILE_LOAD_COMPILED_PATH" ":" prefix
                                                    (,go ,(getenv "GUILE_LOAD_COMPILED_PATH"))))))))))
   (synopsis "Web application framework written in Guile")
   (description "GNU Artanis is a web application framework written in Guile
Scheme.  A web application framework (WAF) is a software framework that is
designed to support the development of dynamic websites, web applications, web
services and web resources.  The framework aims to alleviate the overhead
associated with common activities performed in web development.  Artanis
provides several tools for web development: database access, templating
frameworks, session management, URL-remapping for RESTful, page caching, and
more.")
   (home-page "https://www.gnu.org/software/artanis/")
   (license (list license:gpl3+ license:lgpl3+)))) ;dual license

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

(define sss-font-packages
  (list
   fontconfig
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
  (list
   cl-asdf

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
   seatd
   libseat
   elogind
   pango
   cairo
   xorg-server
   ))

(define sss-music-packages
  (list
   spotifyd
   lilypond
   mpd
   mpd-mpc
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

   kcalc

   slurp
   ;; stellarium
   kate
   geany
   gnome-font-viewer
   gnome-characters
   qtwayland

   guile-fibers
   
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

   parallel
   
   thunar
   xarchiver
   ristretto
   orage
   
   sqlitebrowser
   direnv

   bsd-games

   power-profiles-daemon

   scenefx
   sss-swayfx
   
   transmission
   transmission-remote-gtk

   xf86-video-fbdev
   xf86-input-libinput
   lxsession
   pamixer

   ;; ghcid
   neofetch
   
   bluez
   hplip

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

   ;; element-desktop

   (specification->package "darkhttpd")
   
   openvpn
   network-manager-applet
   network-manager-openconnect
   network-manager-openvpn
   
   xxd
   ))

(define sss-container-packages
  (list
   podman podman-compose
   passt
   ))

(define sss-guile-packages
  (list
   (specification->package "guile-json")
   sss-artanis
   ))

(define-public sss-system-packages
  (append
   sss-per-host-packages
   sss-other-system-packages
   sss-wm-packages
   sss-font-packages
   sss-dev-packages
   sss-guile-packages
   sss-container-packages
   sss-treesitter-packages
   sss-coreutils
   sss-theme-packages))
