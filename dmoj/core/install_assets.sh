#!/bin/bash

# Usage
# docker compose exec site bash < core/install_assets.sh

cd /opt/dmoj/code || exit

python3 manage.py collectstatic --noinput
python3 manage.py compilemessages
python3 manage.py compilejsi18n
cp 502.html logo.png robots.txt /var/opt/lib/dmoj/assets/
