# Resources

Manually managed resources

Copy data to `resources` directory
```shell
docker cp ~/tmp/oci25/ dmoj-nginx:/var/opt/lib/dmoj/resources/
```

List the content of copied directory
```shell
docker exec dmoj-nginx ls /var/opt/lib/dmoj/resources/oci25/
```
