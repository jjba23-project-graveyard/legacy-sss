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

(define-module (sss overrides))

;; ===================== WARNING ==================================================
;; DON'T EDIT the contents of this file
;; please do instead create a file at `per-host/sss/overrides.scm'
;; where you define the `(sss overrides)' module
;; with your preferred settings that override the ones at `src/sss/defaults.scm'
;; that file is preferred since it will live outside of version control
;; while this file you are reading is under VC
;;
;; this file only exists to make the compiler happy and to allow
;; people to use the SSS code as a library properly as well as a channel
;; without needing to define their own overrides
;; ================================================================================
