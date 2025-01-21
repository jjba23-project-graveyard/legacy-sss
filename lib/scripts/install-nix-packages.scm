
(use-modules (ice-9 popen) (ice-9 textual-ports)(ice-9 readline))

(load "../../per-host.scm")

(define-public (syscall cmd)
  (let* ((process (open-input-pipe cmd))
         (process-output (get-string-all process)))
    (close-pipe process)
    (display process-output) process-output))

(define (nix-profile-install x)
  (display (format #f "\n>>= installing nix package ~a\n" x))
  (syscall (format #f "nix -L profile install --impure nixpkgs#~a" x)))

(syscall "NIXPGS_ALLOW_UNFREE=1 nix profile upgrade --impure '.*'")

(for-each (lambda(x) (nix-profile-install x)) sss-nixpkgs)
