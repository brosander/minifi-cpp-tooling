This is a set of Dockerfiles and scripts intended to make building and testing Apache MiNiFi C++ easier.
------------------------------------------------------------------------------------------
Create image
```
minifi-cpp-tooling/Dockerfiles$ ./create-image.sh -h
usage: docker run -ti [--rm] IMAGE_NAME [-r REPOSITORY] [-b BRANCH] [-p PR_NUMBER] [-c COMMAND_LINE]
       -h or --help          print this message and exit
       -o or --os            operating system to build for (must have a build and run dockerfile in this directory) (default: ubuntu-xenial)
       -t or --tarArchive    tar archive to build and package (will clone repo if not specified)
       -r or --repository    repository (default: https://github.com/apache/nifi-minifi-cpp.git)
       -b or --branch        branch to build
       -p or --pr            pr number to build
       -c or --commandLine   command line to execute (default: "(cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo /source/nifi-minifi-cpp && make && make test && make package) || bash")
```

Example:
```
./create-image.sh -t ~/Downloads/nifi-minifi-cpp-0.2.0-source.tar.gz -o centos-7
docker run -ti --rm minifi-cpp-centos-7:0.2.0
```
