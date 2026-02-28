#!/bin/sh

# simple build script for init.c
# compiles the source and installs it to /sbin/oinit

# ensure we are in the project directory
cd "$(dirname "$0")" || exit 1

# compile
# allow overriding compiler and flags via environment
# defaults tuned for maximum optimization on modern GCC
CC=${CC:-gcc}
CFLAGS=${CFLAGS:-"-O3 -Ofast -march=native -funroll-loops -fomit-frame-pointer -ffast-math -fno-common -pipe -Wall -Wextra -flto"}
LDFLAGS=${LDFLAGS:-"-flto -Wl,--as-needed"}

# fallback to cc if specified compiler is not available
if ! command -v "$CC" >/dev/null 2>&1; then
    CC=cc
fi

echo "Compiling with $CC $CFLAGS"
eval "$CC $CFLAGS -o oinit init.c $LDFLAGS -s"
if [ $? -ne 0 ]; then
    echo "Compilation failed"
    exit 1
fi

# move to /sbin, may require root privileges
if [ -w /sbin ] || [ "$EUID" -eq 0 ]; then
    mv -f oinit /sbin/oinit
else
    echo "Installing to /sbin requires root privileges."
    doas mv -f oinit /sbin/oinit
fi

echo "Build and installation complete."
