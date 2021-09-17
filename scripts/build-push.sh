#!/usr/bin/env bash

set -e

bash scripts/build.sh
bash scripts/docker-login.sh

docker push "$latest_tag"
docker push "$dated_tag"
