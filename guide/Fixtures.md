# Fixtures

Change working directory
```sh
cd dmoj
```

Use the run command to mount fixtures inside a temporal container
```sh
docker compose run --rm -v ~/fixtures/:/mnt/fixtures site bash
```

Then execute a command to load data from a fixture
```sh
python3 manage.py loaddata /mnt/fixtures/judge-group-1.yaml 
```
