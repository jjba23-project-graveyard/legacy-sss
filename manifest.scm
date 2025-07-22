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

(use-modules (guix)
             (guix packages)
             (guix git-download)
             (guix build-system guile)
             (gnu packages guile)
             (gnu packages emacs)
             (gnu packages guile-xyz)
             ((guix licenses)
              #:prefix license:))

(define-public guile-veritas
  (package
    (name "guile-veritas")
    (version "0.0.26")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://codeberg.org/jjba23/veritas.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1djnhwdv51impps2xiwy00qiv9dj9ydk5h922mrdlkrzlqay2dkc"))))
    (build-system guile-build-system)
    (native-inputs (list guile-3.0 guile-fibers))
    (arguments
     (list
      #:source-directory "src"))
    (home-page "https://codeberg.org/jjba23/veritas")
    (synopsis "Testing framework for Guile")
    (description
     "Expressive @acronym{EDSL, embedded domain specific language} and test
runner that allows Guile hackers to test software reliably.  Emphasis is put
on legibility and maintainability of tests.

The framework is built around the concepts of assertions, tests and suites,
and it aims to promote robust testing practices and correctness,
thus providing features like test order randomization and concurrency.")
    (license license:lgpl3+)))

(packages->manifest (list guile-next
                          guile-ares-rs
                          emacs
                          guile-veritas
                          (specification->package "gettext")
                          (specification->package "make")
                          coreutils))
