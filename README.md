# harbor-registry
```
mkdir -p /etc/docker/certs.d/registry.naren.local.com
sudo mkdir -p /etc/docker/certs.d/registry.naren.local.com
sudo cp ca.crt /etc/docker/certs.d/registry.naren.local.com/
```


```
docker tag nginx:latest registry.naren.local.com/demo/nginx:latest
docker push registry.naren.local.com/demo/nginx:latest
```
