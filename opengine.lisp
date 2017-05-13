;;;; opengine.lisp

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

(defun toggle-stacks ()
  "Change which stack is currently accepting characters."
  (setf (current-stack *current-instance*)
        (if (eql :main (current-stack *current-instance*))
            :other
            :main)))

;;; Stack operations
(defun append-to-stack (character &optional stack)
  "Add a character to a stack.

After adding to the other stack,
check if the current other stack matches an existing stack.
If so, delete and append associated character."
  (ecase (or stack (current-stack *current-instance*))
    (:main
     (setf (main-stack *current-instance*)
           (concatenate 'string (main-stack *current-instance*)
                        (string character))))
    (:other
     (setf (other-stack *current-instance*)
           (concatenate 'string (other-stack *current-instance*)
                        (string character)))
     (let ((found-match (get-sequence character *current-instance*)))
       (when found-match
         (append-to-stack found-match :main)
         (setf (other-stack *current-instance*) (make-string 0)))))))

(defun modify-main-stack (character)
  "Change the last character of the main stack with something else."
  (setf (aref (main-stack *current-instance*)
              (1- (length (main-stack *current-instance*))))
        character))

(defun delete-from-stack ()
  "Delete the last character of the main stack."
  (ecase (current-stack *current-instance*)
    (:main (setf (main-stack *current-instance*)
                 (subseq (main-stack *current-instance*)
                         0 (1- (length (main-stack *current-instance*))))))
    (:other (setf (other-stack *current-instance*)
                  (subseq (other-stack *current-instance*)
                          0 (1- (length (other-stack *current-instance*))))))))

(defun flush ()
  (uiop:run-program '("xclip" "-selection" "c")
                    :input (make-string-input-stream (main-stack *current-instance*)))
  (setf (main-stack *current-instance*) ""))

(defun get-character-in-order (character n)
  (let ((character-alist (get-key character *current-instance*)))
    (first (nth (mod n (length character-alist)) character-alist))))

(defun handle-incoming-character (character)
  "Handle a character that is intercepted from the GUI."
  (with-accessors ((current-stack current-stack)
                   (last-key last-key)
                   (last-time last-time)
                   (last-iteration last-iteration)) *current-instance*
    (let ((next-iteration (1+ last-iteration))
          (current-time (now)))
      (setf last-iteration 0)
      (cond
        ((eql character #\Rubout)
         (delete-from-stack))
        ((eql character #\Tab)
         (toggle-stacks))
        ((eql character #\Escape)
         (flush))
        ((eql current-stack :other)
         (append-to-stack character))
        ((and (eql character last-key)
              (eql current-stack :main)
              (< (- current-time last-time)
                 (opengine-variable 'timeout *current-instance*)))
         (setf last-iteration next-iteration)
         (modify-main-stack (get-character-in-order character last-iteration)))
        (t
         (setf last-key character)
         (append-to-stack (get-character-in-order character last-iteration))))
      (setf last-time current-time))))
