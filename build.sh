#!/bin/bash
cd "$(dirname $0)"
cd "$(pwd -P)"
set -e

QUICK=no
if [ ! -z "$1" ]; then
  if [ "$1" == "-q" ]; then
    shift
    QUICK=yes
  fi
fi

PKG=$1
if [ -z "${PKG}" ]; then
  echo "Package is required." >&2
  exit 1
fi

cd "${PKG}"
IMAGE_NAME="insideo/stretch-backports-randomcoder-${PKG}"
CONTAINER_NAME="insideo-stretch-backports-randomcoder-${PKG}-tmp"

docker build -t "${IMAGE_NAME}" --force-rm=true --rm=true --pull docker-build-env
docker rm -f "${CONTAINER_NAME}" 2>/dev/null || true
docker run --name "${CONTAINER_NAME}" "${IMAGE_NAME}" /bin/sh
rm -rf packages || true
mkdir -p packages
docker cp "${CONTAINER_NAME}:/packages" .
docker rm -f "${CONTAINER_NAME}" 2>/dev/null || true
cp -av packages/* ../packages/
rm -rf packages || true

if [ "${QUICK}" != "yes" ]; then
  docker rmi "${IMAGE_NAME}"
else 
  exit 0
fi
