# Database Logical Backup

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
