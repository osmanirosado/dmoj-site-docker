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

Command to dump the `dmoj` database
```sh
docker compose exec -T db bash -c 'mariadb-dump -p"$(</run/secrets/db_root_password)" --routines --triggers dmoj' > ~/backups/dmoj_db_backup_2025-08-25.sql
```

Command to restore the `dmoj` database
```sh
docker compose exec -T db bash -c 'mariadb -p"$(</run/secrets/db_root_password)" dmoj' < ~/backups/dmoj_db_backup_2025-08-25.sql
```

## Backup

Command to back up all databases 
```sh
docker compose exec -T db bash -c 'mariadb-backup --backup --stream=mbstream --password="$(</run/secrets/db_root_password)" | gzip' > ~/backups/mariadb_backup_2025-10-21.mb.gz
```
