# Problem data

Change working directory
```sh
cd dmoj
```

Use the run command to mount `tmp` inside a temporal container
```sh
docker compose run --rm --no-deps -v ~/tmp/:/mnt/tmp/ -w /mnt/tmp/ site bash
```

Then move problem data to `problems` directory
```sh
mv /mnt/tmp/ds3/ /var/opt/lib/dmoj/problems/ 
```
