# harbor-registry

```bash
HARBOR_URL=registry.127.0.0.1.nip.io
git clone https://github.com/naren4b/harbor-registry.git
cd harbor-registry
bash setup.sh
bash install.sh
```

# Load an image

```bash
docker login registry.127.0.0.1.nip.io -u admin -p Harbor12345
docker pull nginx:latest
docker tag nginx:latest $HARBOR_URL/library/nginx:latest
docker push $HARBOR_URL/library/nginx:latest
```

# Check the image size through harbor api

```bash
cd harbor-api
bash 01_getProjects.sh
bash run.sh out/projects.txt
cat out/$HARBOR_URL-size.csv
```
