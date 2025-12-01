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
