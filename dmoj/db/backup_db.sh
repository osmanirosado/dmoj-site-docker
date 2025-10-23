#!/usr/bin/env bash

docker exec dmoj-mariadb bash -c 'mariadb-backup --backup --target-dir=/backup --password="$(</run/secrets/db_root_password)"'

docker exec dmoj-mariadb mariadb-backup --prepare --target-dir=/backup
