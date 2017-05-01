To build PR:
Build image (one time)
```
docker build -t minifi-cpp-xenial-build .
```
Make an output directory
```
mkdir build
```
Run image with pr number
```
docker run -ti --rm -v "$(pwd)/build:/build" minifi-cpp-xenial-build PR_NUMBER
```
