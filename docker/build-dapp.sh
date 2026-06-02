#!/usr/bin/env bash
#
# Build and publish the final dApp image (ghcr.io/wineslab/dapp-oai) on top of the pre-built OAI base.
#
# The base (UHD + deps + libe3 + OAI) is built separately by docker/build-base.sh. This script only
# layers the dApp library on top, pinned to the commit the dApp-framework superproject records.
#
# Tags: :latest and :<dApp-library VERSION> (plus an optional extra TAG argument).
#
# Usage:
#   ./docker/build-dapp.sh [TAG]
#
# Examples:
#   ./docker/build-dapp.sh                 # build & push :latest and :<VERSION>
#   ./docker/build-dapp.sh 2026-06-02      # also tag & push :2026-06-02
#   PUSH=0 ./docker/build-dapp.sh          # build only, no push
#   DAPP_REF=main ./docker/build-dapp.sh   # build whatever dApp-library main is, instead of the pin
#
# Requirements:
#   - the base image must exist/be pullable (run ./docker/build-base.sh first)
#   - docker logged in to GHCR:  echo "$GH_PAT" | docker login ghcr.io -u <user> --password-stdin

set -euo pipefail

REGISTRY="${REGISTRY:-ghcr.io/wineslab}"
IMAGE_REPO="${IMAGE_REPO:-${REGISTRY}/dapp-oai}"
BASE_IMAGE="${BASE_IMAGE:-${REGISTRY}/dapp-oai-base:latest}"
EXTRA_TAG="${1:-}"
PUSH="${PUSH:-1}"

# docker/ directory holding the Dockerfiles (also used as build context)
DOCKER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${DOCKER_DIR}/.." && pwd)"

# Pin the dApp to the dApp-library commit checked out in the framework (overridable via DAPP_REF),
# and read its VERSION for the semantic tag. Fall back gracefully if the submodule isn't present.
DAPP_REF="${DAPP_REF:-$(git -C "${REPO_ROOT}/dApp-library" rev-parse HEAD 2>/dev/null || true)}"
DAPP_REF="${DAPP_REF:-main}"
VERSION="${VERSION:-$(tr -d '[:space:]' < "${REPO_ROOT}/dApp-library/VERSION" 2>/dev/null || true)}"
echo ">> dApp image ${IMAGE_REPO}  (dApp-library ref=${DAPP_REF}, VERSION=${VERSION:-unknown}) FROM ${BASE_IMAGE}"

# Assemble tags: always :latest, :<VERSION> if known, plus an optional extra tag.
tags=(-t "${IMAGE_REPO}:latest")
[[ -n "${VERSION}" ]]   && tags+=(-t "${IMAGE_REPO}:${VERSION}")
[[ -n "${EXTRA_TAG}" ]] && tags+=(-t "${IMAGE_REPO}:${EXTRA_TAG}")

docker build "${tags[@]}" \
  --build-arg BASE_IMAGE="${BASE_IMAGE}" \
  --build-arg GIT_REF_DAPP="${DAPP_REF}" \
  -f "${DOCKER_DIR}/Dockerfile-oai-dapp" "${DOCKER_DIR}"

if [[ "${PUSH}" == "1" ]]; then
  for t in "${tags[@]}"; do
    [[ "$t" == "-t" ]] && continue
    echo ">> Pushing ${t}"
    docker push "${t}"
  done
  echo ">> Done. Published ${IMAGE_REPO}:latest${VERSION:+ and :${VERSION}}${EXTRA_TAG:+ and :${EXTRA_TAG}}"
else
  echo ">> PUSH=0 set; skipping push. Built ${IMAGE_REPO}:latest${VERSION:+ and :${VERSION}} locally."
fi
