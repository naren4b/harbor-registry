#!/bin/bash

# Function to print usage information
source config.sh

get_action() {
    list_action $USERNAME $PROJECTNAME
    echo $(cat response.json | jq -r .id)
}
# Function for create action
create_action() {
    cat ./templates/user-template.json | sed "s/{USERNAME}/$ROBOT_USERNAME/g" | sed "s/{PROJECTNAME}/$PROJECTNAME/g" >user.json
    curl -k -s -X 'POST' \
        https://$HARBOR_URL/api/v2.0/robots \
        -H 'accept: application/json' \
        -H 'X-Request-Id: 1' \
        -H 'Content-Type: application/json' \
        -u ${ADMIN_USER}:${ADMIN_PASSWORD} \
        -d @user.json >response.json
    cat response.json | jq -r .
}

# Function to handle refresh action
refresh_action() {
    ID=$(get_action)
    local PASSWORD=$(generate_password)
    echo ID: $ID PASSWORD: $PASSWORD
    cat ./templates/password-template.json | sed "s/{PASSWORD}/$PASSWORD/g" >password.json
    curl -k -s -X 'PATCH' \
        https://$HARBOR_URL/api/v2.0/robots/$ID \
        -H 'accept: application/json' \
        -H 'X-Request-Id: 1' \
        -H 'Content-Type: application/json' \
        -u ${ADMIN_USER}:${ADMIN_PASSWORD} \
        -d @password.json >response.json

    echo "User $username password refreshed ! "
    create_k8s_secret $(echo -n $ROBOT_USERNAME | base64) $(echo -n $PASSWORD | base64)
}

# Function to handle delete action
delete_action() {
    ID=$(get_action)
    curl -k -s -X 'DELETE' \
        https://$HARBOR_URL/api/v2.0/robots/$ID \
        -H 'accept: application/json' \
        -H 'X-Request-Id: 1' \
        -H 'Content-Type: application/json' \
        -u ${ADMIN_USER}:${ADMIN_PASSWORD}

    echo "User id=$ID Deleted ! "
}

# Function to handle delete action
list_action() {
    curl -k -s -X 'GET' \
        "https://$HARBOR_URL/api/v2.0/robots?q=name%3D$ROBOT_USERNAME&page=1&page_size=10" \
        -H 'accept: application/json' \
        -H 'X-Request-Id: 1' \
        -H 'Content-Type: application/json' \
        -u ${ADMIN_USER}:${ADMIN_PASSWORD} >response.json
    cat response.json | jq -r .
}

OP=$1
USERNAME=$2
PROJECTNAME=$3
ROBOT_USERNAME=$USERNAME-$PROJECTNAME
echo ROBOT_USERNAME $ROBOT_USERNAME USERNAME: $USERNAME PROJECTNAME: $PROJECTNAME

# Main script
case "$OP" in
create)
    create_action "$USERNAME" "$PROJECTNAME"
    ;;
list)
    list_action "$USERNAME" "$PROJECTNAME"
    ;;
refresh)
    refresh_action "$USERNAME" "$PROJECTNAME"
    ;;
get)
    get_action "$USERNAME" "$PROJECTNAME"
    ;;
delete)
    delete_action "$USERNAME" "$PROJECTNAME"
    ;;
*)
    echo "Usage: $0 {create|delete|list|get} <username> <projectname>"
    exit 1
    ;;
esac
