#!/bin/sh

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
    . ./ci/linux.sh
fi

if [ "$TRAVIS_OS_NAME" = "osx" ]; then
    brew update;
    brew install sbcl;
fi

curl -O "https://beta.quicklisp.org/quicklisp.lisp";
/usr/local/bin/sbcl --non-interactive --load quicklisp.lisp --eval "(quicklisp-quickstart:install :path \"~/quicklisp\")";
/usr/local/bin/sbcl --non-interactive --load ~/quicklisp/setup.lisp --eval "(ql::without-prompting (ql:add-to-init-file))";

# use my fork of 3bmd
git clone --depth 1 "https://github.com/asimpson/3bmd.git" ~/quicklisp/local-projects/3bmd
