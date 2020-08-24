#!/bin/sh

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
    sudo apt update -qy;
    sudo apt install -qy curl zlib1g-dev sbcl build-essential git;
    git clone --depth 1 -b sbcl-2.0.7 git://git.code.sf.net/p/sbcl/sbcl /tmp/sbcl;
    cd /tmp/sbcl || exit;
    sh make.sh --with-sb-core-compression;
    sudo sh install.sh;
    sudo apt remove sbcl;
fi

if [ "$TRAVIS_OS_NAME" = "osx" ]; then
    brew update;
    brew install sbcl;
fi

curl -O "https://beta.quicklisp.org/quicklisp.lisp";
/usr/local/bin/sbcl --non-interactive --load quicklisp.lisp --eval "(quicklisp-quickstart:install :path \"~/quicklisp\")";
/usr/local/bin/sbcl --non-interactive --load ~/quicklisp/setup.lisp --eval "(ql::without-prompting (ql:add-to-init-file))";
