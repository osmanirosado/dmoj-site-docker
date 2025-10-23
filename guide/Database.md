# Database

Change working directory
```sh
cd dmoj
```

Bash session on the database container
```sh
docker compose exec db bash
```

Maria DB access as root
```sh
mariadb -p"$(</run/secrets/db_root_password)"
```

Maria DB access to default database
```sh
mariadb -u "$MARIADB_USER" -p"$(</run/secrets/db_password)" "$MARIADB_DATABASE"
```

## Dump

Logical backup

Command to dump the `dmoj` database
```sh
docker compose exec -T db bash -c 'mariadb-dump -p"$(</run/secrets/db_root_password)" --routines --triggers dmoj' > ~/backups/dmoj_db_backup_2025-08-25.sql
```

Command to restore the `dmoj` database
```sh
docker compose exec -T db bash -c 'mariadb -p"$(</run/secrets/db_root_password)" dmoj' < ~/backups/dmoj_db_backup_2025-08-25.sql
```

## Backup

Physical backup

Command to back up all databases 
```sh
docker compose exec -T db bash -c 'mariadb-backup --backup --stream=mbstream --password="$(</run/secrets/db_root_password)" | gzip' > ~/backups/mariadb_backup_2025-10-21.mb.gz
```

Create database volume
```sh
docker compose up --no-start db
```

Run a container to restore the database
```sh
docker compose run --rm -v ~/backups/:/mnt/ db bash
```

Extract the backup files
```sh
gunzip -c /mnt/mariadb_backup_2025-10-21.mb.gz | mbstream -x -C /home/
```

Prepare the backup data
```sh
mariadb-backup --prepare --target-dir=/home/
```

Move the backup to the database volume
```sh
mariadb-backup --move-back --target-dir=/home/
```

Change the owner of moved data
```sh
chown -R mysql:mysql /var/lib/mysql/
```

Exit the temporal container and start up the database service
```sh
docker compose up -d db
```
