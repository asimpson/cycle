;;;; sbcl-blog.lisp
(require "asdf")

(in-package :sbcl-blog)

(print "Building site...")
(setf mustache:*load-path* `(,(namestring (car (uiop:subdirectories "./templates")))))
(setf mustache:*default-pathname-type* "mustache")
(setf 3bmd-code-blocks:*code-blocks* t)
(defvar css (uiop:read-file-string "site.css")
  "CSS for the site.")
(defvar posts nil "Global posts variable.")
(defvar days '("Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"))
(defvar months '("Jan"
                 "Feb"
                 "Mar"
                 "Apr"
                 "May"
                 "Jun"
                 "Jul"
                 "Aug"
                 "Sep"
                 "Oct"
                 "Nov"
                 "Dec"))
(defvar us-time-zone-codes '((4 . "EDT")
                           (5 . "EST")
                           (6 . "CDT")
                           (7 . "CST")
                           (8 . "MDT")
                           (9 . "MST")
                           (10 . "PDT")
                           (11 . "PST")))

(defun gen-data ()
  "Read markdown posts from 'posts' dir and retrieve data from each matching json file."
  (let* ((posts (uiop:directory-files "posts/" "*.md"))
         (struct (mapcar
                  (lambda (post)
                    (list post (car (uiop:directory-files "posts/" (concatenate
                                                                    'string
                                                                    (file-basename post)
                                                                    ".json")))))
                  posts)))
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

(defun post-for-slug (slug)
  (with-output-to-string (p)
    (3bmd:parse-string-and-print-to-stream
     (uiop:read-file-string (concatenate
                             'string
                             "posts/"
                             slug
                             ".md"))
     p)))

(defun gen-posts ()
  "Generate posts from post data, templates, and css file(s)."
  (let ((data posts)
        (template (uiop:read-file-string "templates/post.mustache"))
        post
        rendered)
    (dolist (pair data)
      (setf post (post-for-slug (cdr (assoc :slug pair))))
      (setf rendered (mustache:render* template `((:content . ,post)
                                                  (:pub_date . ,(cdr (assoc :published pair)))
                                                  (:mod_date . ,(cdr (assoc :modified pair)))
                                                  (:modifiedDate . ,(parse-date (cdr (assoc :modified pair))))
                                                  (:formattedDate . ,(parse-date (cdr (assoc :published pair))))
                                                  (:link . ,(cdr (assoc :slug pair)))
                                                  (:description . ,(cdr (assoc :excerpt pair)))
                                                  (:slug . ,(concatenate 'string
                                                                         "/writing/"
                                                                         (cdr (assoc :slug pair))))
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
         (css `(:css . ,css))
         (limit (cdr (assoc :paginate data)))
         (posts (reverse (sort posts
                               'sort-by-ids
                               :key 'car)))
         (times (+ (floor (length posts) limit) 1))
         (path (concatenate 'string "site" (cdr (assoc :path data))))
         page
         pagination
         slug)
    (ensure-directories-exist path)
    (dotimes (i times)
      (setf page (concatenate 'string
                              path
                              (write-to-string (+ 1 i))
                              ".html"))
      (setf slug (concatenate 'string
                              (cdr (assoc :path data))
                              (write-to-string (+ i 1))))
      (setf pagination (gen-pagination-for-archive (+ i 1) times))
      (when (= i (- times 1))
        (write-file (mustache:render* template
                                      `((:slug . ,slug)
                                        ,css
                                        ,@pagination
                                        (:posts . ,(subseq
                                                    posts
                                                    (* i limit)))))
                    page))
      (when (< i (- times 1))
        (write-file (mustache:render* template
                                      `((:slug . ,slug)
                                        ,css
                                        ,@pagination
                                        (:posts . ,(subseq
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

(defun split-string (string sep)
  "Wrapper around uiop:split-string to avoid keyword typing."
  (uiop:split-string string :separator sep))

(defun file-basename (path)
  "Return the file name without extension for PATH."
  (car (uiop:split-string (file-namestring path) :separator ".")))

(defun gen-pages ()
  "Generate any markdown files in the pages/ dir using matching JSON files as context."
  (let ((pages (uiop:directory-files "pages/" "*.md"))
        (css `(:css . ,css))
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
        (write-file (mustache:render* template `((:slug . ,(cdr (assoc :permalink data)))
                                                  ,css
                                                  ,@data
                                                  (:content . ,content)))
                    (concatenate 'string "site/" (cdr (assoc :permalink data)) ".html")))))

(defun return-leading-zero-as-string (number)
  (if (< number 10)
    (concatenate 'string "0" (write-to-string number))
    (write-to-string number)))

(defun now-as-rfc-822 ()
  (multiple-value-bind (second minute hour day month year day-name dst-p tz)
    (get-decoded-time)
  (setf day (return-leading-zero-as-string day))
  (setf minute (return-leading-zero-as-string minute))
  (setf second (return-leading-zero-as-string second))
  (if (eq month 0)
      (setf month month)
    (setf month (- month 1)))
  (concatenate 'string
                      (nth day-name days)
                      ", "
                      day
                      " "
                      (nth month months)
                      " "
                      (write-to-string year)
                      " "
                      (write-to-string hour)
                      ":"
                      minute
                      ":"
                      second
                      " "
                      (cdr (assoc tz us-time-zone-codes)))))

(defun format-data-for-rss(post)
  (let ((slug (cdr (assoc :slug post))))
    `((:title . ,(cdr (assoc :title post)))
      (:slug . ,slug)
      (:excerpt . ,(cdr (assoc :excerpt post)))
      (:content . ,(post-for-slug slug))
      (:date . ,(cdr (assoc :published post))))))

(defun gen-rss ()
  (let* ((posts (subseq posts 0 20))
         (now (now-as-rfc-822))
         (template (uiop:read-file-string "templates/rss.mustache"))
         (proper-posts (mapcar 'format-data-for-rss posts)))
    (ensure-directories-exist "site/")
    (write-file (mustache:render* template `((:now . ,now) (:posts . ,proper-posts))) "site/feed.xml")))

(gen-rss)

(defun gen-sitemap ())

(defun main ()
  "The pipeline to build the site."
  (setf posts (gen-data))
  (copy-public)
  (gen-archive)
  (gen-pages)
  (gen-posts)
  (gen-rss)
  (gen-sitemap))
