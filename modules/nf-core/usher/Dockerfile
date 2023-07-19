FROM ubuntu:20.04

CMD ["/bin/bash"]

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

ENV DEBIAN_FRONTEND=noninteractive

USER root

# install git
RUN apt-get update && apt-get install -yq --no-install-recommends git wget ca-certificates sudo python3 python3-pip # buildkit

WORKDIR /HOME/kentsource

RUN wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/faSomeRecords

RUN wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/faSize

RUN chmod 775 *

WORKDIR /HOME

RUN wget https://github.com/yatisht/usher/archive/refs/tags/v0.6.2.tar.gz

RUN tar -xzf v0.6.2.tar.gz && mv usher-0.6.2 usher

WORKDIR /HOME/usher

RUN ./install/installUbuntu.sh

ENV PATH=/HOME/usher/build:/HOME/kentsource:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
