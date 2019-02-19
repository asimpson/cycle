;;;; cycle.lisp
(require "asdf")

(in-package :cycle)

(defvar posts nil "Global posts variable.")
(defvar css nil
  "CSS for the site.")
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

(defun concat (&rest strings)
  "Wrapper around the more cumbersome concatenate form."
  (let (result)
    (dolist (x strings)
      (setf result (concatenate 'string result x)))
    result))

(defun gen-data ()
  "Read markdown posts from 'posts' dir and retrieve data from each matching json file."
  (let* ((posts (uiop:directory-files "posts/" "*.md"))
         (struct (mapcar
                  (lambda (post)
                    (list post (car (uiop:directory-files "posts/" (concat (file-basename post)
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
    (dolist (file files)
      (multiple-value-bind (key parts name) (uiop/pathname:split-unix-namestring-directory-components (namestring file))
        (uiop:copy-file file (concat (full-path-as-string "site/")
                                     (return-public-child-dir parts)
                                     name))))))

(defun return-public-child-dir (dir)
  (let ((folder (concat (car (last dir)) "/")))
    (unless (equal folder "public/")
      (unless (uiop/filesystem:directory-exists-p (concat "site/" folder))
        (ensure-directories-exist (concat (full-path-as-string "site/") folder)))
      folder)))

(defun parse-date (date)
  (let ((month (local-time:format-timestring nil (local-time:parse-timestring date) :format '(:month)))
        (year (local-time:format-timestring nil (local-time:parse-timestring date) :format '(:year)))
        (day (local-time:format-timestring nil (local-time:parse-timestring date) :format '(:day))))
    (concat year "-" month "-" day)))

(defun write-file (contents file)
  "Write CONTENTS to FILE."
  (with-open-file (stream file
                     :direction :output
                     :if-exists :supersede)
    (write-sequence contents stream)))

(defun post-for-slug (slug)
  (with-output-to-string (p)
    (3bmd:parse-string-and-print-to-stream
     (uiop:read-file-string (concat
                             "posts/"
                             slug
                             ".md"))
     p)))

(defun gen-posts ()
  "Generate posts from post data, templates, and css file(s)."
  (let ((template (uiop:read-file-string "templates/post.mustache"))
        post
        rendered)
    (dolist (pair posts)
      (setf post (post-for-slug (cdr (assoc :slug pair))))
      (setf rendered (mustache:render* template `((:content . ,post)
                                                  (:pub_date . ,(cdr (assoc :published pair)))
                                                  (:mod_date . ,(cdr (assoc :modified pair)))
                                                  (:modifiedDate . ,(parse-date (cdr (assoc :modified pair))))
                                                  (:formattedDate . ,(parse-date (cdr (assoc :published pair))))
                                                  (:link . ,(cdr (assoc :slug pair)))
                                                  (:description . ,(cdr (assoc :excerpt pair)))
                                                  (:slug . ,(concat "/writing/"
                                                                    (cdr (assoc :slug pair))))
                                                  (:css . ,css)
                                                  (:title . ,(cdr (assoc :title pair))))))
      (write-file rendered (concat
                            "site/writing/"
                            (cdr (assoc :slug pair))
                            ".html")))))

(defun gen-archive ()
  "Create archive type pages."
  (let* ((template (uiop:read-file-string "pages/archive.mustache"))
         (data (json:decode-json-from-string (uiop:read-file-string "pages/archive.json")))
         (css `(:css . ,css))
         (limit (cdr (assoc :paginate data)))
         (path (concat "site" (cdr (assoc :path data))))
         page
         times
         pagination)
    (ensure-directories-exist path)
    (if (> limit 0)
        (progn
          (setf times (+ (floor (length posts) limit) 1))
          (dotimes (i times)
            (setf page (concat path
                              (write-to-string (+ 1 i))
                              ".html"))
            (setf pagination (gen-pagination-for-archive (+ i 1) times))
            (when (= i (- times 1))
              (write-file (mustache:render* template
                                            `(,css
                                              ,@pagination
                                              (:posts . ,(subseq
                                                          posts
                                                          (* i limit)))))
                          page))
            (when (< i (- times 1))
              (write-file (mustache:render* template
                                            `(,css
                                              ,@pagination
                                              (:posts . ,(subseq
                                                          posts
                                                          (* i limit)
                                                          (+ (* i limit) limit)))))
                          page))))
      (write-file (mustache:render* template
                                        `(,css
                                          (:posts . ,posts)))
                  (concat path ".html")))))

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

(defun gen-index()
  (let* ((template (uiop:read-file-string "templates/index.mustache"))
         (posts (subseq posts 0 10))
         (rendered (mustache:render* template `((:posts . ,posts) (:css . ,css)))))
    (write-file rendered "site/index.html")))

(defun gen-pages ()
  "Generate any markdown files in the pages/ dir using matching JSON files as context."
  (let ((pages (uiop:directory-files "pages/" "*.md"))
        (css `(:css . ,css))
        (template (uiop:read-file-string "templates/page.mustache"))
        data
        content)
    (dolist (page pages)
      (setf data (json:decode-json-from-string (uiop:read-file-string
                                                (concat "pages/"
                                                        (file-basename page)
                                                        ".json"))))
      (setf content (with-output-to-string (p)
                      (3bmd:parse-string-and-print-to-stream (uiop:read-file-string page) p)))
      (ensure-directories-exist (concat "site/" (cdr (assoc :permalink data))))
      (write-file (mustache:render* template `((:slug . ,(cdr (assoc :permalink data)))
                                               ,css
                                               ,@data
                                               (:content . ,content)))
                  (concat "site/" (cdr (assoc :permalink data)) ".html")))))

(defun return-leading-zero-as-string (number)
  (if (< number 10)
      (concat "0" (write-to-string number))
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
    (concat (nth day-name days)
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

(defun date-as-rfc-822 (date)
  (let ((year (local-time:format-timestring nil (local-time:parse-timestring date) :format '(:year)))
        (month (local-time:format-timestring nil
                                             (local-time:parse-timestring date)
                                             :format '(:short-month)))
        (day (local-time:format-timestring nil
                                           (local-time:parse-timestring date)
                                           :format '(:short-weekday)))
        (date (return-leading-zero-as-string
               (read-from-string
                (local-time:format-timestring nil
                                              (local-time:parse-timestring date)
                                              :format '(:day)))))
        (hour (return-leading-zero-as-string
               (read-from-string
                (local-time:format-timestring nil
                                              (local-time:parse-timestring date)
                                              :format '(:hour)))))
        (minute (return-leading-zero-as-string
                 (read-from-string
                  (local-time:format-timestring nil
                                                (local-time:parse-timestring date)
                                                :format '(:min)))))
        (seconds (return-leading-zero-as-string
                  (read-from-string
                   (local-time:format-timestring nil
                                                 (local-time:parse-timestring date)
                                                 :format '(:sec)))))
        (tz (local-time:format-timestring nil
                                          (local-time:parse-timestring date)
                                          :format '(:timezone))))
    (concat day ", " date " " month " " year " " hour ":" minute ":" seconds " " tz)))

(defun format-data-for-rss(post)
  (let ((slug (cdr (assoc :slug post))))
    `((:title . ,(cdr (assoc :title post)))
      (:slug . ,slug)
      (:excerpt . ,(cdr (assoc :excerpt post)))
      (:content . ,(post-for-slug slug))
      (:date . ,(date-as-rfc-822 (cdr (assoc :published post)))))))

(defun gen-rss ()
  (let* ((posts (subseq posts 0 20))
         (now (now-as-rfc-822))
         (template (uiop:read-file-string "templates/rss.mustache"))
         (proper-posts (mapcar 'format-data-for-rss posts)))
    (write-file (mustache:render* template `((:now . ,now) (:posts . ,proper-posts))) "site/rss.xml")))

(defun format-data-for-sitemap (post)
  `((:slug . ,(cdr (assoc :slug post))) (:date . ,(cdr (assoc :published post)))))

(defun get-page-slugs ()
  (let (json)
    (mapcar (lambda (page)
              (setf json (json:decode-json-from-string (uiop:read-file-string page)))
              `((:slug . ,(cdr (assoc :permalink json)))
                (:date . ,(cdr (assoc :published json)))))
            (uiop:directory-files "pages/" "*.json"))))

(defun gen-sitemap ()
  (let ((proper-posts (mapcar 'format-data-for-sitemap posts))
        (pages (get-page-slugs))
        (template (uiop:read-file-string "templates/sitemap.mustache")))
    (write-file (mustache:render*
                 template
                 `((:posts . ,proper-posts) (:pages . ,pages)))
                "site/sitemap.xml")))

(defun main ()
  "The pipeline to build the site."
  (ensure-directories-exist "site/writing/")
  (when (uiop:directory-exists-p "./templates")
   (setf mustache:*load-path* `(,(namestring (car (uiop:subdirectories "./templates"))))))
  (when (uiop:file-exists-p "site.css")
    (setf css (uiop:read-file-string "site.css")))
  (setf mustache:*default-pathname-type* "mustache")
  (setf 3bmd-code-blocks:*code-blocks* t)
  (setf posts (reverse (sort (gen-data)
                             'sort-by-ids
                             :key 'car)))
  (copy-public)
  (gen-archive)
  (gen-index)
  (gen-pages)
  (gen-posts)
  (gen-rss)
  (gen-sitemap))
