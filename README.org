* Cycle
A static site generator written in Common Lisp that works for me and probably no one else.
* Compile binary

~sbcl --load "cycle.asd" --eval "(ql:quickload :cycle)" --eval "(sb-ext:save-lisp-and-die \"cycle\" :toplevel 'cycle:main :executable t :compression 9)"~

~ecl --load "cycle.asd" --eval "(ql:quickload :cycle)" --eval "(asdf:make-build :cycle :type :program :prologue-code '(setf compiler:*compile-verbose* nil) :move-here \"./\")"~
