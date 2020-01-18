#!/bin/bash

if [ $# -ne 2 ]; then
  echo 1>&2 "Usage: $0 VLINK_URL VLINK_DOC_URL"
  exit 1
fi

VLINK_URL="$1"
VLINK_DOC_URL="$2"

wget -O vlink.tar.gz "${VLINK_URL}"
tar -xvf vlink.tar.gz
rm vlink.tar.gz

wget -O vlink/vlink.pdf "${VLINK_DOC_URL}"

