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

(load "../palette.scm")
(load "./hyprlang.scm")

(define-module (sss hyprland hyprpaper)
  #:use-module (gnu)
  #:use-module (ice-9 match)
  #:use-module (ice-9 exceptions)
  #:use-module (sss palette)
  #:use-module (gnu home services shepherd)
  #:use-module (shepherd service timer)
  #:use-module (sss hyprland hyprlang))

(use-service-modules shepherd)

;; Define diverse wallpapers based on the active color scheme. 
(begin
  (define* (sss-hypr-wallpapers #:key clone-dir palette)
    (match palette
      ('sss-palette-ef-cyprus (list (format #f
                                     "~a/submodules/digital-art-dreams/wallpapers/sss/some-forest.jpg"
                                     clone-dir)))
      ('sss-palette-ef-dream (list (format #f
                                    "~a/submodules/digital-art-dreams/wallpapers/sss/1362745.png"
                                    clone-dir)
                                   (format #f
                                    "~a/submodules/digital-art-dreams/wallpapers/sss/inazuma.jpg"
                                    clone-dir)
                                   (format #f
                                    "~a/submodules/digital-art-dreams/wallpapers/sss/ei-chiyo.jpg"
                                    clone-dir)
                                   (format #f
                                    "~a/submodules/digital-art-dreams/wallpapers/sss/diluc-tree.jpg"
                                    clone-dir)))
      ('sss-palette-heavy-metal (list (format #f
                                       "~a/submodules/digital-art-dreams/wallpapers/sss/heavy-wall3.jpg"
                                       clone-dir)))
      ('sss-palette-solarized-light (list (format #f
                                           "~a/submodules/digital-art-dreams/wallpapers/sss/PXL_20250326_193029385.MP.jpg"
                                           clone-dir)))
      ('sss-palette-ef-autumn (list (format #f
                                     "~a/submodules/digital-art-dreams/wallpapers/sss/0mar2ygf59je1.jpeg"
                                     clone-dir)))
      ('sss-palette-ef-bio (list (format #f
                                  "~a/submodules/digital-art-dreams/wallpapers/sss/some-forest.jpg"
                                  clone-dir)))
      ('sss-palette-everforest-dark (list (format #f
                                           "~a/submodules/digital-art-dreams/wallpapers/sss/redwood-forest.jpg"
                                           clone-dir)))
      ('sss-palette-everforest-dark (list (format #f
                                           "~a/submodules/digital-art-dreams/wallpapers/sss/joshua.jpg"
                                           clone-dir)))
      (_ (raise-exception (make-exception-with-message (format #f
                                                        "exception ocurred! unknown palette selected: ~a"
                                                        palette))))))
  (export sss-hypr-wallpapers))

;; hyprpaper: Hyprpaper is a blazing fast wallpaper utility for Hyprland
;; with the ability to dynamically change wallpapers through sockets.
;; It will work on all wlroots-based compositors, though.
;;
;; https://github.com/hyprwm/hyprpaper
(begin
  (define* (sss-hyprpaper-config #:key imgs)
    (let* ((preloads (map (lambda (i)
                            `(preload unquote i)) imgs))
           (splash `((splash . false)))
           (current-img (list-ref imgs
                                  (random (length imgs))))
           (wallpaper `((wallpaper unquote
                                   (format #f ",~a" current-img))))
           (config-lines (map (lambda (l)
                                (serialize-hypr-setting (car l)
                                                        (cdr l)))
                              (append splash preloads wallpaper))))
      (string-join (append `("# ====== SSS Hyprpaper configuration ======" "#"
                             "# auto-generated file, DO NOT EDIT!" "")
                           config-lines) "\n")))
  (export sss-hyprpaper-config))

(define (mk-random-cmd walls)
  (let* ((wall-idx -1))
    (format #f
            (string-append "case $(( $(date +%s) % ~a )) in ~a esac; "
             "echo \"$WALL\" && hyprctl --instance 0 hyprpaper reload \",$WALL\"")
            (length walls)
            (string-join (map (lambda (w)
                                (set! wall-idx
                                      (+ 1 wall-idx))
                                (format #f "~a) WALL=\"~a\";;" wall-idx w))
                              walls) " "))))

(begin
  (define* (sss-hyprpaper-svc #:key clone-dir palette)
    (let* ((walls (sss-hypr-wallpapers #:clone-dir clone-dir
                                       #:palette palette))
           (random-cmd (mk-random-cmd walls)))
      `((".config/hypr/hyprpaper.conf" ,(plain-file "hyprpaper.conf"
                                                    (sss-hyprpaper-config
                                                     #:imgs walls)))
        (".config/hypr/sss-random-hyprpaper.sh" ,(plain-file
                                                  "sss-random-hyprpaper.sh"
                                                  random-cmd)))))
  (export sss-hyprpaper-svc))

(begin
  (define* (sss-random-hyprpaper-service #:key username)
    (simple-service 'sss-random-hyprpaper home-shepherd-service-type
                    (list (shepherd-timer '(sss-random-hyprpaper)
                                          #~(cron-string->calendar-event
                                             "*/10 * * * *")
                                          `("sh" ,(format #f
                                                   "/home/~a/.config/hypr/sss-random-hyprpaper.sh"
                                                   username))))))
  (export sss-random-hyprpaper-service))

