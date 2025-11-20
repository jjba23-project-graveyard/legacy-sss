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

(define-module (sss-packages sss-help-center-gtk)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix build-system cargo)
  #:use-module (guix git-download)
  #:use-module (gnu packages)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages pkg-config)
  #:use-module (guix build-system cargo)
  #:use-module (guix import crate)
  #:use-module (gnu packages rust)
  #:export (sss-help-center-gtk))

(define-public sss-help-center-gtk
  (package
    (name "sss-help-center-gtk")
    (version "0.2.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://codeberg.org/jjba23/sss-help-center-gtk.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0108sj9rdqwprcx2ihlsfhbqiig08kah3k2yxc5w0yxzxdh8hzwv"))))
    (build-system cargo-build-system)
    (native-inputs (list pkg-config gtk libadwaita))
    (inputs (cons* openssl
                   (cargo-inputs-from-lockfile)))
    (arguments
     (list
      #:install-source? #f
      #:tests? #f
      #:phases `(modify-phases %standard-phases
                  (add-before 'build 'install-program-files
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let ((bin (string-append (assoc-ref outputs "out")
                                                "/bin"))
                            (share (string-append (assoc-ref outputs "out")
                                                  "/share")))
                        (mkdir-p (string-append share "/resources/img"))
                        (mkdir-p (string-append share "/resources/locale"))
                        (install-file "resources/img/sss.png"
                                      (string-append share "/resources/img/"))
                        (copy-recursively "resources/locale"
                                          (string-append share
                                                         "/resources/locale"))))))))
    (home-page "https://codeberg.org/jjba23/sss-help-center-gtk")
    (synopsis "Help and assistance for SSS")
    (description "")
    (license license:gpl3+)))

