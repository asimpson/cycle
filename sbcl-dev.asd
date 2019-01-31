;;;; sbcl-dev.asd

(asdf:defsystem :sbcl-dev
  :description "Utilities for local development of sbcl-blog"
  :author "Adam Simpson <adam@adamsimpson.net>"
  :serial t
  :depends-on (:sbcl-blog
               :sqlite)
  :components ((:file "sbcl-dev-package")
               (:file "sbcl-dev")))
