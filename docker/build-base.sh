#!/usr/bin/env bash
#
# Build the heavy OAI dApp base images LOCALLY and push them to GHCR.
#
# These layers change rarely, so they are built here on a capable machine instead
# of in CI. The GitHub Actions workflow then builds the lightweight dApp image
# (docker/Dockerfile-oai-dapp) FROM the pushed OAI base on every push.
#
# Layer chain built here:
#   ubuntu -> uhd:4.7 -> dapp-oai-deps -> dapp-oai-base
#                         (Dockerfile-deps)  (Dockerfile-oai)
#
# Usage:
#   ./docker/build-base.sh [TAG]
#
# Examples:
#   ./docker/build-base.sh                 # build & push :latest
#   ./docker/build-base.sh 2026-06-01      # also tag & push :2026-06-01
#   PUSH=0 ./docker/build-base.sh          # build only, no push
#   REGISTRY=ghcr.io/myorg ./docker/build-base.sh
#
# Requirements:
#   - docker logged in to GHCR:  echo "$GH_PAT" | docker login ghcr.io -u <user> --password-stdin

set -euo pipefail

REGISTRY="${REGISTRY:-ghcr.io/wineslab}"
UHD_TAG="${UHD_TAG:-uhd:4.7}"          # local tag used by Dockerfile-deps' FROM
UHD_REPO="${UHD_REPO:-${REGISTRY}/uhd}" # remote repo for the reusable UHD base
UHD_VERSION_TAG="${UHD_VERSION_TAG:-4.7}"
DEPS_REPO="${DEPS_REPO:-${REGISTRY}/dapp-oai-deps}"
BASE_REPO="${BASE_REPO:-${REGISTRY}/dapp-oai-base}"
EXTRA_TAG="${1:-}"
PUSH="${PUSH:-1}"

# docker/ directory holding the Dockerfiles (also used as build context)
DOCKER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

build_tags() {
  # echoes "-t repo:latest [-t repo:EXTRA_TAG]"
  local repo="$1"
  printf -- '-t %s:latest' "$repo"
  [[ -n "${EXTRA_TAG}" ]] && printf -- ' -t %s:%s' "$repo" "${EXTRA_TAG}"
}

push_repo() {
  local repo="$1"
  echo ">> Pushing ${repo}:latest"
  docker push "${repo}:latest"
  if [[ -n "${EXTRA_TAG}" ]]; then
    echo ">> Pushing ${repo}:${EXTRA_TAG}"
    docker push "${repo}:${EXTRA_TAG}"
  fi
}

echo ">> [1/3] UHD base (${UHD_TAG} + ${UHD_REPO}:${UHD_VERSION_TAG}) from Dockerfile-uhd-ubuntu24"
docker build -f "${DOCKER_DIR}/Dockerfile-uhd-ubuntu24" \
  -t "${UHD_TAG}" \
  -t "${UHD_REPO}:${UHD_VERSION_TAG}" \
  "${DOCKER_DIR}"

echo ">> [2/3] dependencies image (${DEPS_REPO}) from Dockerfile-deps"
# shellcheck disable=SC2046
docker build $(build_tags "${DEPS_REPO}") -f "${DOCKER_DIR}/Dockerfile-deps" "${DOCKER_DIR}"

echo ">> [3/3] OAI base image (${BASE_REPO}) from Dockerfile-oai"
# shellcheck disable=SC2046
docker build $(build_tags "${BASE_REPO}") \
  --build-arg DEPS_IMAGE="${DEPS_REPO}:latest" \
  -f "${DOCKER_DIR}/Dockerfile-oai" "${DOCKER_DIR}"

if [[ "${PUSH}" == "1" ]]; then
  echo ">> Pushing ${UHD_REPO}:${UHD_VERSION_TAG}"
  docker push "${UHD_REPO}:${UHD_VERSION_TAG}"
  push_repo "${DEPS_REPO}"
  push_repo "${BASE_REPO}"
  echo ">> Done. dApp CI builds FROM ${BASE_REPO}:latest"
else
  echo ">> PUSH=0 set; skipping push. Built ${UHD_TAG}, ${DEPS_REPO}:latest and ${BASE_REPO}:latest locally."
fi
