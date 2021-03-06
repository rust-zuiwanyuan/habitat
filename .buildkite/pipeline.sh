#!/bin/bash

set -euo pipefail

if [[ "${FAKE_RELEASE_TAG:-}" || "${BUILDKITE_TAG}" ]]; then
    # Our releases are currently triggered by the existence of a tag
    echo -e "--- :sparkles: Preparing for a release! :sparkles:"

    if [[ "${FAKE_RELEASE_TAG:-}" ]]; then
        echo "Using fake release tag '${FAKE_RELEASE_TAG}'"
        release="${FAKE_RELEASE_TAG}"
    elif [[ "${BUILDKITE_TAG}" ]]; then
        echo "Using release tag '${BUILDKITE_TAG}'"
        release="${BUILDKITE_TAG}"
    fi
    channel="rc-${release}"
    echo "Release channel is '${channel}'"
    echo -e "## Habitat Release _${release}_" | buildkite-agent annotate --context "release-manifest"

    buildkite-agent meta-data set "release-channel" "${channel}"

    # We'll record the explicit version being built for future access,
    # even though 'cat'ing a file is pretty easy; we'll be sticking
    # other things into the Buildkite metadata, so it'll all be uniform.
    version=$(cat VERSION)
    buildkite-agent meta-data set "version" "${version}"

    buildkite-agent pipeline upload .buildkite/release_pipeline.yaml
else
    echo -e "--- :sparkles: Preparing for a CI run! :sparkles:"
    echo "TODO"
    exit 1
fi
