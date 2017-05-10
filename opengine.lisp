;;;; opengine.lisp

(in-package #:opengine)

(defclass opengine-instance ()
  ((program :reader program)
   (main-stack :accessor main-stack)
   (other-stack :accessor other-stack))
  (:documentation "Object representing an opengine instance."))
(defvar *current-instance* "")

(defun append-to-main-stack (character)
  (setf *main-stack* (concatenate 'string *main-stack* (string character))))
(defun append-to-other-stack (character)
  (setf *other-stack* (concatenate 'string *other-stack* (string character)))
  (when (find *other-stack* nil  :key #'car)
    (append-to-main-stack (get-match *other-stack*))))
(defun modify-main-stack (character)
  (setf (aref *main-stack* (1- (length *main-stack*))) character))
(defun delete-main-stack ()
  (setf ()))
(defun flush-and-exit (&optional kill)
  (uiop:run-program '("xclip" "-selection" "c")
                    :input (make-string-input-stream *main-stack*))
  (setf *main-stack* "")
  (when kill
    (uiop:die 0)))
