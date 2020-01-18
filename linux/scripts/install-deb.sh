#!/bin/bash

if [ $# -ne 3 ]; then
  echo 1>&2 "Usage: $0 BUILD_RESULTS_DIR VLINK_VERSION DISTRIBUTION"
  exit 1
fi

BUILD_RESULTS_DIR="$1"
VLINK_VERSION="$2"
DISTRIBUTION="$3"

sudo dpkg -i "${BUILD_RESULTS_DIR}/vlink_${VLINK_VERSION}_amd64.${DISTRIBUTION}.deb"
