FROM debian:12-slim AS temporal

WORKDIR /home

# git
RUN apt-get update && apt-get install -y git && apt-get clean

# online judge code
RUN git clone --depth 1 --branch master --single-branch --recurse-submodules --shallow-submodules https://github.com/DMOJ/online-judge.git
RUN ls online-judge/

# online judge assets
# See https://github.com/DMOJ/online-judge/blob/master/.gitmodules
RUN ls online-judge/resources/libs/

FROM node:22-slim AS maker

WORKDIR /home

# node modules
RUN npm install -g sass postcss-cli postcss autoprefixer

# code
COPY --from=temporal /home/online-judge /home/code

WORKDIR /home/code

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
COPY --from=temporal /home/online-judge/requirements.txt /root
RUN pip3 install --no-cache-dir -r /root/requirements.txt

# addicional packages
RUN pip3 install --no-cache-dir pymysql mysqlclient django-redis redis websocket-client uwsgi

# code
COPY --from=maker /home/code /opt/dmoj/code

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

WORKDIR /home

RUN npm install qu ws simplesets

# code
COPY --from=temporal /home/online-judge/websocket /home/code/websocket

# config
COPY config.js /home/code/websocket

EXPOSE 15100
EXPOSE 15101
EXPOSE 15102

CMD node /home/code/websocket/daemon.js
