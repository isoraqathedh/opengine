;;;; package.lisp

(defpackage #:opengine
  (:nicknames #:info.isoraqathedh.opengine)
  (:use #:cl+qt)
  (:export #:main))

(defpackage #:opengine-program
  (:nicknames #:info.isoraqathedh.opengine-program)
  (:export #:var #:key #:match)
  (:import-from #:cl #:nil #:t))
