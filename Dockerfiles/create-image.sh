#!/bin/bash

set -e

PR=""
BRANCH=""
REPOSITORY="https://github.com/apache/nifi-minifi-cpp.git"
TAR_ARCHIVE=""
OS="ubuntu-xenial"

printUsageAndExit() {
  echo "usage: $0 [-h] [-o OS] [-t TAR_ARCHIVE] [-r REPOSITORY] [-b BRANCH] [-p PR]"
  echo "       -h or --help          print this message and exit"
  echo "       -o or --os            operating system to build for (must have a build and run dockerfile in this directory) (default: $OS)"
  echo "       -t or --tarArchive    tar archive to build and package (will clone repo if not specified)"
  echo "       -r or --repository    repository (default: $REPOSITORY)"
  echo "       -b or --branch        branch to build"
  echo "       -p or --pr            pr number to build"
  exit 1
}

# see https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash/14203146#14203146
while [[ $# -ge 1 ]]; do
  key="$1"
  case $key in
    -o|--os)
    OS="$2"
    shift
    ;;
    -t|--tarArchive)
    TAR_ARCHIVE="$2"
    shift
    ;;
    -r|--repository)
    REPOSITORY="$2"
    shift
    ;;
    -b|--branch)
    BRANCH="$2"
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

ORIG_DIR="$(pwd)"
if [ ! -e "$ORIG_DIR/create-image.sh" ]; then
  echo "Must run from this script's directory"
  exit 1
fi

if [ -e "build-$OS" ]; then
  rm -rf "build-$OS"
fi
SOURCE_DIR="$ORIG_DIR/build-$OS/source"
OUTPUT_DIR="$ORIG_DIR/build-$OS/build"
mkdir -p "$SOURCE_DIR"
mkdir -p "$OUTPUT_DIR"

cd "$SOURCE_DIR"
if [ -n "$TAR_ARCHIVE" ]; then
  VERSION="$(echo "$(basename "$TAR_ARCHIVE")" | sed 's/.*-\([0-9.]\+\)-.*/\1/g')"
  tar -zxvf "$TAR_ARCHIVE"
  cd "$(find ./ -type d -name libminifi)/.."
  MINIFI_DIR="$(pwd)"
  cd "$SOURCE_DIR"
  mv "$MINIFI_DIR" ./nifi-minifi-cpp
else
  mkdir nifi-minifi-cpp
  cd nifi-minifi-cpp
  git init
  git config user.name "minifi-cpp-tooling"
  git config user.email minifi-cpp-tooling@github.com
  touch .gitignore
  git add .gitignore
  git commit -m "tmp"
  git checkout -b temporary-branch-that-shouldnt-exist
  git branch -D master
  git remote add origin "$REPOSITORY"
  if [ -n "$PR" ]; then
    VERSION="pr$PR"
    git fetch origin pull/"$PR"/head:pr"$PR" && git checkout pr"$PR"
  else
    if [ -z "$BRANCH" ]; then
      BRANCH=master
    fi
    VERSION="$BRANCH"
    git fetch origin "$BRANCH:$BRANCH" && git checkout "$BRANCH"
    if [ -n "$PR" ]; then
      git pull origin pull/"$PR"/head
    fi
  fi
fi

cd "$ORIG_DIR"

docker build --file "Dockerfile-${OS}-build" -t "minifi-cpp-${OS}-build" .

docker run -ti --rm -v "$SOURCE_DIR:/source" -v "$OUTPUT_DIR:/build" "minifi-cpp-${OS}-build"

docker build --file "Dockerfile-${OS}-run" \
                 -t "minifi-cpp-${OS}:$VERSION" \
             --build-arg MINIFI_VERSION="$VERSION" \
             --build-arg MINIFI_BINARY="$(find "./build-${OS}/build" -maxdepth 1 -type f -name 'nifi-minifi-cpp-*.tar.gz')" \
             .

rm -rf "build-$OS"
