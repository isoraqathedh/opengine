;;; Instead of doing it like that,
;;; we can consider doing it all at once:
;;; take in a string,
;;; parse it character-by-character à la `handle-incoming-character',
;;; then output a new string.
;;; To do this we need an escape character to simulate timeout.

;;; This is fairly similar to typeit.org's thing.

(in-package #:opengine)

;;
