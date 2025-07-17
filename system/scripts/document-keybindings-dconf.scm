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

(use-modules (ice-9 popen)
             (ice-9 textual-ports)
             (ice-9 readline)
             (ice-9 string-fun)
             (sss prelude)
             (sss keybindings-docs)
             (json))

(setup-i18n)

(log-info (G_ "Documenting keybindings in JSON format"))

(define keybindings-json
  (with-output-to-file "tmp.json"
    (lambda ()
      (scm->json sss-keybindings-docs))))

(define encoded-k-docs
  (syscall "cat tmp.json | xxd -plain | tr -d '\\n'"
           #:silent? #t))

(log-info (G_ "Writing keybindings to dconf"))

(define cmd
  (format #f "dconf write '/sss/keybindings-docs' \"'~a'\" && rm tmp.json"
          encoded-k-docs))

(syscall cmd
         #:silent? #t)
