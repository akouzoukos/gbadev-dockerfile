FROM ubuntu:20.04
LABEL maintainer="kouzapo@gmail.com"

ENV TZ=Europe/Minsk
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
 && locale-gen "en_US.UTF-8"
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN apt-get update && \
    apt-get install -y binutils build-essential && \
    apt-get install -y wget
RUN wget https://apt.devkitpro.org/install-devkitpro-pacman && \
    chmod +x ./install-devkitpro-pacman

RUN yes | ./install-devkitpro-pacman

RUN rm ./install-devkitpro-pacman

ENV DEVKITPRO=/opt/devkitpro
ENV PATH=${DEVKITPRO}/tools/bin:$PATH

RUN dkp-pacman -Syyu --noconfirm && \
    dkp-pacman -S --needed --noconfirm gba-dev && \
    yes | dkp-pacman -Scc

RUN apt-get install -y python && \
    apt-get install -y python3-pip && \
    python3 -m pip install --upgrade pip && \
    pip3 install pillow && \
    pip3 install numpy

ENV DEVKITARM=${DEVKITPRO}/devkitARM
