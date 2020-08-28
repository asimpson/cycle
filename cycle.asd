;;;; cycle.asd

(asdf:defsystem :cycle
  :description "A opinionated static site builder."
  :author "Adam Simpson <adam@adamsimpson.net>"
  :license "GNU GPLv3"
  :version "0.2.11"
  :serial t
  :depends-on (
    :local-time
    :cl-json
    :cl-mustache
    :cl-ppcre
    :3bmd
    :3bmd-ext-code-blocks
    :unix-opts)
  :components ((:file "cycle"))
  :build-pathname "cycle"
  :entry-point "cycle:main")
