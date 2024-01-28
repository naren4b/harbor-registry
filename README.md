# harbor-registry

```bash
export HARBOR_URL=registry.127.0.0.1.nip.io
git clone https://github.com/naren4b/harbor-registry.git
cd harbor-registry
bash setup.sh
bash install.sh
kubectl wait --for=condition=ready pod -n ingress-nginx -l app.kubernetes.io/component=controller
kubectl wait --for=condition=ready pod -n registry -l app=harbor -l component=portal
```

# Setup LocalDocker client 
```bash 
URL=$HARBOR_URL
CERT_PATH=/etc/docker/certs.d/${URL}
sudo mkdir -p $CERT_PATH
sudo openssl s_client -connect ${URL}:443 -showcerts </dev/null | sed -n -e '/-.BEGIN/,/-.END/ p' > /etc/docker/certs.d/${URL}/ca.crt
sudo systemctl restart docker
# for any local URL 
echo 127.0.0.1 $URL >> /etc/hosts 
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
