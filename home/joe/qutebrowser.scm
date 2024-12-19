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

(define-module (sss-qutebrowser)
  #:use-module (gnu))

(define sss-qutebrowser-palette
  `((bg-default . "#282c34")
    (bg-lighter . "#353b45")
    (bg-selection . "#3e4451")
    (fg-disabled . "#565c64")
    (fg-default . "#abb2bf")
    (bg-lightest . "#c8ccd4")
    (fg-error . "#e06c75")
    (bg-hint . "#e5c07b")
    (fg-matched-text . "#98c379")
    (bg-passthrough-mode . "#56b6c2")
    (bg-insert-mode . "#98c379")
    (bg-warning . "#d19a66")
    ))

(define sss-qutebrowser-theme
  `(
    ;; Text color of the completion widget. May be a single color to use for
    ;; all columns or a list of three colors, one for each column.
    (completion.fg fg-default)
    ;; Background color of the completion widget for odd rows.
    (completion.odd.bg bg-lighter)
    ;; Background color of the completion widget for even rows.
    (completion.even.bg bg-default)
    ;; Foreground color of completion widget category headers.
    (completion.category.fg bg-hint)
    ;; Background color of the completion widget category headers.
    (completion.category.bg bg-default)
    ;; Top border color of the completion widget category headers.
    (completion.category.border.top bg-default)
    ;; Bottom border color of the completion widget category headers.
    (completion.category.border-bottom bg-default)
    ;; Foreground color of the selected completion item.
    (completion.item.selected.fg fg-default)
    ;; Background color of the selected completion item.
    (completion.item.selected.bg  bg-selection)
    ;; Top border color of the selected completion item.
    (completion.item.selected.border.top  bg-selection)
    ;; Bottom border color of the selected completion item.
    (completion.item.selected.border.bottom  bg-selection)
    ;; Foreground color of the matched text in the selected completion item.
    (completion.item.selected.match.fg  fg-matched-text)
    ;; Foreground color of the matched text in the completion.
    (completion.match.fg  fg-matched-text)
    ;; Color of the scrollbar handle in the completion view.
    (completion.scrollbar.fg  fg-default)
    ;; Color of the scrollbar in the completion view.
    (completion.scrollbar.bg  bg-default)
    ;; Background color of disabled items in the context menu.
    (contextmenu.disabled.bg  bg-lighter)
    ;; Foreground color of disabled items in the context menu.
    (contextmenu.disabled.fg  fg-disabled)
    ;; Background color of the context menu. If set to null, the Qt default is used.
    (contextmenu.menu.bg  bg-default)
    ;; Foreground color of the context menu. If set to null, the Qt default is used.
    (contextmenu.menu.fg  fg-default)
    ;; Background color of the context menu’s selected item. If set to null, the Qt default is used.
    (contextmenu.selected.bg  bg-selection)
    ;; Foreground color of the context menu’s selected item. If set to null, the Qt default is used.
    (contextmenu.selected.fg  fg-default)
    ;; Background color for the download bar.
    (downloads.bar.bg  bg-default)
    ;; Color gradient start for download text.
    (downloads.start.fg  bg-default)
    ;; Color gradient start for download backgrounds.
    (downloads.start.bg  bg-insert-mode)
    ;; Color gradient end for download text.
    (downloads.stop.fg  bg-default)
    ;; Color gradient stop for download backgrounds.
    (downloads.stop.bg  bg-passthrough-mode)
    ;; Foreground color for downloads with errors.
    (downloads.error.fg  fg-error)
    ;; Font color for hints.
    (hints.fg  bg-default)
    ;; Background color for hints. Note that you can use a `rgba(...)` value
    ;; for transparency.
    (hints.bg  bg-hint)
    ;; Font color for the matched part of hints.
    (hints.match.fg  fg-default)
    ;; Text color for the keyhint widget.
    (keyhint.fg  fg-default)
    ;; Highlight color for keys to complete the current keychain.
    (keyhint.suffix.fg  fg-default)
    ;; Background color of the keyhint widget.
    (keyhint.bg  bg-default)
    ;; Foreground color of an error message.
    (messages.error.fg  bg-default)
    ;; Background color of an error message.
    (messages.error.bg  fg-error)
    ;; Border color of an error message.
    (messages.error.border  fg-error)
    ;; Foreground color of a warning message.
    (messages.warning.fg  bg-default)
    ;; Background color of a warning message.
    (messages.warning.bg  bg-warning)
    ;; Border color of a warning message.
    (messages.warning.border  bg-warning)
    ;; Foreground color of an info message.
    (messages.info.fg  fg-default)
    ;; Background color of an info message.
    (messages.info.bg  bg-default)
    ;; Border color of an info message.
    (messages.info.border  bg-default)
    ;; Foreground color for prompts.
    (prompts.fg  fg-default)
    ;; Border used around UI elements in prompts.
    (prompts.border  bg-default)
    ;; Background color for prompts.
    (prompts.bg  bg-default)
    ;; Background color for the selected item in filename prompts.
    (prompts.selected.bg  bg-selection)
    ;; Foreground color for the selected item in filename prompts.
    (prompts.selected.fg  fg-default)
    ;; Foreground color of the statusbar.
    (statusbar.normal.fg  fg-matched-text)
    ;; Background color of the statusbar.
    (statusbar.normal.bg  bg-default)
    ;; Foreground color of the statusbar in insert mode.
    (statusbar.insert.fg  bg-default)
    ;; Background color of the statusbar in insert mode.
    (statusbar.insert.bg  bg-insert-mode)
    ;; Foreground color of the statusbar in passthrough mode.
    (statusbar.passthrough.fg  bg-default)
    ;; Background color of the statusbar in passthrough mode.
    (statusbar.passthrough.bg  bg-passthrough-mode)
    ;; Foreground color of the statusbar in private browsing mode.
    (statusbar.private.fg  bg-default)
    ;; Background color of the statusbar in private browsing mode.
    (statusbar.private.bg  bg-lighter)
    ;; Foreground color of the statusbar in command mode.
    (statusbar.command.fg  fg-default)
    ;; Background color of the statusbar in command mode.
    (statusbar.command.bg  bg-default)
    ;; Foreground color of the statusbar in private browsing + command mode.
    (statusbar.command.private.fg  fg-default)
    ;; Background color of the statusbar in private browsing + command mode.
    (statusbar.command.private.bg  bg-default)
    ;; Foreground color of the statusbar in caret mode.
    (statusbar.caret.fg  bg-default)
    ;; Background color of the statusbar in caret mode.
    (statusbar.caret.bg  bg-warning)
    ;; Foreground color of the statusbar in caret mode with a selection.
    (statusbar.caret.selection.fg  bg-default)
    ;; Background color of the statusbar in caret mode with a selection.
    (statusbar.caret.selection.bg  bg-insert-mode)
    ;; Background color of the progress bar.
    (statusbar.progress.bg  bg-insert-mode)
    ;; Default foreground color of the URL in the statusbar.
    (statusbar.url.fg  fg-default)
    ;; Foreground color of the URL in the statusbar on error.
    (statusbar.url.error.fg  fg-error)
    ;; Foreground color of the URL in the statusbar for hovered links.
    (statusbar.url.hover.fg  fg-default)
    ;; Foreground color of the URL in the statusbar on successful load
    ;; (http).
    (statusbar.url.success.http.fg  bg-passthrough-mode)
    ;; Foreground color of the URL in the statusbar on successful load
    ;; (https).
    (statusbar.url.success.https.fg  fg-matched-text)
    ;; Foreground color of the URL in the statusbar when there's a warning.
    (statusbar.url.warn.fg  bg-warning)
    ;; Background color of the tab bar.
    (tabs.bar.bg  bg-default)
    ;; Color gradient start for the tab indicator.
    (tabs.indicator.start  bg-insert-mode)
    ;; Color gradient end for the tab indicator.
    (tabs.indicator.stop  bg-passthrough-mode)
    ;; Color for the tab indicator on errors.
    (tabs.indicator.error  fg-error)
    ;; Foreground color of unselected odd tabs.
    (tabs.odd.fg  fg-default)
    ;; Background color of unselected odd tabs.
    (tabs.odd.bg  bg-lighter)
    ;; Foreground color of unselected even tabs.
    (tabs.even.fg  fg-default)
    ;; Background color of unselected even tabs.
    (tabs.even.bg  bg-default)
    ;; Background color of pinned unselected even tabs.
    (tabs.pinned.even.bg  bg-passthrough-mode)
    ;; Foreground color of pinned unselected even tabs.
    (tabs.pinned.even.fg  bg-lightest)
    ;; Background color of pinned unselected odd tabs.
    (tabs.pinned.odd.bg  fg-matched-text)
    ;; Foreground color of pinned unselected odd tabs.
    (tabs.pinned.odd.fg  bg-lightest)
    ;; Background color of pinned selected even tabs.
    (tabs.pinned.selected.even.bg  bg-selection)
    ;; Foreground color of pinned selected even tabs.
    (tabs.pinned.selected.even.fg  fg-default)
    ;; Background color of pinned selected odd tabs.
    (tabs.pinned.selected.odd.bg  bg-selection)
    ;; Foreground color of pinned selected odd tabs.
    (tabs.pinned.selected.odd.fg  fg-default)
    ;; Foreground color of selected odd tabs.
    (tabs.selected.odd.fg  fg-default)
    ;; Background color of selected odd tabs.
    (tabs.selected.odd.bg  bg-selection)
    ;; Foreground color of selected even tabs.
    (tabs.selected.even.fg  fg-default)
    ;; Background color of selected even tabs.
    (tabs.selected.even.bg  bg-selection)
    ;; Background color for webpages if unset (or empty to use the theme's
    ;; color).
    ;; webpage.bg  bg-default
    ))




(define (sss-qutebrowser-apply-color key color)
  (format #f "c.colors.~a = ~s\n" key (assq-ref sss-qutebrowser-palette color)))



(define-public sss-qutebrowser-config
  (string-join
   (append
    `("config = config"
      "c = c"
      "config.load_autoconfig(False)"
      "config.set('completion.use_best_match', True)"
      )
    (map (lambda(e) (sss-qutebrowser-apply-color (car e) (car (cdr e)))) sss-qutebrowser-theme)
    )
   "\n"))
