FROM ubuntu:20.04

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

ENV DEBIAN_FRONTEND=noninteractive

CMD ["/bin/bash"]

ARG MAFFT_VER=7.520

RUN apt-get update && apt-get install -y --no-install-recommends wget ca-certificates procps && apt-get autoclean

RUN wget https://mafft.cbrc.jp/alignment/software/mafft_${MAFFT_VER}-1_amd64.deb && dpkg -i mafft_${MAFFT_VER}-1_amd64.deb && rm mafft_${MAFFT_VER}-1_amd64.deb
