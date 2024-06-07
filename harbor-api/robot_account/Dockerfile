FROM bash:latest
RUN apk add --no-cache bash jq curl
COPY harbor.sh config.sh ./ 
COPY ./templates/* ./templates/
ENV HARBOR_URL="registry.local.com"
ENV ADMIN_USER="admin"
ENV ADMIN_PASSWORD="secretpassword"
ENV HARBOR_VERSION="v2.10.0-6abb4eab"
ENTRYPOINT ["bash","harbor.sh"]

