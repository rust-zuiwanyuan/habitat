#!/bin/bash

set -euo pipefail

source .buildkite/scripts/shared.sh
version=$(buildkite-agent meta-data get "version")

if [[ "${FAKE_RELEASE_TAG}" ]]; then
  export IMAGE_NAME="habitat/fakey-mc-fake-face-studio"
fi

pushd ./components/rootless_studio >/dev/null
docker pull "${IMAGE_NAME}:${version}"
./tag-docker-image.sh "${version}" "latest"
./publish-to-dockerhub.sh "${version}" "latest"
popd >/dev/null
