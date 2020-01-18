#!/bin/bash

if [ $# -ne 1 ]; then
  echo 1>&2 "Usage: $0 BUILD_RESULTS_DIR"
  exit 1
fi

BUILD_RESULTS_DIR=$1

rm -rf vlink
rm -f vlink.tar.gz
rm -rf "${BUILD_RESULTS_DIR}"
rm -f vlink_*
