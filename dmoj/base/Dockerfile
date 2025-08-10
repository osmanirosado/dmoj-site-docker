FROM node:22-slim AS maker

WORKDIR /home

# node modules
RUN npm install -g sass postcss-cli postcss autoprefixer

# code
COPY repo /home/code

WORKDIR /home/code

# make styles
RUN bash make_style.sh

FROM python:3.11-slim AS base

# system dependencies
RUN apt-get update && \
    apt-get install -y \
        git gcc g++ make curl gettext wget libxml2-dev libxslt1-dev zlib1g-dev \
        mariadb-client libmariadb-dev libjpeg-dev debconf-utils pkg-config && \
    apt-get autoremove -y && \
    apt-get clean

# application requirements
COPY repo/requirements.txt /root
RUN pip install --no-cache-dir -r /root/requirements.txt

# addicional packages
RUN pip install --no-cache-dir pymysql mysqlclient django-redis redis websocket-client uwsgi

# code
COPY --from=maker /home/code /opt/dmoj/code

# uwsgi config
COPY base/uwsgi.ini /opt/dmoj

# site settings
COPY base/local_settings.py /opt/dmoj/code/dmoj

WORKDIR /opt/dmoj/code

FROM base AS site

EXPOSE 8000

CMD uwsgi --ini /opt/dmoj/uwsgi.ini

FROM base AS celery

CMD celery -A dmoj_celery worker -l info --concurrency=2

FROM base AS bridged

EXPOSE 9999
EXPOSE 9998

CMD python /opt/dmoj/code/manage.py runbridged
