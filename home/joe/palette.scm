;;; palette.scm

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

(define-module (sss-palette)
  #:use-module (gnu)
  )

;; (sss-hex-to-rgba (sss-get-color 'bg-main))

(define-public (sss-get-color sym)
  (cdr (assoc sym sss-active-palette)))

(begin
  (define (hex-to-decimal n)
    (string->number (string-append "#x" n)))
  (define* (sss-hex-to-rgba hex #:key (alpha 1))
    (let* ((digits (string-drop hex 1))
           (red (hex-to-decimal (string-take digits 2)))
           (green (hex-to-decimal (string-take (string-drop digits 2) 2)))
           (blue (hex-to-decimal (string-drop digits 4)))
           )
      (format #f "rgba(~a, ~a, ~a, ~a)" red green blue alpha)
      )
    )
  (export sss-hex-to-rgba)
  )

(define sss-palette-ef-bio
  `((bg-main . "#111111")
    (fg-main . "#cfdfd5")
    (bg-dim . "#222522")
    (fg-dim . "#808f80")
    (bg-alt . "#303230")
    (fg-alt . "#8fcfaf")
    (bg-active . "#505250")
    (bg-inactive . "#161916")
;;; Basic hues for foreground values
    (red . "#ef6560")
    (red-warmer . "#f47360")
    (red-cooler . "#ff778f")
    (red-faint . "#d56f72")
    (green . "#3fb83f")
    (green-warmer . "#7fc500")
    (green-cooler . "#00c089")
    (green-faint . "#7fc07f")
    (yellow . "#d4aa02")
    (yellow-warmer . "#e09a0f")
    (yellow-cooler . "#cfc04f")
    (yellow-faint . "#b7a07f")
    (blue . "#37aff6")
    (blue-warmer . "#78afff")
    (blue-cooler . "#32cfef")
    (blue-faint . "#6ab4cf")
    (magenta . "#d38faf")
    (magenta-warmer . "#e490df")
    (magenta-cooler . "#af9fff")
    (magenta-faint . "#caa5bf")
    (cyan . "#6fc5ef")
    (cyan-warmer . "#7fcfdf")
    (cyan-cooler . "#5dc0aa")
    (cyan-faint . "#7fb4cf")
;;; Basic hues for background values
    (bg-red-intense  .   "#b02930")
    (bg-green-intense  . "#407430")
    (bg-yellow-intense . "#8f5040")
    (bg-blue-intense  . "#4648d0")
    (bg-magenta-intense . "#a04fc5")
    (bg-cyan-intense . "#2270be")
    (bg-red-subtle . "#65201a")
    (bg-green-subtle . "#0a4425")
    (bg-green-medium . "#00552f")
    (bg-yellow-subtle . "#523324")
    (bg-blue-subtle . "#1a3863")
    (bg-magenta-subtle . "#572853")
    (bg-cyan-subtle . "#113e57")
;;; Named colors
    (primary . "#00552f")
    (primary-l . "#3fb83f")
    (primary-d . "#0a4425")
    (text . "#cfdfd5")
    (background . "#111111")
    (background-l . "#222522")
    ))

(define sss-palette-ef-cyprus
  `((bg-main . "#fcf7ef")
    (fg-main . "#242521")
    (bg-dim . "#f0ece0")
    (fg-dim . "#59786f")
    (bg-alt . "#e5e3d8")
    (fg-alt . "#7f475a")
    (bg-active . "#c5c3b8")
    (bg-inactive . "#f8f3ea")
;;; Basic hues for foreground values
    (red . "#9f0d0f")
    (red-warmer . "#dd0020")
    (red-cooler . "#ca3400")
    (red-faint . "#b05350")
    (green . "#006f00")
    (green-warmer . "#557400")
    (green-cooler . "#00824f")
    (green-faint . "#3a6f48")
    (yellow . "#a7601f")
    (yellow-warmer . "#bf4400")
    (yellow-cooler . "#a2604f")
    (yellow-faint . "#8f6f4a")
    (blue . "#375cc6")
    (blue-warmer . "#444fcf")
    (blue-cooler . "#065fbf")
    (blue-faint . "#4a659f")
    (magenta . "#9a456f")
    (magenta-warmer . "#bf456a")
    (magenta-cooler . "#8448aa")
    (magenta-faint . "#804f60")
    (cyan . "#1f70af")
    (cyan-warmer . "#3f6faf")
    (cyan-cooler . "#007a9f")
    (cyan-faint . "#4f677f")
;;; Basic hues for background values
    (bg-red-intense . "#ff8f88")
    (bg-green-intense . "#96df80")
    (bg-yellow-intense . "#efbf00")
    (bg-blue-intense . "#cfceff")
    (bg-magenta-intense . "#df9fff")
    (bg-cyan-intense . "#88cfd0")
    (bg-red-subtle . "#ffc6bf")
    (bg-green-subtle . "#c4f2af")
    (bg-green-medium . "#b3d19d")
    (bg-yellow-subtle . "#f0f07f")
    (bg-blue-subtle . "#ccdfff")
    (bg-magenta-subtle . "#fad3ff")
    (bg-cyan-subtle . "#bfefff")
    ;;; Named colors
    (primary . "#b3d19d")
    (primary-l . "#c4f2af")
    (primary-d . "#557400")
    (text . "#242521")
    (background . "#fcf7ef")
    (background-l . "#f0ece0")
    ))


(define sss-active-palette sss-palette-ef-bio)
