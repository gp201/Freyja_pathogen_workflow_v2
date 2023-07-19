FROM staphb/minimap2:2.24

WORKDIR /setup/

RUN apt-get update && apt-get install -y git wget autoconf automake make gcc perl zlib1g-dev libbz2-dev liblzma-dev libcurl4-gnutls-dev libssl-dev libncurses5-dev

RUN wget https://github.com/virus-evolution/gofasta/releases/download/v1.2.0/gofasta-linux-amd64

RUN mv gofasta-linux-amd64 /usr/local/bin/gofasta && chmod +x /usr/local/bin/gofasta

# insall samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.16.1/samtools-1.16.1.tar.bz2 -O samtools.tar.bz2 && \
    tar -xjvf samtools.tar.bz2 && \
    cd samtools-1.16.1 && \
    make && \
    make prefix=/usr/local/bin install && \
    mv /setup/samtools-1.16.1 /usr/local/bin/ && \
    rm -rf /setup/samtools.tar.bz2

ENV PATH="/usr/local/bin/samtools-1.16.1/:${PATH}"

WORKDIR /data/
