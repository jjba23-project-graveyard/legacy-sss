
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

(syscall "NIXPGS_ALLOW_UNFREE=1 nix profile upgrade --impure '.*'")
