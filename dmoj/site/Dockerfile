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
COPY --from=maker /home/online-judge /opt/online-judge

# uwsgi config
COPY uwsgi.ini /opt/online-judge

# site settings
COPY local_settings.py /opt/online-judge/dmoj

WORKDIR /opt/online-judge

RUN useradd --uid 1000 --shell=/usr/sbin/nologin dmoj

USER dmoj

FROM base AS site

# Copy your script into the container
COPY start-script.sh /usr/local/bin/start-script.sh

# Make the script executable
RUN chmod +x /usr/local/bin/start-script.sh

# Switch to root to run the script
USER root

# Run the script on container start
ENTRYPOINT ["/usr/local/bin/start-script.sh"]

# Switch to the non-root user
USER dmoj

EXPOSE 8000

CMD uwsgi --ini /opt/online-judge/uwsgi.ini

FROM base AS celery

CMD celery -A dmoj_celery worker -l info --concurrency=2

FROM base AS bridged

EXPOSE 9999
EXPOSE 9998

CMD python3 /opt/online-judge/manage.py runbridged

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

CMD node /opt/online-judge/websocket/daemon.js
