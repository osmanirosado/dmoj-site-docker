# DMOJ Site Docker

This repository contains the Docker files to run a clone of the [DMOJ site](https://github.com/DMOJ/online-judge).
It configures some additional services, such as mathoid, pdfoid, and texoid.

## Installation

First, [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/) must be installed. 
Installation instructions can be found on their respective websites.

Clone the repository:
```sh
git clone git@git.uclv.edu.cu:dmoj/dmoj-site-docker.git
cd dmoj-site-docker
```

Initialize the setup by coping the configuration and environment files
```sh
bash initialize
cd dmoj
```
From now on, it is assumed you are in the `dmoj` directory.

Configure the environment variables in the files copied to `dmoj/env` from `example/env`.
Define the secrets variables in the files created in `secrets/`.

Pull images ignoring those that can be build
```sh
docker compose pull --ignore-buildable
```

Start up the database server
```sh
docker compose up -d db
```

Execute bash in the database container
```sh
docker compose exec db bash
```

Add time zone data to the database. A few pages require this.
```sh
mariadb-tzinfo-to-sql /usr/share/zoneinfo | mariadb -p"$(</run/secrets/db_root_password)" mysql
```

Next, build the images:
```sh
docker compose --progress=plain build
```

Start up the site, so you can generate the static files and perform the initial migrations:
```sh
docker compose up -d site
```

Change ownership to application directories
```sh
docker compose exec -T -u root site dmoj-change-owner
```

Start a shell inside the site container
```sh
docker compose exec site bash
```

You will need to generate the static files:
```sh
# static
python3 manage.py collectstatic

# jsi18n
python3 manage.py compilejsi18n

# other assets
cp 502.html logo.png robots.txt /var/opt/lib/dmoj/assets/
```

You will need to generate the schema for the database, since it is currently empty:
```sh
python3 manage.py migrate
```

Finally, the DMOJ comes with fixtures so that the initial installation is not blank. 
They can be loaded with the following commands:
```sh
python3 manage.py loaddata navbar
python3 manage.py loaddata language_small
python3 manage.py loaddata demo # optional
```

## Usage

Start up all services
```sh
docker compose up -d
```

## Updating The Site
Updating various sections of the site requires different images to be rebuilt.

If any prerequisites were modified, you will need to rebuild most of the images:
```sh
docker compose up -d --build site celery bridged wsevent
```
If the static files are modified, you will need to generate the static files.

If only the source code is modified, a restart is sufficient:
```sh
docker compose restart site celery bridged wsevent
```

## Multiple Nginx Instances

The `compose.yml` configures Nginx to publish to port 8080 on local host. 
If you have another Nginx instance on your host machine, you may want to change the port and proxy pass instead.

For example, a possible Nginx configuration file on your host machine would be:
```
server {
    listen 80;
    listen [::]:80;

    add_header X-UA-Compatible "IE=Edge,chrome=1";
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";

    location / {
        proxy_http_version 1.1;
        proxy_buffering off;
        proxy_set_header Host $http_host;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_pass http://127.0.0.1:8080/;
    }
}
```

## Common Errors
### 502 Bad Gateway
Ensure that you also restart the Nginx container if you restart the site container as Nginx caches DNS queries. 
Otherwise, Nginx will try to hit the old IP, causing a 502 Bad Gateway. See [this issue](https://github.com/docker/compose/issues/3314) for more information.
