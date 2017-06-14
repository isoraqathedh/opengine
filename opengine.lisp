;;;; opengine.lisp
;;; Code that is common to both the compatibility and the GUI-centric version.

(in-package #:opengine)

(defclass opengine-instance ()
  ((key-list :accessor key-list
             :initform (make-hash-table))
   (variable-list :accessor variable-list
                  :initform (make-hash-table))
   (other-stack-substitutions :accessor other-stack-substitutions
                              :initform (make-hash-table :test 'equal))
   (last-key :accessor last-key
             :initform nil)
   (last-time :accessor last-time
              :initform (now))
   (last-iteration :accessor last-iteration
                   :initform 0)
   (current-stack :accessor current-stack
                  :initarg :starting-stack
                  :initform :main)
   (main-stack :accessor main-stack
               :initform (make-string 0))
   (other-stack :accessor other-stack
                :initform (make-string 0)))
  (:documentation "Object representing an opengine instance."))
(defvar *current-instance*)

(defgeneric opengine-variable (variable-name opengine-instance)
  (:documentation "Gets the variable name associated with the instance.")
  (:method (variable-name (opengine-instance opengine-instance))
    (gethash variable-name (variable-list opengine-instance))))

(defgeneric (setf opengine-variable) (value variable-name opengine-instance)
  (:documentation "Sets the variable name associated with the instance.")
  (:method (value variable-name (opengine-instance opengine-instance))
    (setf (gethash variable-name (variable-list opengine-instance)) value)))

(defgeneric get-key (key opengine-instance)
  (:documentation "Get a key's associated sequence in the instance.")
  (:method (key (opengine-instance opengine-instance))
    (gethash key (key-list opengine-instance))))

(defgeneric get-sequence (sequence opengine-instance)
  (:documentation "Get a string's associated character in the instance.")
  (:method (key (opengine-instance opengine-instance))
    (gethash key (other-stack-substitutions opengine-instance))))

