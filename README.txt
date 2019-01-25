This is the stub README.txt for the "sbcl-blog" project.

sbcl --load "sbcl-blog.asd" --eval "(ql:quickload :sbcl-blog)" --eval "(sb-ext:save-lisp-and-die \"foo\" :toplevel 'sbcl-blog:main :executable t)"
