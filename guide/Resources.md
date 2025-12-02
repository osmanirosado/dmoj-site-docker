# Resources

Manually managed resources

Copy data to `resources` directory
```shell
docker cp ~/tmp/oci25/ dmoj-site:/var/opt/lib/dmoj/resources/
```

List the content of copied directory
```shell
docker exec dmoj-site ls /var/opt/lib/dmoj/resources/oci25/
```
