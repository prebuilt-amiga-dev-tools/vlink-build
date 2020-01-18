#!/bin/bash

if [ $# -ne 3 ]; then
  echo 1>&2 "Usage: $0 BUILD_RESULTS_DIR VLINK_VERSION DISTRIBUTION"
  exit 1
fi

BUILD_RESULTS_DIR="$1"
VLINK_VERSION="$2"
DISTRIBUTION="$3"

sudo dpkg -i "${BUILD_RESULTS_DIR}/vlink_${VLINK_VERSION}_amd64.${DISTRIBUTION}.deb"

mkdir -p "${BUILD_RESULTS_DIR}/temp"

vlink -bamigahunk -o "${BUILD_RESULTS_DIR}/temp/test_amigahunk.exe" tests/test_amigahunk.o && cmp tests/test_amigahunk.exe.expected "${BUILD_RESULTS_DIR}/temp/test_amigahunk.exe" || exit 1

rm -rf "${BUILD_RESULTS_DIR}/temp"

sudo dpkg -r vlink

