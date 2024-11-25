;;; git.scm

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

(define-module (sss-git)
  #:use-module (gnu)
  )

;; I enjoy having a default commit message, and I overwrite it
;; sometimes when the commit is meaningful, otherwise I use it
(define-public sss-gitmessage-personal "🥷🏼")
(define-public sss-gitmessage-work "🥷🏼")

(define-public sss-gitignore-global
  `("bloop"
    ".bloop"
    ".metals"
    ".stack-work"
    "target"
    "metals.sbt"
    ".direnv"
    "dist-newstyle"
    ))
