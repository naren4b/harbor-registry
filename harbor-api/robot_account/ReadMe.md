Build the docker image
```bash
docker build -t harbor-script:1.0.0 .
```

Create the USER
```bash
docker run -it  -e HARBOR_URL="<URL>"  -e ADMIN_USER="<USER>"  -e ADMIN_PASSWORD="<PASSWORD>"  harbor-script:1.0.0   create <USERNAME> <PROJECTNAME>
```

Refresh the Token

```bash
docker run -it  -e HARBOR_URL="<URL>"  -e ADMIN_USER="<USER>"  -e ADMIN_PASSWORD="<PASSWORD>"  harbor-script:1.0.0  refresh <USERNAME> <PROJECTNAME>
```

Delete the USER

```bash
docker run -it  -e HARBOR_URL="<URL>"  -e ADMIN_USER="<USER>"  -e ADMIN_PASSWORD="<PASSWORD>"  harbor-script:1.0.0  delete <USERNAME> <PROJECTNAME>
```
