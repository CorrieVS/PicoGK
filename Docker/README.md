# Develop PicoGK in a Docker container

Developer's preferring Linux can use a Docker container development environment based on Ubuntu 22.04.
The tools include a Dockerfile and associated docker-compose.yaml for easy container configuration; a set of
bash utilities to simplify command line actions; and a Visual Studio Code devcontainer description to streamline .NET development and provide C# extensions in the container.

The container has these features:
- Ubuntu 22.04 with .NET 7.0
- Volume for persistent storage: `/root/picogk`
- Assigns volume ownership to the host user
- Symlinks volume to `/home/$USER/picogk` in the container so you can work as yourself

## Requirements
- [Docker Engine with docker compose](https://docs.docker.com/engine/install/ubuntu/)
- [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html), for NVIDIA graphics computers

## Setup Directory Structure and Load the Bash Utilities

To begin, create a top level directory called `picogk` to contain this repo, and optionally the [PicoGKRuntime](https://github.com/leap71/PicoGKRuntime) repo if you want to compile it from source.  The runtime library is precompiled and available within this repo in `Runtime/linux_x64/`.  If you do prefer to compile the runtime yourself, follow the instuctions in [Compile Runtime in Docker](CompileRuntimeInDocker.md).

Assuming you have already cloned this PicoGK repo, navigate to a directory above it and do:
```
mkdir picogk
mv PicoGK picogk/
cd picogk
```

In a bash shell, source the bash utilities for convenience commands.  You can add this line (with the path fully defined) to the end of your `~/.bashrc` to source the utils automatically when you open a bash shell:
```
source PicoGK/Docker/bash-utils
```

Set the directory variable - this allows you to run the bash_utils commands from anywhere on the host.
```
pico-dir `pwd`
```
or add it to your ~/.bashrc or ~/.profile for convenience 
```
nano ~/.bashrc
export PICOGK_DIRECTORY=/absolute/path/to/picogk
```

## Build the Docker Image and Run the Container

Build the docker image with
```
pico-build
```

Run the container and open a shell inside it
```
pico-start
pico-shell
```

When you need to stop the container
```
exit
pico-stop
```

| Command | Function |
| --- | --- |
| `pico-build` | build the container from docker files |
| `pico-start` | gather host user info, apply ownership of the `picogk` volume to host user, start container in detached mode |
| `pico-stop` | stop container and remove it |
| `pico-shell` | open a bash shell in the container |
| ` pico-log` | view the docker container log |
| `pico-dir` | export the PICOGK_DIRECTORY env variable, usage: `pico-dir <path>` |


## Open Your Code in the Container in Visual Studio Code

You can develop in Visual Studio Code on the host by simply opening your project and a terminal, then doing `pico-start` and `pico-shell` in the terminal.

However, some users may want to develop in VSC and use the C# Dev Kit extensions.  To do this, you can open the code inside the running container.  Setup this capability by opening the `picogk` directory in Visual Studio Code and copying the `PicoGK/.devcontainer` directory to it, or do it in bash:

```
cp -r PicoGK/.devcontainer ./
code .
```

Then type "F1" to activate the command bar in Visual Studio Code, and type **"Dev Containers: Reopen in Container"**.  You should see "`picogk_c`" in the drop down - select it if it is not automatically selected.  VSC will reopen the folder, load the C# Dev Kit extension, and open a terminal window in the container.

## Create a C# .NET Application

To create a .NET project in the container, click your cursor in the VSC terminal and navigate to `picogk/projects`.  Create a new console app, build and run it to ensure your setup is funtioning - the program will print "Hello World!" to the console.

```
dotnet new console -n HelloWorld
cd HelloWorld
dotnet build
dotnet run
```

Now you can continue with [Getting Started](../Documentation/README.md#your-first-picogk-app).  Be sure to edit the `PicoGK/PicoGK__Config.cs` to set `strPicoGKLib` to  `"library /usr/local/lib/picogk.1.0.so"`.  The app does not consume the linux shared library `.so` extension properly without the full path.

## Docker options in docker-compose.yaml

Parameters for Docker are set in `PicoGK/Docker/docker-compose.yaml`.

These are set by default to use NVIDIA runtime. Comment them out to not use it:
```
runtime: nvidia
environment:
    - NVIDIA_DRIVER_CAPABILITIES=all
    - NVIDIA_VISIBLE_DEVICES=all
```

