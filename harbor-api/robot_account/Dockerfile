# Use the minimal Alpine base image
FROM bash:latest
RUN apk add --no-cache bash jq curl


# Copy the script and related files into the Docker image
COPY harbor.sh config.sh user-template.json password-template.json ./

ENV HARBOR_URL="registry.local.com"
ENV ADMIN_USER="admin"
ENV ADMIN_PASSWORD="secretpassword"
ENV HARBOR_VERSION="v2.10.0-6abb4eab"

# Make the script executable
RUN chmod +x harbor.sh


# Define the entry point for the Docker container
ENTRYPOINT ["./harbor.sh"]
