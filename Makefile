cycle:
	sbcl --load "cycle.asd" --eval "(ql:quickload :cycle)" --eval "(sb-ext:save-lisp-and-die \"cycle\" :toplevel 'cycle:main :executable t :compression 9)"

clean:
	rm cycle
.PHONY: cycle

install:
	mv cycle /usr/local/bin/cycle
.PHONY: install
