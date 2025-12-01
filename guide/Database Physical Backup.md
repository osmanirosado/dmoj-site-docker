# Database Physical Backup

## Backup

Command to back up all databases 
```sh
docker compose exec -T db bash -c 'mariadb-backup --backup --stream=mbstream --password="$(</run/secrets/db_root_password)" | gzip' > ~/tmp/mariadb_backup_$(date +"%Y-%m-%d_%H-%M-%S_%Z").mb.gz
```

## Restore

Create database volume
```sh
docker compose up --no-start db
```

Run a container to restore the database
```sh
docker compose run --rm -v ~/tmp/:/mnt/ db bash
```

Extract the backup files
```sh
gunzip -c /mnt/mariadb_backup.mb.gz | mbstream -x -C /home/
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
