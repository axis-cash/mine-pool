#!/bin/bash

set -e

if [ ! -f "build/env.sh" ]; then
    echo "$0 must be run from the root of the repository."
    exit 2
fi

# Create fake Go workspace if it doesn't exist yet.
workspace="$PWD/build/_workspace"
root="$PWD"
axisdir="$workspace/src/github.com/axis-cash"
if [ ! -L "$axisdir/mine-pool" ]; then
    mkdir -p "$axisdir"
    cd "$axisdir"
    ln -s ../../../../../. mine-pool
    cd "$root"
fi

if [ ! -L "$axisdir/go-axis" ]; then
    mkdir -p "$axisdir"
    cd "$axisdir"
    ln -s ../../../../../../go-axis go-axis
    cd "$root"
fi

if [ ! -L "$axisdir/go-axis-import" ]; then
    mkdir -p "$axisdir"
    cd "$axisdir"
    ln -s ../../../../../../go-axis-import go-axis-import
    cd "$root"
fi

mkdir -p "$root/../go-axis-import/czero/lib"
mkdir -p "$root/czero/lib"


if [ $1 == "linux-v3" ]; then
    cd "$root/../go-axis-import/czero"
    rm -rf lib/*
    cp -rf lib_LINUX_AMD64_V3/* lib
    rm -rf $root/czero/lib/*
    cp -rf lib_LINUX_AMD64_V3/* $root/czero/lib
    shift 1
elif [ $1 == "linux-v4" ];then
    cd "$root/../go-axis-import/czero"
    rm -rf lib/*
    cp -rf lib_LINUX_AMD64_V4/* lib
    rm -rf $root/czero/lib/*
    cp -rf lib_LINUX_AMD64_V4/* $root/czero/lib
    shift 1
elif [ $1 == "darwin-amd64" ];then
    cd "$root/../go-axis-import/czero"
    rm -rf lib/*
    cp -rf lib_DARWIN_AMD64/*  lib
    rm -rf $root/czero/lib/*
    cp -rf lib_DARWIN_AMD64/* $root/czero/lib
    shift 1
elif [ $1 == "windows-amd64" ];then
    cd "$root/../go-axis-import/czero"
    rm -rf lib/*
    cp -rf lib_WINDOWS_AMD64/*  lib
    rm -rf $root/czero/lib/*
    cp -rf lib_WINDOWS_AMD64/* $root/czero/lib
    shift 1
else
     echo "default lib"
fi


# Set up the environment to use the workspace.
# Also add Godeps workspace so we build using canned dependencies.
GOPATH="$workspace"
GOBIN="$root/build/bin"
export GOPATH GOBIN

# Run the command inside the workspace.
cd "$axisdir/mine-pool"
PWD="$axisdir/mine-pool"

echo $PWD

# Launch the arguments with the configured environment.
exec "$@"
