FROM node:22-slim AS maker

WORKDIR /home

# node modules
RUN npm install -g sass postcss-cli postcss autoprefixer

# online judge code and judge assets
ADD https://github.com/DMOJ/online-judge.git /home/online-judge

WORKDIR /home/online-judge

# make styles
RUN bash make_style.sh

FROM python:3.11-slim AS base

# system dependencies
RUN <<EOF
apt-get update
apt-get install -y \
        git gcc g++ make python3-dev python3-pip libxml2-dev libxslt1-dev zlib1g-dev gettext curl wget \
        pkgconf debconf-utils mariadb-client libmariadb-dev
apt-get autoremove -y
apt-get clean
EOF

# application requirements
COPY --from=maker /home/online-judge/requirements.txt /root
RUN pip3 install --no-cache-dir -r /root/requirements.txt

# addicional packages
RUN pip3 install --no-cache-dir pymysql mysqlclient django-redis redis websocket-client uwsgi

# code
COPY --from=maker /home/online-judge /opt/dmoj/code

# uwsgi config
COPY uwsgi.ini /opt/dmoj

# site settings
COPY local_settings.py /opt/dmoj/code/dmoj

WORKDIR /opt/dmoj/code

FROM base AS site

EXPOSE 8000

CMD uwsgi --ini /opt/dmoj/uwsgi.ini

FROM base AS celery

CMD celery -A dmoj_celery worker -l info --concurrency=2

FROM base AS bridged

EXPOSE 9999
EXPOSE 9998

CMD python3 /opt/dmoj/code/manage.py runbridged

FROM node:22-slim AS wsevent

WORKDIR /opt/dmoj

RUN npm install qu ws simplesets

# code
COPY --from=maker /home/online-judge/websocket /opt/dmoj/code/websocket

# config
COPY config.js /opt/dmoj/code/websocket

EXPOSE 15100
EXPOSE 15101
EXPOSE 15102

CMD node /opt/dmoj/code/websocket/daemon.js
