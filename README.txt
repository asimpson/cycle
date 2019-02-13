* AoE
A static site generator written in Common Lisp that works for me and probably no one else.
* Compile binary

~sbcl --load "sbcl-blog.asd" --eval "(ql:quickload :sbcl-blog)" --eval "(sb-ext:save-lisp-and-die \"foo\" :toplevel 'sbcl-blog:main :executable t :compression 9)"~

~ecl --load "sbcl-blog.asd" --eval "(ql:quickload :sbcl-blog)" --eval "(asdf:make-build :sbcl-blog :type :program :prologue-code '(setf compiler:*compile-verbose* nil) :move-here \"./\")"~
