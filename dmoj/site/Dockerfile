FROM node:22-slim AS maker

ARG ONLINE_JUDGE_REPO=https://github.com/DMOJ/online-judge.git

WORKDIR /home

# node modules
RUN npm install -g sass postcss-cli postcss autoprefixer

# online judge code and judge assets
ADD "$ONLINE_JUDGE_REPO" /home/online-judge

WORKDIR /home/online-judge

# make styles
RUN bash make_style.sh

FROM python:3.12-slim AS base

# system dependencies
RUN <<EOF
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get upgrade -y
apt-get install -y --no-install-recommends \
                   git gcc g++ make libxml2-dev libxslt1-dev zlib1g-dev gettext curl wget pkgconf debconf-utils \
                   mariadb-client libmariadb-dev
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
EOF

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip3 install --no-cache-dir --upgrade pip

# application requirements
COPY --from=maker /home/online-judge/requirements.txt /root
RUN pip3 install --no-cache-dir -r /root/requirements.txt
RUN pip3 check

# addicional packages
RUN pip3 install --no-cache-dir pymysql mysqlclient 'django-redis<7' 'redis<7' websocket-client uwsgi
RUN pip3 check

# dmoj user
RUN useradd --uid 1000 --shell=/usr/sbin/nologin dmoj

USER dmoj

# code
COPY --chown=dmoj --from=maker /home/online-judge /opt/online-judge

# uwsgi config
COPY --chown=dmoj uwsgi.ini /opt/online-judge

# sample local settings
COPY --chown=dmoj sample_local_settings.py /opt/online-judge/dmoj/local_settings.py

WORKDIR /opt/online-judge

# check
RUN python3 manage.py check

# Compiles .po files created by makemessages to .mo files for use with the built-in gettext support.
RUN python3 manage.py compilemessages

# Collect static
RUN python3 manage.py collectstatic --noinput

# Compile jsi18n
RUN python3 manage.py compilejsi18n

FROM base AS site

USER root

COPY dmoj-change-owner /usr/local/bin/
RUN chmod +x /usr/local/bin/dmoj-change-owner

COPY dmoj-install-assets /usr/local/bin/
RUN chmod +x /usr/local/bin/dmoj-install-assets

USER dmoj

EXPOSE 8000

CMD ["uwsgi", "--ini", "/opt/online-judge/uwsgi.ini"]

FROM base AS celery

CMD ["celery", "-A", "dmoj_celery", "worker", "-l", "info", "--concurrency=2"]

FROM base AS bridged

EXPOSE 9999
EXPOSE 9998

CMD ["python3", "/opt/online-judge/manage.py", "runbridged"]

FROM node:22-slim AS wsevent

WORKDIR /opt/online-judge

RUN npm install qu ws simplesets

# code
COPY --from=maker /home/online-judge/websocket /opt/online-judge/websocket

# config
COPY config.js /opt/online-judge/websocket

RUN useradd app

USER app

EXPOSE 15100
EXPOSE 15101
EXPOSE 15102

CMD ["node", "/opt/online-judge/websocket/daemon.js"]
