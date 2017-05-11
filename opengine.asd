;;;; opengine.asd

(asdf:defsystem #:opengine
  :description "Keyboard extender."
  :author "Isoraķatheð Zorethan"
  :license "MIT"
  :serial t
  :components ((:file "package")
               (:file "opengine")
               (:file "gui"))
  :defsystem-depends-on (:qtools)
  :depends-on (:qtcore :qtgui)
  :build-operation "qt-program-op"
  :build-pathname "opengine"
  :entry-point "qtools-helloworld:main")
