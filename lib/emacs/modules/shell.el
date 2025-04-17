;;; shell.el --- Shell configuration for Emacs -*- lexical-binding: t -*-

;; Copyright (C) 2025 Josep Bigorra

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

;;; Commentary:

;; Shell configuration for Emacs

;;; Code:

(defun git-prompt-branch-name ()
  "Get current git branch name"
  (let ((args '("symbolic-ref" "HEAD" "--short")))
    (with-temp-buffer
      (apply #'process-file "git" nil (list t nil) nil args)
      (unless (bobp)
        (goto-char (point-min))
        (buffer-substring-no-properties (point) (line-end-position))))))

(defun eshell-here ()
  "Opens up a new shell in the directory associated with the
current buffer's file. The eshell is renamed to match that
directory to make multiple eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (height (/ (window-total-height) 3))
         (name   (car (last (split-string parent "/" t)))))
    (split-window-vertically (- height))
    (other-window 1)
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))

    (insert (concat "ls"))
    (eshell-send-input)))

(defun eshell/x ()
  (insert "exit")
  (eshell-send-input)
  (delete-window))

(defun sss-eshell-prompt ()
  (defun with-face (str &rest face-plist)
    (propertize str 'face face-plist))
  (concat
   "\n"
   (with-face user-login-name :inherit 'font-lock-function-name-face)
   "@"
   (with-face (system-name) :inherit 'font-lock-function-name-face)
   ": "
   (with-face (eshell/pwd) :inherit 'font-lock-function-name-face)
   ": "
   (with-face
    (or (ignore-errors (git-prompt-branch-name)) "")
    :inherit 'font-lock-function-name-face)
   "\n"
   (if (= (user-uid) 0)
       "#"
     "λ")
   " "))

(setopt eshell-prompt-function 'sss-eshell-prompt)
(setopt eshell-highlight-prompt nil)
(setopt eshell-banner-message "Welcome to SSS/GNU - the Supreme Sexp System\n\n")

(global-set-key (kbd "C-!") 'eshell-here)

(provide 'sss/shell)

;;; shell.el ends here

