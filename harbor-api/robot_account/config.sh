#!/bin/bash

echo HARBOR_VERSION $HARBOR_VERSION
echo HARBOR_URL=$HARBOR_URL
echo ADMIN_USER=$ADMIN_USER
#echo ADMIN_PASSWORD=$ADMIN_PASSWORD
generate_password() {
    local length=12
    local password

    # Generate a random string with alphanumeric characters
    password=$(head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c $length)

    # Ensure the password meets the criteria: at least one capital letter, one lowercase letter, and one digit
    while [[ ! ($password =~ [A-Z] && $password =~ [a-z] && $password =~ [0-9]) ]]; do
        password=$(head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c $length)
    done

    echo "$password"
}

create_k8s_secret() {
    local ROBOT_USERNAME=$1
    local ROBOT_PASSWORD=$2
    cat ./templates/k8s-secret-template.yaml | sed "s/{ROBOT_USERNAME}/$ROBOT_USERNAME/g" | sed "s/{ROBOT_PASSWORD}/$ROBOT_PASSWORD/g" >${ROBOT_USERNAME}-secret.yaml
    cat ${ROBOT_USERNAME}-secret.yaml

}
