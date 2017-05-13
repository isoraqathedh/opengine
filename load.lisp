;;;; load.lisp
;;; Handles the reading and loading of program files.

(in-package #:opengine)

(defmacro opengine-program:var (var value)
  `(setf (opengine-variable ',var *current-instance*) ,value))

(defmacro opengine-program:key (key &rest scroll-sequence)
  `(setf (gethash ,key (key-list *current-instance*))
         ',scroll-sequence))

(defun opengine-program:match (sequence associated-character)
  (setf (gethash sequence (other-stack-substitutions *current-instance*))
        associated-character))

(defun load-program (file)
  (let ((*package* (find-package '#:opengine-program)))
    (setf *current-instance* (make-instance 'opengine-instance))
    (load file)))
