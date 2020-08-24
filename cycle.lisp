;;;; cycle.lisp
(require "asdf")

(defpackage :cycle
;;https://lisp-lang.org/style-guide/#one-package-per-file
  (:use :cl)
  (:export
    :main
    :write-file
    :split-string
    :file-basename))

(in-package :cycle)

(defvar posts nil "Global posts variable.")
(defvar css nil
  "CSS for the site.")

(opts:define-opts
  (:name :help
   :description "`generate` is the only available command at the moment."
   :short #\h
   :long "help"))

(defun concat (&rest strings)
  "Wrapper around the more cumbersome concatenate form."
  (let (result)
    (dolist (x strings)
      (setf result (concatenate 'string result x)))
    result))

(defun shell (cmd)
  "Return the output of CMD as a string."
  (multiple-value-bind (result)
      (uiop:run-program cmd :output '(:string :stripped t))
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
  "Create list that contains the data from each JSON file combined with the body of every post."
  (let* ((json (uiop:read-file-string (car (cdr post))))
         (list-json (json:decode-json-from-string json)))
    `(,@list-json
      (:published_pretty . ,(pretty-date (cdr (assoc :published list-json))))
      (:modified_pretty . ,(pretty-date (cdr (assoc :modified list-json))))
      (:content . ,(post-for-slug (cdr (assoc :slug list-json)))))))

(defun pretty-date (date)
  "Returns a pretty date given a date from a JSON file."
  (local-time:format-timestring nil
                                (local-time:parse-timestring date)
                                :format '(:LONG-MONTH " " :DAY ", " :YEAR)))

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
  (if (uiop:file-exists-p "templates/post.mustache")
      (let ((template (uiop:read-file-string "templates/post.mustache"))
            post
            rendered)
        (dolist (pair posts)
          (setf post `((:content . ,(cdr (assoc :content pair)))
                       (:pub_date . ,(cdr (assoc :published pair)))
                       (:mod_date . ,(cdr (assoc :modified pair)))
                       (:modifiedDate . ,(pretty-date (cdr (assoc :modified pair))))
                       (:formattedDate . ,(pretty-date (cdr (assoc :published pair))))
                       (:link . ,(cdr (assoc :link pair)))
                       (:description . ,(cdr (assoc :excerpt pair)))
                       (:slug . ,(concat "/writing/"
                                         (cdr (assoc :slug pair))))
                       (:css . ,css)
                       (:title . ,(cdr (assoc :title pair)))))

          (setf rendered (mustache:render* template post))
          (write-file rendered (concat
                                "site/writing/"
                                (cdr (assoc :slug pair))
                                ".html"))))
      (print "No post.mustache template found. Create it in templates/.")))

(defun gen-archive ()
  "Create archive type pages."
  (if (and (uiop:file-exists-p "pages/archive.mustache")
           (uiop:file-exists-p "pages/archive.json"))
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
                        (concat path ".html"))))
      (print "The files for generating an archive are missing. Create a archive.mustache file and a archive.json file in pages/.")))

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
  (if (uiop:file-exists-p "templates/index.mustache")
      (let* ((template (uiop:read-file-string "templates/index.mustache"))
             (posts (subseq posts 0 10))
             (rendered (mustache:render* template `((:posts . ,posts) (:css . ,css)))))
        (write-file rendered "site/index.html"))
      (print "No index.mustache file found. Create a mustache file named index.mustache in templates/.")))

(defun gen-pages ()
  "Generate any markdown files in the pages/ dir using matching JSON files as context."
  (if (uiop:file-exists-p "templates/page.mustache")
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
                      (concat "site/" (cdr (assoc :permalink data)) ".html"))))
      (print "No page.mustache file found. Please create one in templates/.")))

(defun return-leading-zero-as-string (number)
  (if (< number 10)
      (concat "0" (write-to-string number))
      (write-to-string number)))

(defun now-as-rfc-822 ()
  (date-as-rfc-822 (local-time:format-timestring nil (local-time:now))))

(defun date-as-rfc-822 (date)
  (local-time:format-timestring nil
                                (local-time:parse-timestring date)
                                :format '(:short-weekday ", " :day " " :short-month " " :year " " (:hour 2) ":" (:min 2) ":" (:sec 2) " " :gmt-offset-hhmm)))

(defun format-data-for-rss(post)
  (let ((slug (cdr (assoc :slug post))))
    `((:title . ,(cdr (assoc :title post)))
      (:slug . ,slug)
      (:excerpt . ,(cdr (assoc :excerpt post)))
      (:link . ,(cdr (assoc :link post)))
      (:content . ,(cdr (assoc :content post)))
      (:date . ,(date-as-rfc-822 (cdr (assoc :published post)))))))

(defun gen-rss ()
  (if (uiop:file-exists-p "templates/rss.mustache")
      (let* ((posts (subseq posts 0 20))
             (now (now-as-rfc-822))
             (template (uiop:read-file-string "templates/rss.mustache"))
             (proper-posts (mapcar 'format-data-for-rss posts)))
        (write-file (mustache:render* template `((:now . ,now) (:posts . ,proper-posts))) "site/rss.xml"))
      (print "No rss template found. Please create one in templates/.")))

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
  (if (uiop:file-exists-p "templates/sitemap.mustache")
      (let ((proper-posts (mapcar 'format-data-for-sitemap posts))
            (pages (get-page-slugs))
            (template (uiop:read-file-string "templates/sitemap.mustache")))
        (write-file (mustache:render*
                     template
                     `((:posts . ,proper-posts) (:pages . ,pages)))
                    "site/sitemap.xml"))
      (print "No sitemap.mustache template found. Please create one in templates/.")))

(defun get-id()
  "Get all JSON files representing all posts and return the next ID to use."
  (let ((files (uiop:directory-files "posts/" "*.json")))
    (if files
        (+ 1
           (car (sort
                 (mapcar
                  (lambda (file)
                    (cdr (assoc :id (json:decode-json-from-string
                                     (uiop:read-file-string file)))))
                  files)
                 #'>)))
        1)))

(defun generate-post (title)
  "Take TITLE and create the necessary JSON and MD files for it."
  (let* ((date (shell "date +%Y-%m-%dT%R:%S%:z"))
        (slug (cl-ppcre:regex-replace-all ","
                                          (cl-ppcre:regex-replace-all " " (string-downcase title) "-")
                                          ""))
        (id (get-id))
        (json-file (concat "./posts/" slug ".json"))
        (md-file (concat "./posts/" slug ".md")))
    (write-file (json:encode-json-to-string `(("id" . ,id)
                                              ("published" . ,date)
                                              ("title" . ,title)
                                              ("slug" . ,title)
                                              ("modified" . ,date)
                                              ("excerpt" . "")))
                json-file)
    (write-file title md-file)))

(defun main ()
  "The pipeline to build the site."

  (if (equal (car (cdr (opts:argv))) "generate")
      (generate-post (car (last (opts:argv))))
      (progn
        (ensure-directories-exist "site/writing/")
        (when (uiop:subdirectories "./templates")
          (setf mustache:*load-path* `(,(namestring (car (uiop:subdirectories "./templates"))))))
        (when (uiop:file-exists-p "site.css")
          (setf css (uiop:read-file-string "site.css")))
        (setf mustache:*default-pathname-type* "mustache")
        (setf 3bmd-code-blocks:*code-blocks* t)
        (setf posts (reverse (sort (gen-data)
                                   'sort-by-ids
                                   :key 'car)))

        (multiple-value-bind (options free-args)
            (opts:get-opts)
          (when options
            (opts:describe)))

        (if (and css posts)
            (progn
              (copy-public)
              (gen-archive)
              (gen-index)
              (gen-pages)
              (gen-posts)
              (gen-rss)
              (gen-sitemap))
            (print "No posts found. Create a md file in posts/. Also create a site.css file in the root.")))))
