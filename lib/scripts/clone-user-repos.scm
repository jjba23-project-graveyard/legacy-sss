(use-modules (ice-9 popen) (ice-9 textual-ports))

(define-public (syscall cmd)
  (let* ((process (open-input-pipe cmd))
         (process-output (get-string-all process)))
    (close-pipe process)
    (display process-output) process-output))

(define sss-joe-clone-repos
  (list
   "private-notes"
   ;;"sss"
   "jointhefreeworld"
   "wikimusic-ssr"
   "wikimusic-api"
   "wolk-jjba"
   "zzspec"
   "byggsteg"
   "rephs"
   "welkomscherm.el"
   "free-alacarte"
   "scala-rank"
   "cloud-infra"
   "yggdrasil-schema"
   "modusregel"
   "keuringsdienst"
   "tekengrootte.el"
   "git-riddance.el"
   "hsresumebuilder"
   "wikimusic-api-spec"
   "wikimusic-model-hs"
   "yak"
   "social-media-jjba"
   "carvoeiro-water-fun"
   ))

(display "\n>>= cloning personal repos...\n")

(for-each
 (lambda(x)
   (syscall
    (format #f "[ -d $HOME/Ontwikkeling/Persoonlijk/~a ] || git clone git@codeberg.org:jjba23/~a.git $HOME/Ontwikkeling/Persoonlijk/~a" x x x)))
 sss-joe-clone-repos)
