;;;; cycle-dev.asd

(asdf:defsystem :cycle-dev
  :description "Utilities for local development of cycle."
  :author "Adam Simpson <adam@adamsimpson.net>"
  :serial t
  :depends-on (:cycle
               :sqlite)
  :components ((:file "cycle-dev")))
