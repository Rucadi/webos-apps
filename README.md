# LG WEBOS TV Native Apps Build Guide

This guide will help you set up your development environment for building native apps for LG WEBOS TV. You can follow the instructions based on your operating system.

## Table of Contents
- [LG WEBOS TV Native Apps Build Guide](#lg-webos-tv-native-apps-build-guide)
  - [Table of Contents](#table-of-contents)
  - [Installing WSL and Nix on Ubuntu inside WSL](#installing-wsl-and-nix-on-ubuntu-inside-wsl)
    - [Step 1: Install WSL](#step-1-install-wsl)
    - [Step 2: Install Nix in Ubuntu inside WSL](#step-2-install-nix-in-ubuntu-inside-wsl)
  - [Installing Nix in Linux with Flakes and Nix Command Enabled](#installing-nix-in-linux-with-flakes-and-nix-command-enabled)
  - [Using Docker on macOS to Install Ubuntu and Nix](#using-docker-on-macos-to-install-ubuntu-and-nix)
  - [Building the Apps](#building-the-apps)
  - [sm64](#sm64)
    - [Preparation](#preparation)
    - [Building the Project](#building-the-project)
    - [Customizing Patch Options](#customizing-patch-options)
      - [Examples](#examples)

## Installing WSL and Nix on Ubuntu inside WSL

### Step 1: Install WSL
1. Open PowerShell and run:
    ```powershell
    wsl --install
    ```
2. This installed an ubuntu, if it fails, go get WSL from here:  https://aka.ms/wslstorepage


### Step 2: Install Nix in Ubuntu inside WSL
1. Open your Ubuntu terminal and run the following commands:
    ```sh
    sudo apt update
    sudo apt install curl
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
    mkdir -p ~/.config/nix && echo -e "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
    ```
2. Follow the on-screen instructions to complete the installation.


## Installing Nix in Linux with Flakes and Nix Command Enabled

1. Open your terminal.
2. Run the following commands:
    ```sh
    sudo apt update
    sudo apt install curl
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
    mkdir -p ~/.config/nix && echo -e "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
    ```


## Using Docker on macOS to Install Ubuntu and Nix
1. Perform the same steps as in linux but inside an ubuntu container

## Building the Apps

Once your environment is set up, you can build your native apps using Nix. Use the following command to build an app, where `[name_of_app.nix]` is the name of your Nix expression file:

```sh
nix-build [name_of_app.nix]
```

The result will contain a "TV installable file" called `.ipk`.

Example:
```sh
nix-build my_app.nix
```

This will produce an output with the `.ipk` file ready for deployment on LG WEBOS TV.

## sm64

When building sm64, you have 3 patch options:

- **patch_60fps**: Enables 60 FPS mode (default: true)
- **patch_betterCamera**: Enables better camera controls (default: true)
- **patch_noDrawDistance**: Removes draw distance limits (default: false)

### Preparation

Before building the project, ensure you have a copy of your own `baserom.us.z64` placed in the root directory of this project.

### Building the Project

To build the project with the default settings, run:

```sh
nix-build sm64.nix
```

This will produce a `result` folder containing the `.ipk` file, which you can install on your TV using the [webOS Dev Manager](https://github.com/webosbrew/dev-manager-desktop).

### Customizing Patch Options

If you want to customize the patch options, you can pass arguments to the `nix-build` command. For example, to enable or disable specific patches, use the following syntax:

```sh
nix-build sm64.nix --arg [patchname] true/false
```

#### Examples

To enable the `patch_noDrawDistance`, run:

```sh
nix-build sm64.nix --arg patch_noDrawDistance true
```

To disable the `patch_60fps`, run:

```sh
nix-build sm64.nix --arg patch_60fps false
```

After building, you can find the `.ipk` file in the `result` folder, ready for installation on your LG WEBOS TV.
