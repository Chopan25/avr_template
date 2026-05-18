FROM ubuntu:24.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install compilation tools, cmake, flashing, and debugging tools
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    gcc-avr \
    binutils-avr \
    avr-libc \
    avrdude \
    gdb-avr \
    simavr \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /src