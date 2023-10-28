# Compile the PickGKRuntime from Source in Docker

While the pre-compiled PicoGKRuntime library is included in `PicoGK/Runtime/linux`, you may want to develop and compile it from source.  Follow these steps.

### Setup your Docker container

Follow the [Docker Setup Instructions](README.md) up to and including [Build the Docker Image and Run the Container](README.md#build-the-docker-image-and-run-the-container).

Then, open a bash shell on the host and clone the repository.  You will need the "patch" branch:
```
cd picogk
git clone --recursive https://github.com/CorrieVS/PicoGKRuntime.git
cd PicoGKRuntime && git checkout patch
```
### Configure and Build the Runtime

Create a Build directory, open a container, and navigate to it:
```
mkdir Build
pico-start    # if a container is not already running
pico-shell    # to open a shell inside it
cd PicoGKRuntime/Build
```
Configure with cmake, choosing Clang as the compiler:
```
cmake .. -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_CXX_FLAGS=-fPIC
```
Build the source code:
```
make
```

### Copy the Generated Library

Copy the generated shared libaray file to somewhere useful, like `usr/local/lib` in the container:
```
cp lib/picogk.1.0.so /usr/local/lib
```

Be sure to update `PicoGK/PicoGK__Config.cs` to point to the fully defined path of your library, such as `usr/local/lib/picogk.1.0.so`.  The app does not find the library without the full path because it does not appear to consume the `.so` extension correctly using the default config.
