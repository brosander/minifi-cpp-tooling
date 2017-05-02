#!/bin/bash

set -e

CMAKE_ARGS=""
PR=""

function printUsageAndExit() {
  echo "usage: $0 [-c CMAKE_ARGS] [-p PR_NUMBER]"
  echo "       -h or --help          print this message and exit"
  echo "       -c or --cmake         cmake arg"
  echo "       -p or --pr            pr number to build"
  exit 1
}

# see https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash/14203146#14203146
while [[ $# -ge 1 ]]; do
  key="$1"
  case $key in
    -c|--cmake)
    CMAKE_ARGS="$CMAKE_ARGS $2"
    shift
    ;;
    -p|--pr)
    PR="$2"
    shift
    ;;
    -h|--help)
    printUsageAndExit
    ;;
    *)
    echo "Unknown option: $key"
    echo
    printUsageAndExit
    ;;
  esac
  shift
done

if [ -z "$PR" ]; then
  bash
else
  mkdir /source/nifi-minifi-cpp
  cd /source/nifi-minifi-cpp
  git init
  git remote add origin https://github.com/apache/nifi-minifi-cpp.git
  git fetch origin pull/"$PR"/head:pr"$PR" && git checkout pr"$PR"
  cd /build
  cmake $CMAKE_ARGS /source/nifi-minifi-cpp
  make
  make test
  make package
fi
