# Resources

Manually managed resources

Change working directory
```sh
cd dmoj
```

Use the run command to mount tmp inside a temporal container
```sh
docker compose run --rm -v ~/tmp/:/mnt/tmp/ -w /mnt/tmp/ nginx bash
```

Then move data to `resources` directory
```sh
mv /mnt/tmp/oci25/ /var/opt/lib/dmoj/resources/oci25/ 
```
