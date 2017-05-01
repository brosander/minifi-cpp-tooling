#!/bin/bash

set -e

mkdir ~/nifi-minifi-cpp
cd ~/nifi-minifi-cpp
git init
git remote add origin https://github.com/apache/nifi-minifi-cpp.git
git fetch origin pull/"$1"/head:pr"$1" && git checkout pr"$1"
cd /build
cmake /home/minifi/nifi-minifi-cpp
make
make test
make package
