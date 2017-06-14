;;;; compat.lisp
;;; Version where behaviour is built
;;; to emulate the old AHK version as much as possible.

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
