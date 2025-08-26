#!/bin/bash

# Usage
# docker compose exec -T site bash < site/install_assets.sh

echo "> Collect static"
python3 manage.py collectstatic --noinput

echo "> Compile messages"
python3 manage.py compilemessages

echo "> Compile jsi18n"
python3 manage.py compilejsi18n

echo "> Copy additional assets"
cp 502.html logo.png robots.txt /var/opt/lib/dmoj/assets/
