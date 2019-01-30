;;;; sbcl-blog.asd

(asdf:defsystem :sbcl-blog
  :description "The static site builder for adamsimpson.net"
  :author "Adam Simpson <adam@adamsimpson.net>"
  :license "MIT"
  :serial t
  :depends-on (:cl-mustache
               :sqlite
               :cl-json
               :3bmd
               :3bmd-ext-code-blocks
               :chronicity)
  :components ((:file "package")
               (:file "sbcl-blog")))
