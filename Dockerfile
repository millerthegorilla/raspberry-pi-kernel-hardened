FROM debian:trixie-slim

LABEL maintainer="hardenpi"

# Internal user who will build the kernel
ARG user=builder

# Install Git and the build dependencies
# hadolint ignore=DL3008
RUN dpkg --add-architecture arm64

RUN apt-get update -qq -y && apt-get install --no-install-recommends -qq -y \
        apt-transport-https \
        bc \
        bison \
        build-essential \
        ca-certificates \
        cpio \
        dpkg-dev \
        fakeroot \
        flex \
        git \
        kmod \
        libssl-dev \
        libc6-dev \
        libncurses5-dev \
        make \
        rsync \
        gcc-aarch64-linux-gnu \
        gcc-arm-linux-gnueabihf \
        debhelper-compat \
        libelf-dev \
        libssl-dev:arm64 \
        crossbuild-essential-armhf \
        crossbuild-essential-arm64 \
    && update-ca-certificates \
    && apt-get -y autoclean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

# Create user and set work directory
RUN useradd -m $user
USER $user
WORKDIR /home/$user
RUN mkdir -p /home/$user/output
RUN chown $user:$user /home/$user/output
RUN chmod 0777 /home/$user/output

# Copy script that builds the kernel
COPY --chown=$user:$user build-kernel.sh .
RUN chmod +x build-kernel.sh

ENTRYPOINT ["bash", "build-kernel.sh"]
CMD ["--help"]
