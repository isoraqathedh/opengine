;;;; gui.lisp

(in-package #:opengine)
(named-readtables:in-readtable :qtools)

(define-widget main (QWidget)
  ())

(define-subwidget (main button) (q+:make-qpushbutton "Change stack" main))

(define-subwidget (main current-stack) (q+:make-qlabel "Main" main))

(define-subwidget (main main-stack-display) (q+:make-qlineedit main)
  (setf (q+:placeholder-text main-stack-display) "Main stack")
  (q+:set-read-only main-stack-display t))

(define-subwidget (main other-stack-display) (q+:make-qlineedit main)
  (setf (q+:placeholder-text other-stack-display) "Other stack")
  (q+:set-read-only other-stack-display t))

(define-subwidget (main layout) (q+:make-qvboxlayout main)
  (q+:add-widget layout current-stack)
  (q+:add-widget layout main-stack-display)
  (q+:add-widget layout other-stack-display)
  (q+:add-widget layout button))

(defun timestamp (&optional (universal-time (get-universal-time)))
  (multiple-value-bind (s m h dd mm yy day) (decode-universal-time universal-time)
    (format NIL "~[Monday~;Tuesday~;Wednesday~;Thursday~;Friday~;Saturday~;Sunday~] ~
                 the ~d~[st~;nd~;rd~:;th~] ~
                 of ~[January~;February~;March~;April~;May~;June~;July~;August~;September~;October~;November~;December~] ~
                 ~d, ~
                 ~2,'0d:~2,'0d:~2,'0d"
            day dd (1- (mod dd 10)) (1- mm) yy h m s)))

(define-slot (main button-pressed) ()
  (declare (connected button (released)))
  (setf (q+:text current-stack)
        (if (string= (q+:text current-stack) "Main")
            "Other"
            "Main")))

(defun main ()
  (with-main-window (window (make-instance 'main))))
