FROM docker:latest

RUN apk add --no-cache py-pip python-dev libffi-dev openssl-dev curl gcc libc-dev make && \
    pip install docker-compose
