;;;; sbcl-blog.lisp

(in-package #:sbcl-blog)

;;; "sbcl-blog" goes here. Hacks and glory await!
(require "asdf")
(ql:quickload "cl-mustache")
(ql:quickload "sqlite")
(ql:quickload "cl-json")
(ql:quickload "str")
(ql:quickload "3bmd")
(ql:quickload "3bmd-ext-code-blocks")
(ql:quickload "cl-fad")
(ql:quickload "chronicity")

(use-package :sqlite)
(use-package :json)

(defvar *db* (connect "BLOG"))

(defun gen-md()
  "One-off command to turn html files into md files via pandco process."
  (let* ((files (uiop:directory-files "posts/" "*.html"))
         (formatted (mapcar (lambda(file) `(,file . ,(car (str:split-omit-nulls "." (file-namestring file))))) files)))
    (loop for file in formatted
       do
         (uiop:launch-program (str:concat "/usr/local/bin/pandoc " (uiop:unix-namestring (car file)) " -t gfm --wrap=none -o posts/" (cdr file) ".md")))))

(defun gen-data()
  "Read markdown posts from 'posts' dir and retrieve data from each matching json file."
  (let* ((posts (uiop:directory-files "posts/" "*.md"))
         (struct (mapcar
                  (lambda(post)
                    (list post (car (uiop:directory-files "posts/" (str:concat
                                                                    (car (str:split-omit-nulls "." (file-namestring post)))
                                                                    ".json"))))) posts)))
    (mapcar #'parse-post struct)))

(defun write-posts-to-file()
  "This grabs the raw data out of the db and writes it to HTML files."
  (let ((posts (execute-to-list *db* "select id,slug,title,pub_date,mod_date,excerpt,content from posts")))
    (loop for post in posts
       do
         (with-open-file (x (concatenate 'string "posts/" (second post) ".html")
                            :direction :output
                            :if-exists :supersede)
           (write-sequence (car (last post)) x)))))

(defun parse-post(post)
  "Convert json data to list."
  (let ((json (uiop:read-file-string (car (cdr post)))))
    (json:decode-json-from-string json)))

(defun full-path-as-string(dir)
  (namestring (truename dir)))

(defun copy-public()
  (let ((files (uiop:directory-files "public/**/")))
  (ensure-directories-exist "site/")
  (dolist (file files)
    (multiple-value-bind (key parts name) (uiop/pathname:split-unix-namestring-directory-components (namestring file))
      (cl-fad:copy-file file (str:concat (full-path-as-string "site/") (return-public-child-dir parts) name) :overwrite t)))))

(defun return-public-child-dir(dir)
  (let ((folder (str:concat (car (last dir)) "/")))
    (unless (equal folder "public/")
      (unless (uiop/filesystem:directory-exists-p (str:concat "site/" folder))
        (ensure-directories-exist (str:concat (full-path-as-string "site/") folder)))
      folder)))

(defun parse-date(date)
  (let* ((parsed (chronicity:parse date))
         (month (write-to-string (chronicity:month-of parsed)))
         (year (write-to-string (chronicity:year-of parsed)))
         (day (write-to-string (chronicity:day-of parsed))))
    (str:concat month "/" day "/" year)))

(defun gen-posts()
  "Generate posts from post data, templates, and css file(s)."
  (let ((data (gen-data))
        (template (uiop:read-file-string "templates/post.hbs"))
        (css (uiop:read-file-string "site.css"))
        (3bmd-code-blocks:*code-blocks* t)
        (mustache:*default-pathname-type* "hbs")
        (mustache:*load-path* (list (namestring (car (uiop:subdirectories "./templates")))))
        post
        rendered)
    (loop for pair in data
       do
         (setq post (with-output-to-string (p)
                      (3bmd:parse-string-and-print-to-stream (uiop:read-file-string (str:concat "posts/" (cdr (assoc :slug pair)) ".md")) p)))
         (setq rendered (mustache:render* template `((:content . ,post)
                                                     (:pub_date . ,(cdr (assoc :published pair)))
                                                     (:mod_date . ,(cdr (assoc :modified pair)))
                                                     (:modifiedDate . ,(parse-date (cdr (assoc :modified pair))))
                                                     (:formattedDate . ,(parse-date (cdr (assoc :published pair))))
                                                     (:link . ,(cdr (assoc :slug pair)))
                                                     (:css . ,css)
                                                     (:title . ,(cdr (assoc :title pair))))))
         (with-open-file (x (str:concat "site/" (cdr (assoc :slug pair)) ".html")
          :direction :output
          :if-exists :supersede)
        (write-sequence rendered x)))))
