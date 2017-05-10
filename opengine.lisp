;;;; opengine.lisp

(in-package #:opengine)

(defclass opengine-instance ()
  ((program :reader program)
   (main-stack :accessor main-stack
               :initform (make-string 0))
   (other-stack :accessor other-stack
                :initform (make-string 0)))
  (:documentation "Object representing an opengine instance."))
(defvar *current-instance*)

(defun append-to-main-stack (character)
  "Add a character to the main stack."
  (setf (main-stack *current-instance*)
        (concatenate 'string (main-stack *current-instance*)
                     (string character))))
(defun append-to-other-stack (character)
  "Add a character to the other stack.

After this, check if the current "
  (setf (other-stack *current-instance*)
        (concatenate 'string (other-stack *current-instance*)
                     (string character)))
  (let ((found-match (assoc (other-stack *current-instance*)
                            (assoc :other-stack-matches (program *current-instance*)))))
    (when found-match
      (append-to-main-stack (cdr found-match)))))

(defun modify-main-stack (character)
  "Change the last character of the main stack with something else."
  (setf (aref (main-stack *current-instance*)
              (1- (length *main-stack*)))
        character))

(defun delete-main-stack ()
  "Delete the last character of the main stack."
  (setf (main-stack *current-instance*)
        (subseq (main-stack *current-instance*)
                0 (- (length (main-stack *current-instance*)) 1))))
(defun delete-other-stack ()
  "Delete the last character of the other stack."
  (setf (other-stack *current-instance*)
        (subseq (other-stack *current-instance*)
                0 (- (length (other-stack *current-instance*)) 1))))

(defun flush ()
  (uiop:run-program '("xclip" "-selection" "c")
                    :input (make-string-input-stream *main-stack*))
  (setf (main-stack *current-instance*) ""))
