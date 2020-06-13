FROM docker:latest

RUN apk add --no-cache py3-pip python3-dev libffi-dev openssl-dev curl gcc libc-dev make && \
    pip3 install docker-compose
