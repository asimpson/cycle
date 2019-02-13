;;;; package.lisp

(defpackage :cycle
;;https://lisp-lang.org/style-guide/#one-package-per-file
  (:use :cl)
  (:export
    :main
    :write-file
    :split-string
    :file-basename))
