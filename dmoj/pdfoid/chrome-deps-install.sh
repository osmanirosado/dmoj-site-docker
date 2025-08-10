#!/bin/bash

# test file existence
[ -e "$1" ] || echo "[Error] File not found $1" && exit 1
# test file non zero length
[ -n "$1" ] || echo "[Error] Empty file $1" && exit 2

apt-get update

while read pkg; do
  apt-get satisfy -y --no-install-recommends "${pkg}" || exit 3;
done < "$1";

apt-get clean
