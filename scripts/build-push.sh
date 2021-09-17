#!/usr/bin/env bash

set -e

basename="tiangolo/docker-with-compose"
latest_tag="${basename}:latest"
dated_tag="${basename}:$(date -I)"

bash scripts/build.sh

docker tag "$latest_tag" "$dated_tag"

bash scripts/docker-login.sh

docker push "$latest_tag"
docker push "$dated_tag"
