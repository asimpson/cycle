;;;; cycle-dev.lisp
(require "asdf")

(in-package :cycle-dev)

(defvar *db* (sqlite:connect "BLOG"))

(defun gen-md ()
  "One-off command to turn html files into md files via pandco process."
  (let* ((files (uiop:directory-files "posts/" "*.html"))
         (formatted (mapcar (lambda(file) `(,file . ,(cycle:file-basename file))) files)))
    (dolist (file formatted)
      (uiop:launch-program (concatenate 'string "/usr/local/bin/pandoc "
                                        (uiop:unix-namestring (car file))
                                        " -t gfm --wrap=none -o posts/"
                                        (cdr file)
                                        ".md")))))

(defun write-posts-to-file ()
  "This grabs the raw data out of the db and writes it to HTML files."
  (let ((posts (sqlite:execute-to-list *db* "select id,slug,title,pub_date,mod_date,excerpt,content from posts")))
    (dolist (post posts)
      (cycle:write-file (car (last post)) (concatenate 'string "posts/" (second post) ".html")))))


(defun write-data-to-file()
  (let ((posts (sqlite:execute-to-list *db* "select id,slug,title,pub_date,mod_date,excerpt from posts")))
    (dolist (post posts)
      (cycle:write-file (data-to-json post) (concatenate 'string "posts/" (second post) ".json")))))

(defun data-to-json(post)
  (let ((json (json:encode-json-to-string `(
                                            ("id" . ,(first post))
                                            ("slug" . ,(second post))
                                            ("title" . ,(third post))
                                            ("published" . ,(coerce-tz (fourth post)))
                                            ("modified" . ,(coerce-tz (fifth post)))
                                            ("excerpt" . ,(string-trim " " (sixth post)))))))
    json))

(defun coerce-tz(date)
  (let* ((no-zone (substitute #\T #\Space date))
         (digit (parse-integer (car (cycle:split-string (car (cdr (cycle:split-string date " "))) ":"))))
         (parsed-hour (local-time:timestamp-hour (local-time:parse-timestring (concatenate 'string no-zone "-04:00")))))
    (if (eq parsed-hour digit)
        (concatenate 'string no-zone "-04:00")
      (concatenate 'string no-zone "-05:00"))))

(write-data-to-file)
