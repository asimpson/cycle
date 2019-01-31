;;;; sbcl-dev.lisp
(require "asdf")

(in-package :sbcl-dev)

(defvar *db* (sqlite:connect "BLOG"))

(defun gen-md()
  "One-off command to turn html files into md files via pandco process."
  (let* ((files (uiop:directory-files "posts/" "*.html"))
         (formatted (mapcar (lambda(file) `(,file . ,(sbcl-blog:file-basename file))) files)))
    (loop for file in formatted
       do
         (uiop:launch-program (concatenate 'string "/usr/local/bin/pandoc "
                                          (uiop:unix-namestring (car file))
                                          " -t gfm --wrap=none -o posts/"
                                          (cdr file)
                                          ".md")))))

(defun write-posts-to-file()
  "This grabs the raw data out of the db and writes it to HTML files."
  (let ((posts (sqlite:execute-to-list *db* "select id,slug,title,pub_date,mod_date,excerpt,content from posts")))
    (loop for post in posts
       do
          (sbcl-blog:write-file (car (last post)) (concatenate 'string "posts/" (second post) ".html")))))
