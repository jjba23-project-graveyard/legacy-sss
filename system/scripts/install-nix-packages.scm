
(use-modules (ice-9 popen)
             (ice-9 textual-ports)
             (ice-9 readline))

(load "../../system/sss-defaults.scm")
(load "../../per-host.scm")

(define (syscall cmd)
  (let* ((process (open-input-pipe cmd))
         (process-output (get-string-all process)))
    (close-pipe process)
    (display process-output) process-output))

(define (nix-profile-install x)
  (display (format #f "\n>>= installing nix package ~a\n" x))
  (syscall (format #f
            "NIXPGS_ALLOW_UNFREE=1 nix -L profile install --impure nixpkgs#~a"
            x)))

(for-each (lambda (x)
            (nix-profile-install x)) sss-nixpkgs)
