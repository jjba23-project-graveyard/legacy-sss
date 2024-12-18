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

(define-module (sss-byggsteg)
  #:use-module (gnu)
  #:use-module (gnu home services shepherd))

(define-public (sss-byggsteg-service config)
  (list (shepherd-service (documentation "Run byggsteg as a daemon")
                          (provision '(byggsteg))
                          (requirement '())
                          (start #~(make-forkexec-constructor '("make"
                                                                "server")
                                    #:directory
                                    "/home/joe/Ontwikkeling/Persoonlijk/byggsteg"
                                    #:environment-variables (list
                                                             "PATH=/home/joe/.nix-profile/bin:/home/joe/.guix-home/profile/bin:/home/joe/.guix-home/profile/sbin:/run/privileged/bin:/home/joe/.config/guix/current/bin:/home/joe/.guix-profile/bin:/run/current-system/profile/bin:/run/current-system/profile/sbin"
                                                             "GIT_SSL_NO_VERIFY=1"
                                                             "LANG=nl_NL.UTF-8")))
                          (stop #~(make-kill-destructor))
                          (auto-start? #t)
                          (respawn? #t))))

(define-public sss-byggsteg-service-type
  (service-type (name 'byggsteg)
                (description "Run byggsteg as a daemon")
                (extensions (list (service-extension
                                   home-shepherd-service-type
                                   sss-byggsteg-service)))
                (default-value '())))
