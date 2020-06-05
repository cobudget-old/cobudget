#!/bin/bash

cp docker-compose.test.yml docker-compose.override.yml && \
docker-compose down --volumes --remove-orphans && \
docker-compose build > /dev/null && \
docker-compose run cobudget-api ; \
rm docker-compose.override.yml
