;;;; gui.lisp

(in-package #:opengine)
(named-readtables:in-readtable :qtools)

(define-widget main (QWidget)
  ())

(define-subwidget (main change-stack) (q+:make-qpushbutton "Change stack" main))
(define-subwidget (main change-program) (q+:make-qpushbutton "Change program" main))
(define-subwidget (main export) (q+:make-qpushbutton "Export" main))

(define-subwidget (main current-stack) (q+:make-qlabel "Main" main))

(define-subwidget (main main-stack-display) (q+:make-qlineedit main)
  (setf (q+:placeholder-text main-stack-display) "Main stack")
  (q+:set-read-only main-stack-display t))

(define-subwidget (main main-stack-indicator) (q+:make-qlabel "●" main))
(define-subwidget (main other-stack-indicator) (q+:make-qlabel "●" main))

(define-subwidget (main other-stack-display) (q+:make-qlineedit main)
  (setf (q+:placeholder-text other-stack-display) "Other stack")
  (q+:set-read-only other-stack-display t))

(define-subwidget (main layout) (q+:make-qvboxlayout main)
  (q+:add-widget layout current-stack)
  (let ((main-stack-assembly (q+:make-qhboxlayout))
        (other-stack-assembly (q+:make-qhboxlayout))
        (button-panel (q+:make-qhboxlayout)))
    ;; Main stack
    (q+:add-widget main-stack-assembly main-stack-indicator)
    (q+:add-widget main-stack-assembly main-stack-display)

    ;; Other stack
    (q+:add-widget other-stack-assembly other-stack-indicator)
    (q+:add-widget other-stack-assembly other-stack-display)

    ;; Buttons
    (q+:add-widget button-panel change-stack)
    (q+:add-widget button-panel change-program)
    (q+:add-widget button-panel export)

    ;; Putting it all together
    (q+:add-layout layout other-stack-assembly)
    (q+:add-layout layout main-stack-assembly)
    (q+:add-layout layout button-panel)))

(define-slot (main gui-switch-mode) ((mode-name symbol))
  (declare (connected change-stack (released)))
  (dolist (i (list main-stack-indicator other-stack-indicator))
    (q+:set-style-sheet i "QLabel { color : auto; }"))
  (q+:set-style-sheet (ecase mode-name
                        (:main main-stack-indicator)
                        (:other other-stack-indicator))
                      "QLabel { color : red; }"))

(defun main ()
  (with-main-window (window (make-instance 'main))))
