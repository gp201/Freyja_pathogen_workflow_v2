FROM python:3.11.4-bullseye

RUN pip install pandas==2.0.3

# setup git
RUN apt-get update && apt-get install -y git

WORKDIR /data

RUN git clone https://github.com/jmcbroome/automated-lineage-json.git

WORKDIR /data/automated-lineage-json
