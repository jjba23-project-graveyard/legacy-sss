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

(define-module (sss ssh)
  #:use-module (gnu)
  #:use-module (gnu home services ssh))

(define-public sss-ssh-service
  (service home-openssh-service-type
           (home-openssh-configuration (hosts (list (openssh-host (name
                                                                   "wolk-jjba")
                                                                  (user "joe")
                                                                  (host-name
                                                                   "37.60.232.48")
                                                                  (port 2323)
                                                                  (identity-file
                                                                   "~/.ssh/wolk-jjba"))
                                                    (openssh-host (name
                                                                   "personal.github.com")
                                                                  (user "joe")
                                                                  (host-name
                                                                   "github.com")
                                                                  (identity-file
                                                                   "~/.ssh/gitlab_prive"))
                                                    (openssh-host (name
                                                                   "codeberg.org")
                                                                  (user "joe")
                                                                  (host-name
                                                                   "codeberg.org")
                                                                  (identity-file
                                                                   "~/.ssh/gitlab_prive"))
                                                    (openssh-host (name
                                                                   "work.github.com")
                                                                  (user "joe")
                                                                  (host-name
                                                                   "github.com")
                                                                  (identity-file
                                                                   "~/.ssh/work_id"))))
                                       (authorized-keys '()))))
