FROM python:3.11-slim AS base

# user
RUN useradd --create-home --system --user-group --shell=/usr/sbin/nologin app

# system dependencies
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

# node modules
RUN npm install -g sass postcss-cli postcss autoprefixer

# application requirements
COPY repo/requirements.txt /root
RUN pip install --no-cache-dir -r /root/requirements.txt

# addicional packages
RUN pip install --no-cache-dir pymysql mysqlclient django-redis redis websocket-client uwsgi

USER app

# code
COPY repo /home/app/code

# uwsgi config
COPY base/uwsgi.ini /home/app

# site settings
COPY base/local_settings.py /home/app/code/dmoj

WORKDIR /home/app/code

FROM base AS site

EXPOSE 8000

CMD uwsgi --ini /home/app/uwsgi.ini

FROM base AS celery

CMD celery -A dmoj_celery worker -l info --concurrency=2

FROM base AS bridged

EXPOSE 9999
EXPOSE 9998

CMD python /home/app/code/manage.py runbridged
