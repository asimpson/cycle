;;;; sbcl-blog.lisp

(in-package #:sbcl-blog)

;;; "sbcl-blog" goes here. Hacks and glory await!
(require "asdf")
(ql:quickload "cl-mustache")
(ql:quickload "markdown.cl")
(ql:quickload "sqlite")
(ql:quickload "cl-json")
(ql:quickload "str")

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

(disconnect *db*)

(ql:system-apropos "list")

(defun write-posts-to-file()
  (let ((posts (execute-to-list *db* "select id,slug,title,pub_date,mod_date,excerpt,content from posts")))
    (loop for post in posts
       do
         (with-open-file (x (concatenate 'string "posts/" (second post) ".html")
                            :direction :output
                            :if-exists :supersede)
           (write-sequence (car (last post)) x)))))

(write-posts-to-file)

(defun write-data-to-file()
  (let ((posts (execute-to-list *db* "select id,slug,title,pub_date,mod_date,excerpt from posts")))
    (loop for post in posts
       do
         (with-open-file (x (concatenate 'string "posts/" (second post) ".json")
                            :direction :output
                            :if-exists :supersede)
           (write-sequence (data-to-json post) x)))))

(write-data-to-file)

(defun data-to-json(post)
  (let ((json (json:encode-json-to-string `(
                                            ("id" . ,(first post))
                                            ("slug" . ,(second post))
                                            ("title" . ,(third post))
                                            ("published" . ,(fourth post))
                                            ("modified" . ,(fifth post))
                                            ("excerpt" . ,(str:trim (sixth post)))))))
    json))

;;json
(print (assoc :foo
              (json:decode-json-from-string "{ \"foo\": \"bar\", \"baz\": \"adam\" }")))

(json:encode-json '(("foo" . "value") ("bar" . "oo")))
