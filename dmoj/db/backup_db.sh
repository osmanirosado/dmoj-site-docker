#!/usr/bin/env bash

echo "> Executing MariaDB Backup"
docker exec dmoj-mariadb bash -c 'mariadb-backup --backup --target-dir=/backup --password="$(</run/secrets/db_root_password)"'

echo "> Preparing MariaDB Backup"
docker exec dmoj-mariadb mariadb-backup --prepare --target-dir=/backup
