;;;; sbcl-blog.lisp

(in-package #:sbcl-blog)

;;; "sbcl-blog" goes here. Hacks and glory await!
(require "asdf")
(ql:quickload "cl-mustache")
(ql:quickload "markdown.cl")
(ql:quickload "clsql-sqlite3")

(let* ((post (markdown.cl:parse (uiop:read-file-string "post.md")))
       (template (uiop:read-file-string "template.hbs"))
       (rendered (mustache:render* template `((:content . ,post)))))
  (print post)
  (with-open-file (x "result.html"
          :direction :output
          :if-exists :supersede)
        (write-sequence rendered x)))

(defun extract-posts()
  (let* ((
      ))
