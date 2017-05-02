To build PR:
Build image (one time)
```
docker build -t minifi-cpp-xenial-build .
```
Make an output directory
```
mkdir build
```
Run image with pr number and debug info
```
docker run -ti --rm -v "$(pwd)/build:/build" minifi-cpp-xenial-build -c -DCMAKE_BUILD_TYPE=RelWithDebInfo -p PR_NUMBER
```
