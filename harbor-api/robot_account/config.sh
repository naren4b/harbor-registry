#!/bin/bash

echo HARBOR_VERSION $HARBOR_VERSION
LOG_SENSITIVITY_ENABLED="${LOG_SENSITIVITY_ENABLED:-true}"
echo LOG_SENSITIVITY_ENABLED $LOG_SENSITIVITY_ENABLED
echo HARBOR_URL=$HARBOR_URL
if [ "$LOG_SENSITIVITY_ENABLED" == "false" ]; then
    echo ADMIN_USER=$ADMIN_USER
    echo ADMIN_PASSWORD=$ADMIN_PASSWORD

fi

generate_password() {
    local length=12
    local password

    # Generate a random string with alphanumeric characters
    password=$(head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c $length)

    # Ensure the password meets the criteria: at least one capital letter, one lowercase letter, and one digit
    while [[ ! ($password =~ [A-Z] && $password =~ [a-z] && $password =~ [0-9]) ]]; do
        password=$(head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c $length)
    done
    printf "%s" "$password"
    if [ "$LOG_SENSITIVITY_ENABLED" == "false" ]; then
        echo "$password"
    fi
}

create_k8s_secret() {

    local SECRET_NAME=$1
    local ROBOT_USERNAME=$2
    local ROBOT_PASSWORD=$3
    if [ "$LOG_SENSITIVITY_ENABLED" == "false" ]; then
        echo create_k8s_secret $ROBOT_USERNAME $ROBOT_PASSWORD
    fi
    cat ./templates/k8s-secret-template.yaml | sed "s/{SECRET_NAME}/$SECRET_NAME/g" | sed "s/{ROBOT_USERNAME}/$ROBOT_USERNAME/g" | sed "s/{ROBOT_PASSWORD}/$ROBOT_PASSWORD/g" >${SECRET_NAME}-secret.yaml
    if [ "$LOG_SENSITIVITY_ENABLED" == "false" ]; then
        echo
        cat ${SECRET_NAME}-secret.yaml
        echo
    fi

}
