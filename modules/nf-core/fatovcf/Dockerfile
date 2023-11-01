FROM ubuntu:20.04

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends build-essential \
 wget cmake  libboost-filesystem-dev libboost-program-options-dev libboost-iostreams-dev libboost-date-time-dev \
 libprotoc-dev libprotoc-dev protobuf-compiler \
 mafft rsync libtbb-dev openmpi-bin libopenmpi-dev automake libtool autoconf make nasm && apt-get autoclean

RUN mkdir faToVcf && cd faToVcf && rsync -aP rsync://hgdownload.soe.ucsc.edu/genome/admin/exe/linux.x86_64/faToVcf .

RUN chmod +x faToVcf

ENV PATH="/faToVcf:${PATH}"

WORKDIR /data/
