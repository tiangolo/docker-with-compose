FROM docker:latest

COPY requirements.txt /tmp/requirements.txt

RUN apk add --no-cache bash py3-pip python3-dev libffi-dev openssl-dev curl gcc libc-dev rust cargo make && \
    pip3 install --no-cache-dir -r /tmp/requirements.txt
