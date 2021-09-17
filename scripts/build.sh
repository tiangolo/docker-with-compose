#!/usr/bin/env bash

set -e

basename="tiangolo/docker-with-compose"
latest_tag="${basename}:latest"
dated_tag="${basename}:$(date -I)"

docker build -t "$latest_tag" .

docker tag "$latest_tag" "$dated_tag"
