# Database Logical Backup

## Dump

Logical backup

Command to dump the `dmoj` database
```sh
docker compose exec -T db bash -c 'mariadb-dump -p"$(</run/secrets/db_root_password)" --routines --triggers dmoj' > ~/tmp/dmoj_db_$(date +"%Y-%m-%d_%H-%M-%S_%Z").sql
```

Command to restore the `dmoj` database
```sh
docker compose exec -T db bash -c 'mariadb -p"$(</run/secrets/db_root_password)" dmoj' < ~/tmp/dmoj_db.sql
```
