# DMOJ Site Docker

Docker Compose stack for deploying the [DMOJ Online Judge](https://github.com/DMOJ/online-judge), 
including [Mathoid](https://gitlab.wikimedia.org/repos/mediawiki/services/mathoid), 
[Texoid](https://github.com/DMOJ/texoid) and [PDFoid](https://github.com/DMOJ/pdfoid) 
for rendering math, processing LaTeX and generating PDFs.

## Installation

First, [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/) must be installed. 
Installation instructions can be found on their respective websites.

Clone the repository:
```sh
git clone https://github.com/osmanirosado/dmoj-site-docker.git
cd dmoj-site-docker
```

Initialize the setup by coping the configuration and environment files
```sh
bash initialize
cd dmoj
```
From now on, it is assumed you are in the `dmoj` directory.

Configure the environment variables in the files copied to `dmoj/env` from `example/env`.
Define the secrets variables in the files created in `dmoj/secrets/`.

Pull images ignoring those that can be build
```sh
docker compose pull --ignore-buildable
```

Build the images
```sh
docker compose --progress=plain build
```

Start up the database server
```sh
docker compose up -d db
```

Execute bash in the database container
```sh
docker compose exec db bash
```

Add time zone data to the database
```sh
mariadb-tzinfo-to-sql /usr/share/zoneinfo | mariadb -p"$(</run/secrets/db_root_password)" mysql
```

Start up the site to generate the static files and perform the initial migrations
```sh
docker compose up -d site
```

Change ownership to application directories
```sh
docker compose exec -T -u root site dmoj-change-owner
```

Generate the static files
```sh
docker compose exec -T site dmoj-install-assets
```

Start a shell inside the site container
```sh
docker compose exec site bash
```

Generate the schema for the database, since it is currently empty
```sh
python3 manage.py migrate
```

The DMOJ comes with fixtures so that the initial installation is not blank. 
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

## Updating the Site
Updating various sections of the site requires different images to be rebuilt.

If any prerequisites were modified, rebuild most of the images
```sh
docker compose --progress=plain build site celery bridged wsevent
```

Recreate containers to use the new images
```shell
docker compose up -d
```

Ensure that you also restart the Nginx container if you restart the site container as Nginx caches DNS queries.
Otherwise, Nginx will try to hit the old IP, causing a 502 Bad Gateway. 
See [this issue](https://github.com/docker/compose/issues/3314) for more information.

Restart nginx service
```sh
docker compose restart nginx
```

If the static files are modified, generate the static files
```shell
docker compose exec -T site dmoj-install-assets
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
