FROM ubuntu:22.04

SHELL ["/bin/bash", "-c"]

# install many dependencies and convenience packages with the apt package manager
RUN apt update && apt upgrade -y && apt install -y \
    build-essential clang cmake git x11-apps\
    cmake-curses-gui cmake-qt-gui \
    dotnet-sdk-7.0 \
    wget apt-utils curl \
    nano vim tmux \
    libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev \
    libboost-all-dev \
    libtbb-dev \
    libssl-dev \
    libzmq3-dev \
    libjemalloc-dev \
    doxygen \
    pkg-config \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    && rm -rf /var/lib/apt/lists/*

# switch to home dir
WORKDIR /root

# install c-blosc from source
RUN git clone https://github.com/Blosc/c-blosc.git
RUN cd c-blosc && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX='/usr/local' .. && \
    cmake --build . && \
    cmake --build . --target install

# install cmake from binary, bc apt version is too low to compile PicoGKRuntime
RUN wget https://github.com/Kitware/CMake/releases/download/v3.27.7/cmake-3.27.7-linux-x86_64.tar.gz
RUN tar -xzvf cmake-3.27.7-linux-x86_64.tar.gz && \
    mv cmake-3.27.7-linux-x86_64 /opt/cmake-3.27.7 && \
    ln -s /opt/cmake-3.27.7/bin/cmake /usr/local/bin/cmake && \
    rm cmake-3.27.7-linux-x86_64.tar.gz

SHELL ["/bin/bash", "-l", "-c"]

# copy the entrypoint into the image
COPY ./entrypoint.sh /entrypoint.sh
# run this script on startup
ENTRYPOINT /entrypoint.sh