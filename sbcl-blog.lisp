;;;; sbcl-blog.lisp

(in-package #:sbcl-blog)

;;; "sbcl-blog" goes here. Hacks and glory await!
(require "asdf")
(ql:quickload "cl-mustache")
(ql:quickload "markdown.cl")
(ql:quickload "sqlite")
(ql:quickload "cl-json")
(ql:quickload "str")

(use-package :json)

(defun gen-md()
  "One-off command to turn html files into md files via pandco process."
  (let* ((files (uiop:directory-files "posts/" "*.html"))
         (formatted (mapcar (lambda(file) `(,file . ,(car (str:split-omit-nulls "." (file-namestring file))))) files)))
    (loop for file in formatted
       do
         (uiop:launch-program (str:concat "/usr/local/bin/pandoc " (uiop:unix-namestring (car file)) " --wrap=none -o posts/" (cdr file) ".md")))))

(defun gen-data()
  "Read markdown posts from 'posts' dir and retrieve data from each matching json file."
  (let* ((posts (uiop:directory-files "posts/" "*.md"))
         (struct (mapcar
                  (lambda(post)
                    (list post (car (uiop:directory-files "posts/" (str:concat
                                                                    (car (str:split-omit-nulls "." (file-namestring post)))
                                                                    ".json"))))) posts)))
    (mapcar #'parse-post struct)))

(defun parse-post(post)
  "Convert json data to list."
  (let ((json (uiop:read-file-string (car (cdr post)))))
    (json:decode-json-from-string json)))

(defun gen-site()
  "Generate site from post data, templates, and css file(s)."
  (let ((data (gen-data))
        (template (uiop:read-file-string "template.hbs"))
        post
        rendered)
    (loop for pair in data
       do
         (setq post (markdown.cl:parse (uiop:read-file-string (str:concat "posts/" (cdr (assoc :slug pair)) ".md"))))
         (setq rendered (mustache:render* template `((:content . ,post)
                                                     (:link . ,(cdr (assoc :slug pair)))
                                                     (:title . ,(cdr (assoc :title pair))))))
         (with-open-file (x (str:concat "posts/result-" (cdr (assoc :slug pair)) ".html")
          :direction :output
          :if-exists :supersede)
        (write-sequence rendered x)))))

(gen-site)
