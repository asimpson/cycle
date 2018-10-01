;;;; sbcl-blog.lisp

(in-package #:sbcl-blog)

;;; "sbcl-blog" goes here. Hacks and glory await!
(require "asdf")
(ql:quickload "cl-mustache")
(ql:quickload "markdown.cl")
(ql:quickload "sqlite")
(ql:quickload "cl-json")

(use-package :sqlite)
(use-package :json)

;;templates
(let* ((post (markdown.cl:parse (uiop:read-file-string "post.md")))
       (template (uiop:read-file-string "template.hbs"))
       (rendered (mustache:render* template `((:content . ,post)))))
  (print post)
  (with-open-file (x "result.html"
          :direction :output
          :if-exists :supersede)
        (write-sequence rendered x)))

;;sqlite
(defvar *db* (connect "BLOG"))
(print (execute-single *db* "select content from posts"))
(print (execute-to-list *db* "select title, content from posts"))
(disconnect *db*)

;;json
(print (assoc :foo
              (json:decode-json-from-string "{ \"foo\": \"bar\", \"baz\": \"adam\" }")))
