#!/bin/bash

apt-get update

while read pkg; do
  apt-get satisfy -y --no-install-recommends "${pkg}";
done < /opt/chrome/deb.deps;

rm -rf /var/lib/apt/lists/*
