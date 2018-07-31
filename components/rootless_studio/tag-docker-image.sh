#!/bin/bash

source ./docker-base.sh

for arg in "$@"; do
  docker tag "${IMAGE_NAME}:${VERSION}" "${IMAGE_NAME}:${arg}"
done
