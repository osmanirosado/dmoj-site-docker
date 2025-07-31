FROM python:3.11-slim AS base

RUN apt-get update && \
    apt-get install -y \
        git gcc g++ make curl gettext wget \
        libxml2-dev libxslt1-dev zlib1g-dev \
        mariadb-client libmariadb-dev \
        libjpeg-dev debconf-utils pkg-config && \
    curl -sL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN npm install -g sass postcss-cli postcss autoprefixer

COPY repo/requirements.txt /home
RUN pip3 install -r /home/requirements.txt

RUN pip3 install pymysql mysqlclient django-redis redis websocket-client uwsgi

# code
COPY repo /home/code

# uwsgi config
COPY base/uwsgi.ini /home/code

# site settings
COPY base/local_settings.py /home/code/dmoj

WORKDIR /home/code

FROM base AS site

EXPOSE 8000

CMD uwsgi --ini uwsgi.ini

FROM base AS celery

CMD celery -A dmoj_celery worker -l info --concurrency=2

FROM base AS bridged

EXPOSE 9999
EXPOSE 9998

CMD python manage.py runbridged
