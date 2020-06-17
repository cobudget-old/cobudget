#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd ${DIR}/../../

if [ ! -e docker-compose.override.yml ]; then
  ln -s docker/docker-compose.test.yml docker-compose.override.yml
fi

docker-compose down --volumes --remove-orphans && \
docker-compose build > /dev/null && \
docker-compose run cobudget-api

rm docker-compose.override.yml
