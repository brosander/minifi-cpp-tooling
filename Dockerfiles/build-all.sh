#!/bin/bash

find ./ -maxdepth 1 -name 'Dockerfile-*' -type f -print0 | xargs -0 -I {} bash -c "docker build --file \"\$(echo \"\$0\" | sed 's/^\.\///g')\" -t \"\$(echo \"\$0\" |  sed 's/^\.\/Dockerfile/minifi-cpp/g' )\" ." {}
