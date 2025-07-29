#!/bin/bash

apt-get update
apt-get install -y --no-install-recommends libimage-exiftool-perl

rm -rf /var/lib/apt/lists/*
