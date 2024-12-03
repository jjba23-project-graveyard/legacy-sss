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

(define-module (sss-enchant)
  #:use-module (gnu))


(define-public sss-enchant-ordering
  "Enchant uses global and per-user ordering files named enchant.ordering to decide
which spelling provider to use for particular languages. The per-user file takes precedence.

The ordering file takes the form language_tag:<comma-separated list of spelling providers>.
To see what dictionaries are available, run enchant-lsmod-2.
’*’ is used to mean use this ordering for all languages, unless instructed otherwise."
  `("*:aspell,hunspell,nuspell"))

