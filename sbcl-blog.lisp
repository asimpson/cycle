;;;; sbcl-blog.lisp
(require "asdf")

(in-package :sbcl-blog)

(defun gen-data ()
  "Read markdown posts from 'posts' dir and retrieve data from each matching json file."
  (let* ((posts (uiop:directory-files "posts/" "*.md"))
         (struct (mapcar
                  (lambda(post)
                    (list post (car (uiop:directory-files "posts/" (concatenate 'string
                                                                    (file-basename post)
                                                                    ".json"))))) posts)))
    (mapcar #'parse-post struct)))

(defun parse-post (post)
  "Convert json data to list."
  (let ((json (uiop:read-file-string (car (cdr post)))))
    (json:decode-json-from-string json)))

(defun full-path-as-string (dir)
  (namestring (truename dir)))

(defun copy-public ()
  (let ((files (uiop:directory-files "public/**/")))
  (ensure-directories-exist "site/")
  (dolist (file files)
    (multiple-value-bind (key parts name) (uiop/pathname:split-unix-namestring-directory-components (namestring file))
      (uiop:copy-file file (concatenate 'string (full-path-as-string "site/")
                                         (return-public-child-dir parts)
                                         name))))))

(defun return-public-child-dir (dir)
  (let ((folder (concatenate 'string (car (last dir)) "/")))
    (unless (equal folder "public/")
      (unless (uiop/filesystem:directory-exists-p (concatenate 'string "site/" folder))
        (ensure-directories-exist (concatenate 'string (full-path-as-string "site/") folder)))
      folder)))

(defun parse-date (date)
  (let* ((parsed (chronicity:parse date))
         (month (write-to-string (chronicity:month-of parsed)))
         (year (write-to-string (chronicity:year-of parsed)))
         (day (write-to-string (chronicity:day-of parsed))))
    (concatenate 'string month "/" day "/" year)))

(defun write-file (contents file)
  "Write CONTENTS to FILE."
  (with-open-file (stream file
                     :direction :output
                     :if-exists :supersede)
    (write-sequence contents stream)))

(defun gen-posts ()
  "Generate posts from post data, templates, and css file(s)."
  (let ((data (gen-data))
        (template (uiop:read-file-string "templates/post.mustache"))
        (css (uiop:read-file-string "site.css"))
        (3bmd-code-blocks:*code-blocks* t)
        (mustache:*default-pathname-type* "mustache")
        (mustache:*load-path* (list (namestring (car (uiop:subdirectories "./templates")))))
        post
        rendered)
    (loop for pair in data
       do
         (setf post (with-output-to-string (p)
                      (3bmd:parse-string-and-print-to-stream
                       (uiop:read-file-string (concatenate
                                               'string
                                               "posts/"
                                               (cdr (assoc :slug pair))
                                               ".md"))
                       p)))
         (setf rendered (mustache:render* template `((:content . ,post)
                                                     (:pub_date . ,(cdr (assoc :published pair)))
                                                     (:mod_date . ,(cdr (assoc :modified pair)))
                                                     (:modifiedDate . ,(parse-date (cdr (assoc :modified pair))))
                                                     (:formattedDate . ,(parse-date (cdr (assoc :published pair))))
                                                     (:link . ,(cdr (assoc :slug pair)))
                                                     (:css . ,css)
                                                     (:title . ,(cdr (assoc :title pair))))))
          (write-file rendered (concatenate
                                'string
                                "site/writing/"
                                (cdr (assoc :slug pair))
                                ".html")))))

(defun gen-archive ()
  "Create archive type pages."
  (let* ((template (uiop:read-file-string "pages/archive.mustache"))
         (data (json:decode-json-from-string (uiop:read-file-string "pages/archive.json")))
         (css `(:css . ,(uiop:read-file-string "site.css")))
         (limit (cdr (assoc :paginate data)))
         (posts (reverse (sort (gen-data)
                               'sort-by-ids
                               :key 'car)))
         (times (+ (floor (length posts) limit) 1))
         (path (concatenate 'string "site" (cdr (assoc :path data))))
         page
         pagination)
    (ensure-directories-exist path)
    ;;refactor to use dotimes
    (loop for i upto times
          do
          (setf page (concatenate 'string
                                  path
                                  (write-to-string (+ 1 i))
                                  ".html"))
          (setf pagination (gen-pagination-for-archive (+ i 1) times))
          (when (= i (- times 1))
            (write-file (mustache:render* template
                                          `( ,css ,@pagination (:posts . ,(subseq
                                                                           posts
                                                                           (* i limit)))))
                        page))
          (when (< i (- times 1))
            (write-file (mustache:render* template
                                          `( ,css ,@pagination (:posts . ,(subseq
                                                                           posts
                                                                           (* i limit)
                                                                           (+ (* i limit) limit)))))
                        page)))))

(defun gen-pagination-for-archive (index limit)
  "Given INDEX and LIMIT this will return an alist of values for pagination."
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

(defun file-basename (path)
  "Return the file name without extension for PATH."
  (car (uiop:split-string (file-namestring path) :separator ".")))

(defun gen-pages ()
  "Generate any markdown files in the pages/ dir using matching JSON files as context."
  (let ((pages (uiop:directory-files "pages/" "*.md"))
        (3bmd-code-blocks:*code-blocks* t)
        (css `(:css . ,(uiop:read-file-string "site.css")))
        (template (uiop:read-file-string "templates/page.mustache"))
        data
        content)
      (dolist (page pages)
        (setf data (json:decode-json-from-string (uiop:read-file-string
                                                  (concatenate 'string
                                                               "pages/"
                                                               (file-basename page)
                                                               ".json"))))
        (setf content (with-output-to-string (p)
                        (3bmd:parse-string-and-print-to-stream (uiop:read-file-string page) p)))
        (ensure-directories-exist (concatenate 'string "site/" (cdr (assoc :permalink data))))
        (write-file (mustache:render* template `( ,css ,@data (:content . ,content)))
                    (concatenate 'string "site/" (cdr (assoc :permalink data)) ".html")))))

(defun main ()
  "The pipeline to build the site."
  (copy-public)
  (gen-archive)
  (gen-pages)
  ;;build rss feed
  ;;build sitemap
  ;;desssssssign
  ;;iframe service for tweets, very minimal JS
  (gen-posts))
