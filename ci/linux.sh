#!/bin/sh

sudo apt update -qy;
sudo apt install -qy curl zlib1g-dev sbcl build-essential git;
git clone --depth 1 -b sbcl-2.0.7 git://git.code.sf.net/p/sbcl/sbcl /tmp/sbcl;
cd /tmp/sbcl || exit;
sh make.sh --with-sb-core-compression;
sudo sh install.sh;
sudo apt remove -yq sbcl;
