FROM docker:latest

RUN apk add --no-cache py-pip
RUN pip install docker-compose
