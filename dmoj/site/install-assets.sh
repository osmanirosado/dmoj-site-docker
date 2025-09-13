#!/bin/bash

# Usage
# bash /usr/local/bin/install-assets.sh
# docker compose exec -T -u root site /usr/local/bin/install-assets.sh

if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

assets_dir=/var/opt/lib/dmoj/assets/

echo "> Collect static"
python3 manage.py collectstatic --noinput

echo "> Compile messages"
python3 manage.py compilemessages

echo "> Compile jsi18n"
python3 manage.py compilejsi18n

echo "> Copy additional assets"
cp 502.html logo.png robots.txt "$assets_dir"

echo "> Update ownership of $assets_dir"
chown -R dmoj:dmoj "$assets_dir"
