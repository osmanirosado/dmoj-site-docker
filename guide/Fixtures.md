# Fixtures

Change working directory
```sh
cd dmoj
```

Load data from a fixture
```shell
docker compose exec -T site python3 manage.py loaddata --format yaml - < ~/fixtures/judge-group-1.yaml
```
The file format must be specified when reading from stdin.

Dump problem record to file
```shell
docker compose exec -T site python3 manage.py dumpdata --format yaml judge.Problem --pks 5 > ~/fixtures/problem_5.yaml 
```
