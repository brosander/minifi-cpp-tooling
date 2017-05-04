#!/bin/sh

set -e

COMMAND="cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo /source/nifi-minifi-cpp && make && make test && make package"
PR=""
BRANCH=""
REPOSITORY="https://github.com/apache/nifi-minifi-cpp.git"

printUsageAndExit() {
  echo "usage: docker run -ti [--rm] IMAGE_NAME [-r REPOSITORY] [-b BRANCH] [-p PR_NUMBER] [-c COMMAND_LINE]"
  echo "       -h or --help          print this message and exit"
  echo "       -r or --repository    repository (default: $REPOSITORY)"
  echo "       -b or --branch        branch to build"
  echo "       -p or --pr            pr number to build"
  echo "       -c or --commandLine   command line to execute (default: \"$COMMAND\")"
  exit 1
}

# see https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash/14203146#14203146
while [[ $# -ge 1 ]]; do
  key="$1"
  case $key in
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
    -c|--commandLine)
    COMMAND="$2"
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

if [ ! -e "/source/nifi-minifi-cpp" ]; then
  mkdir /source/nifi-minifi-cpp
  cd /source/nifi-minifi-cpp
  git init
  git config user.name "minifi-cpp-tooling"
  git config user.email minifi-cpp-tooling@github.com
  touch .gitignore
  git add .gitignore
  git commit -m "tmp"
  git checkout -b temporary-branch-that-shouldnt-exist
  git branch -D master
  git remote add origin "$REPOSITORY"
  if [ -n "$BRANCH" ]; then
    git fetch origin "$BRANCH:$BRANCH" && git checkout "$BRANCH"
    if [ -n "$PR" ]; then
      git pull origin pull/"$PR"/head
    fi
  elif [ -n "$PR" ]; then
    git fetch origin pull/"$PR"/head:pr"$PR" && git checkout pr"$PR"
  fi
fi

cd /build

sh -c "$COMMAND"
