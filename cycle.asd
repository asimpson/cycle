;;;; cycle.asd

(asdf:defsystem :cycle
  :description "A opinionated static site builder."
  :author "Adam Simpson <adam@adamsimpson.net>"
  :license "GNU GPLv3"
  :version "0.1.5"
  :serial t
  :depends-on (
    :local-time
    :cl-json
    :cl-mustache
    :3bmd
    :3bmd-ext-code-blocks)
  :components ((:file "package")
               (:file "cycle"))
  :build-pathname "cycle"
  :entry-point "cycle:main")
