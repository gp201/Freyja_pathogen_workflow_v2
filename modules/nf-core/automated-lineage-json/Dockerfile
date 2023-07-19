FROM python:3.11.4

RUN pip install pandas==2.0.3

# setup git
RUN apt-get update && apt-get install -y git

WORKDIR /data/

# give user access to /data
RUN chmod -R a+rwx /data/
