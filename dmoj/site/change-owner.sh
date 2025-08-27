#!/bin/bash

# Define the list of target paths
paths=(
    "/var/log/dmoj/"
    "/var/opt/lib/dmoj/assets/"
    "/var/opt/lib/dmoj/media/"
    "/var/opt/lib/dmoj/problems/"
    "/var/cache/dmoj/pdf/"
    "/var/cache/dmoj/data/"
    "/var/cache/dmoj/mathoid/"
    "/var/cache/dmoj/texoid/"
)

# Loop through each path and apply the chown command
for path in "${paths[@]}"; do
    echo "Changing ownership of $path"
    chown -R dmoj:dmoj "$path"
done
