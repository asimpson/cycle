;;;; sbcl-blog.lisp
(require "asdf")

(in-package :sbcl-blog)

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
          (write-file (car (last post)) (concatenate 'string "posts/" (second post) ".html")))))

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

(defun write-file(contents file)
  "Write CONTENTS to FILE."
  (with-open-file (stream file
                     :direction :output
                     :if-exists :supersede)
    (write-sequence contents stream)))

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
          (write-file rendered (str:concat "site/" (cdr (assoc :slug pair)) ".html")))))

(defun gen-archive()
  "Create archive type pages."
  (let* ((template (uiop:read-file-string "pages/archive.hbs"))
         (data (json:decode-json-from-string (uiop:read-file-string "pages/archive.json")))
         (limit (cdr (assoc :paginate data)))
         (posts (reverse (sort (gen-data)
                               'sort-by-ids
                               :key 'car)))
         (times (+ (floor (length posts) limit) 1))
         (path (str:concat "site" (cdr (assoc :path data))))
         page
         pagination)
    (ensure-directories-exist path)
    ;;refactor to use dotimes
    (loop for i upto times
          do
          (setf page (str:concat path
                                 (write-to-string (+ 1 i))
                                 ".html"))
          (setf pagination (gen-pagination-for-archive (+ i 1) times))
          (when (= i
                   (- times 1))
            (write-file (mustache:render* template
                                          `( ,@pagination (:posts . ,(subseq posts (* i limit)))))
                        page))
          (when (< i
                   (- times 1))
            (write-file (mustache:render* template
                                          `( ,@pagination (:posts . ,(subseq posts (* i limit) (+ (* i limit) limit)))))
                        page)))))

(defun gen-pagination-for-archive(index limit)
  (cond
    ((eq index 1)
     '((:next . 2)))
    ((eq index limit)
     `((:prev . ,(- index 1))))
    ((> index limit)
     '())
    (t
     `((:prev . ,(- index 1)) (:next . ,(+ index 1))))))

(defun sort-by-ids (one two)
  (< (cdr one) (cdr two)))

(defun main()
  (copy-public)
  (gen-archive)
  (gen-posts))
