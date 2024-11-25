;;; proc.scm

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

(define-module (sss-proc)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports)
  #:use-module (ice-9 time)
  #:use-module (ice-9 format)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 iconv)
  #:use-module (ice-9 threads)
  #:use-module (gnu services configuration)
  )


(define-public (syscall cmd)
  (let* ((process (open-input-pipe cmd))
         (process-output (get-string-all process)))
    (close-pipe process)
    (display process-output)
    process-output))

(define-public (mk-lines items)
  (with-output-to-string
    (lambda ()
      (for-each
       (lambda(x)       
         (display (format #f "~a\n" x)))     
       items))))

(begin
  (define* (mk-kv-conf-lines pairs
                             #:key
                             (template "~a=~a\n"))
    (with-output-to-string
      (lambda ()
        (for-each
         (lambda(x)       
           (display (format #f template (car x) (cdr x))))     
         pairs))))
  (export mk-kv-conf-lines))

(begin
  (define* (mk-rec-kv-conf-lines pairs
                                 #:key
                                 (template "~a=~a\n"))
    (with-output-to-string
      (lambda ()
        (for-each
         (lambda(x)
           (cond
            ((alist? (cdr x))
             (display (string-append "\n[" (symbol->string (car x)) "]\n"))
             (display (mk-rec-kv-conf-lines (cdr x))))
            (else (display (format #f template (car x) (cdr x)))))
           )
         
         pairs))))
  (export mk-rec-kv-conf-lines))


(define-public (nix-profile-install x)
  (syscall (format #f "nix -L profile install --impure nixpkgs#~a" x)))


