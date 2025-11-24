#! /usr/bin/env sh

# Exit in case of error
set -e

TAG=${TAG?Variable not set} \
ADMIN_ENV=${ADMIN_ENV-production} \
docker-compose \
-f docker-compose.yml \
build
