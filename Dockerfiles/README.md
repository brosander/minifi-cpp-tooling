This is a docker container intended to make building and testing Apache MiNiFi C++ easier.
------------------------------------------------------------------------------------------
Build all images (one time)
```
./build-all.sh
```
```
usage: docker run -ti [--rm] minifi-cpp-xenial-build [-r REPOSITORY] [-b BRANCH] [-p PR_NUMBER] [-c COMMAND_LINE]
       -h or --help          print this message and exit
       -r or --repository    repository (default: https://github.com/apache/nifi-minifi-cpp.git)
       -b or --branch        branch to build
       -p or --pr            pr number to build
       -c or --commandLine   command line to execute (default: "cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo /source/nifi-minifi-cpp && make && make test && make package")
```

To build PR:
Make an output directory
```
mkdir build
```
Run image with pr number
```
docker run -ti --rm -v "$(pwd)/build:/build" minifi-cpp-xenial-build -p PR_NUMBER
```
Run image with branch
```
docker run -ti --rm -v "$(pwd)/build:/build" minifi-cpp-xenial-build -b BRANCH
```
Run image with branch and pr number
```
docker run -ti --rm -v "$(pwd)/build:/build" minifi-cpp-xenial-build -b BRANCH -p PR_NUMBER
```
