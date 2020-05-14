cycle:
	sbcl --load "cycle.asd" --eval "(ql:quickload :cycle)" --eval "(sb-ext:save-lisp-and-die \"cycle\" :toplevel 'cycle:main :executable t :compression 9)"

ecl:
	ecl --load "cycle.asd" --eval "(ql:quickload :cycle)" --eval "(asdf:make-build :cycle :type :program :prologue-code '(setf compiler:*compile-verbose* nil) :move-here \"./\")"
.PHONY: ecl

clean:
	rm cycle
.PHONY: cycle

install:
	mv cycle /usr/local/bin/cycle
.PHONY: install
