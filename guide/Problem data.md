# Problem data

Manually managed problem data

Copy problem data to `problems` directory
```shell
docker cp ~/tmp/ds3/ dmoj-site:/var/opt/lib/dmoj/problems/
```

List the content of problem data directory
```shell
docker exec dmoj-site ls /var/opt/lib/dmoj/problems/ds3/
```
