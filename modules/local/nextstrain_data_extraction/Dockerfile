FROM python:3.10

RUN pip install biopython==1.81 numpy==1.26.4

# install git
RUN apt-get update && apt-get install -y wget

RUN wget https://github.com/nextstrain/augur/releases/download/22.4.0/nextstrain-augur-22.4.0.tar.gz

RUN tar -xzf nextstrain-augur-22.4.0.tar.gz

RUN cd nextstrain-augur-22.4.0 && python setup.py install

WORKDIR /data/
