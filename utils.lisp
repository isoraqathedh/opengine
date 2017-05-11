;;; utils.lisp

(in-package #:opengine)

(defun now ()
  (let ((now (local-time:now)))
    (+ (* (local-time:timestamp-to-unix now) 1000)
       (local-time:timestamp-millisecond now))))
