;;; SSS - Supreme Sexp System

;; Copyright (C) 2025 - Josep Bigorra, jjba23 <jjbigorra@gmail.com>

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

;; Code:

(in-package #:nyxt-user)

;;; Reset ASDF registries to allow loading Lisp systems from
;;; everywhere.
#+nyxt-3 (reset-asdf-registries)

;;; Load quicklisp. Not sure it works.
#-quicklisp
(let ((quicklisp-init
       (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(defvar *web-buffer-modes*
  '(:emacs-mode
    :blocker-mode :force-https-mode
    :reduce-tracking-mode
    :user-script-mode :bookmarklets-mode)
  "The modes to enable in any web-buffer by default.
Extension files (like dark-reader.lisp) are to append to this list.")

;;; Loading extensions and third-party-dependent configs. See the
;;; matching files for where to find those extensions.
(defmacro defextsystem (system &optional file)
  "Helper macro to load configuration for extensions.
Loads a newly-generated ASDF system depending on SYSTEM.
FILE, if provided, is loaded after the generated system successfully
loads."
  `(define-nyxt-user-system-and-load ,(gensym "NYXT-USER/")
     :depends-on (,system) ,@(when file
                               `(:components (,file)))))

(defextsystem :nx-dark-reader "dark-reader")

(defvar *my-search-engines* nil)
(setf *my-search-engines*
      (list
       '("ecosia" "https://www.ecosia.org/?method=index&q=~a" "https://www.ecosia.org/")
       ;; '("quickdocs" "http://quickdocs.org/search?q=~a" "http://quickdocs.org/")
       '("wiki" "https://en.wikipedia.org/w/index.php?search=~a" "https://en.wikipedia.org/")
       ;; '("define" "https://en.wiktionary.org/w/index.php?search=~a" "https://en.wiktionary.org/")
       ;; '("python3" "https://docs.python.org/3/search.html?q=~a" "https://docs.python.org/3")
       ;; '("doi" "https://dx.doi.org/~a" "https://dx.doi.org/")
       ))


(define-configuration browser
  ;; Enable --remote --eval code evaluation.
  ((remote-execution-p t)
   (external-editor-program
    (list "emacsclient" "-c" "-a" "" "-F"
          "((font . \"Adwaita Mono-16\") (vertical-scroll-bars) (tool-bar-lines) (menu-bar-lines))"))
   (search-engines (append (mapcar (lambda (x)
				     (make-instance 'search-engine
						:shortcut (first x)
						:search-url (second x)
						:fallback-url (third x)))
				   *my-search-engines*)
                           %slot-default))))

;;; Those are settings that every type of buffer should share.
(define-configuration (:modable-buffer :prompt-buffer :editor-buffer)
  "Set up Emacs keybindings everywhere possible.

If you're the VI person, then use this:
(define-configuration :web-buffer
  ((default-modes (append (list :vi-normal-mode) %slot-value%))))

You probably want to stay with CUA in :prompt-buffer, because it's too
weird using it with VI bindings. But if you're feeling risky, then:
(define-configuration :prompt-buffer
  ((default-modes (append (list :vi-insert-mode) %slot-value%))))"
  ((default-modes `(:emacs-mode ,@%slot-value%))))

(define-configuration :prompt-buffer
  "Make the attribute widths adjust to the content in them.

It's not exactly necessary on master, because there are more or less
intuitive default widths, but these are sometimes inefficient (and
note that I made this feature so I want to have it :P)."
  ((dynamic-attribute-width-p t)))

(defmethod files:resolve ((profile nyxt:nyxt-profile) (file nyxt/mode/bookmark:bookmarks-file))
  "Reroute the bookmarks to the config directory."
  #p"~/.config/nyxt/bookmarks.lisp")

(define-configuration :reduce-tracking-mode
  ((query-tracking-parameters
    (append '("utm_source" "utm_medium" "utm_campaign" "utm_term" "utm_content")
            %slot-value%)
    :doc "This is to strip UTM-parameters off all the links.
Upstream Nyxt doesn't have it because it may break some websites.")
   (preferred-user-agent
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36"
    :doc "Mimic Chrome on MacOS.")))
