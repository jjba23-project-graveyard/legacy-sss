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

(define-module (sss icecat)
  #:use-module (gnu))

(define (serialize-icecat-ini-setting s)
  (format #f "~a=~a"
          (car s)
          (cdr s)))

(define sss-icecat-profile-default
  `((Name . default) (Path . "qwexsrf7.default")
    (IsRelative . 1)
    (Default . 0)))

(define sss-icecat-profile-sss
  `((Name . sss) (Path . sss)
    (IsRelative . 1)
    (Default . 1)))

(define sss-icecat-profile-general
  `((StartWithLastProfile . 1) (Version . 2)))

(define sss-icecat-profiles-config
  (append (list "" "[Profile0]")
          (map serialize-icecat-ini-setting sss-icecat-profile-default)
          (list "" "[Profile1]")
          (map serialize-icecat-ini-setting sss-icecat-profile-sss)
          (list "" "[General]")
          (map serialize-icecat-ini-setting sss-icecat-profile-general)))

(begin
  (define* (sss-icecat-svc)
    `((".mozilla/icecat/profiles.ini" ,(plain-file "profiles.ini"
                                                   (string-join
                                                    sss-icecat-profiles-config
                                                    "\n")))
      (".mozilla/icecat/sss/user.js" ,(local-file "icecat/user.js"))))
  (export sss-icecat-svc))
