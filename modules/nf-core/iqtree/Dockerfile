FROM ubuntu:20.04

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y wget

RUN wget https://github.com/iqtree/iqtree2/releases/download/v2.2.2.3/iqtree-2.2.2.3-Linux.tar.gz

RUN tar -xzf iqtree-2.2.2.3-Linux.tar.gz

# add iqtree to path
ENV PATH="/iqtree-2.2.2.3-Linux/bin:${PATH}"
