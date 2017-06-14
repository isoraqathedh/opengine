;;; Instead of doing it like that,
;;; we can consider doing it all at once:
;;; take in a string,
;;; parse it character-by-character à la `handle-incoming-character',
;;; then output a new string.
;;; To do this we need an escape character to simulate timeout.

;;; This is fairly similar to typeit.org's thing.

(in-package #:opengine)

(defun handle-incoming-command-string (string)
  "Handle an entire incoming string at once."
  ;; The thing about having everything there at once
  ;; is that there's no longer any problem with figuring out timeouts.
  ;; The downside is that there's no longer a timeout for us to wait for.
  ;; To get around that we need an additional escape character.
  ;; Which might need to be configured.
  (loop for i across string
        do t))
