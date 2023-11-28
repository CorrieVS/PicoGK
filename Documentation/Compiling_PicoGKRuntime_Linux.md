# Compile the PickGKRuntime from Source in Ubuntu

While the pre-compiled PicoGKRuntime library is included in `PicoGK/Runtime/linux_x64`, you may want to develop and compile it from source.  Compiling has been tested sucessfully on Ubuntu 22.04.  Follow these steps.

If you haven't already, clone the [PicoGKRuntime](https://github.com/CorrieVS/PicoGKRuntime) repo recursively
```
git clone --recursive https://github.com/CorrieVS/PicoGKRuntime.git
```

### Install the PicoGK Dependencies

If you haven't already, install the dependencies using the linux installer
```
cd PicoGKRuntime
./Install_Dependencies/linux_x64.sh
```

### Configure and Build the Runtime

Create a Build directory and navigate to it:
```
mkdir PicoGKRuntime/Build
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
cp lib/picogk.1.1.so /usr/local/lib
```

Be sure to update `PicoGK/PicoGK__Config.cs` to point to the fully defined path of your library, such as `usr/local/lib/picogk.1.1.so`.  The app does not find the library without the full path because it does not appear to consume the `.so` extension correctly using the default config.