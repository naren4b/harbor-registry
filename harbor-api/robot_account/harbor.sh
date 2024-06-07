#!/bin/bash

OP=$1
USERNAME=$2
PROJECTNAME=$3
ROBOT_USERNAME=$USERNAME-$PROJECTNAME

USER_ID=""

print_error() {
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    echo
    echo -e "${RED} $MSG ${NC}"
    echo "Exit status: $curl_exit_status"
    echo "HTTP status code: $http_code"
    exit

}

echo Action: $OP ROBOT_USERNAME $ROBOT_USERNAME USERNAME: $USERNAME PROJECTNAME: $PROJECTNAME
source config.sh

get_action() {
    echo "Get User Id for ROBOT_USERNAME: $ROBOT_USERNAME, PROJECTNAME: $PROJECTNAME"
    list_action $USERNAME $PROJECTNAME
    USER_ID=$(cat response.json | jq -r .[0].id)
    if [[ $USER_ID -eq "" ]]; then
        MSG="User Id Not Found Failed !"
        print_error "1" "404" $MSG
    else
        echo "User $USER_ID Found !"
    fi
}
# Function for create action
create_action() {
    echo "Create User ROBOT_USERNAME: $ROBOT_USERNAME, PROJECTNAME: $PROJECTNAME"
    cat ./templates/user-template.json | sed "s/{USERNAME}/$ROBOT_USERNAME/g" | sed "s/{PROJECTNAME}/$PROJECTNAME/g" | sed "s/{ACTION}/create_action/g" >user.json
    curl -k -s -X 'POST' \
        https://$HARBOR_URL/api/v2.0/robots \
        -H 'accept: application/json' \
        -H 'X-Request-Id: 1' \
        -H 'Content-Type: application/json' \
        -u ${ADMIN_USER}:${ADMIN_PASSWORD} \
        -d @user.json \
        -o response.json -w "%{http_code}" >http_code.txt

    curl_exit_status=$?
    http_code=$(<http_code.txt)

    if [[ $curl_exit_status -eq 0 && $http_code -eq 201 ]]; then
        echo "User Created successfully"
        if [ "$LOG_SENSITIVITY_ENABLED" == "false" ]; then
            cat response.json | jq -r .
        fi
    else
        MSG="User Creation Failed !"
        print_error $curl_exit_status $http_code $MSG
    fi
}

# Function to handle refresh action
refresh_action() {
    echo "Refresh Token for ROBOT_USERNAME: $ROBOT_USERNAME, PROJECTNAME: $PROJECTNAME"
    get_action $USERNAME $PROJECTNAME
    local PASSWORD=$(generate_password)
    echo ID: $USER_ID 
    cat ./templates/password-template.json | sed "s/{PASSWORD}/$PASSWORD/g" >password.json
    curl -k -s -X 'PATCH' \
        https://$HARBOR_URL/api/v2.0/robots/$USER_ID \
        -H 'accept: application/json' \
        -H 'X-Request-Id: 1' \
        -H 'Content-Type: application/json' \
        -u ${ADMIN_USER}:${ADMIN_PASSWORD} \
        -d @password.json \
        -o response.json -w "%{http_code}" >http_code.txt

    curl_exit_status=$?
    http_code=$(<http_code.txt)
    echo $http_code
    if [[ $curl_exit_status -eq 0 && $http_code -eq 200 ]]; then
        echo "User $username password refreshed!"
        create_k8s_secret $ROBOT_USERNAME $(echo -n $ROBOT_USERNAME | base64) $(echo -n $PASSWORD | base64)
    else
        MSG="User $username Token Refreshed Failed !"
        print_error $curl_exit_status $http_code $MSG
    fi

}

# Function to handle delete action
delete_action() {
    echo "Delete ROBOT_USERNAME: $ROBOT_USERNAME, PROJECTNAME: $PROJECTNAME"
    get_action $USERNAME $PROJECTNAME
    curl -k -s -X 'DELETE' \
        https://$HARBOR_URL/api/v2.0/robots/$USER_ID \
        -H 'accept: application/json' \
        -H 'X-Request-Id: 1' \
        -H 'Content-Type: application/json' \
        -u ${ADMIN_USER}:${ADMIN_PASSWORD} \
        -o response.json -w "%{http_code}" >http_code.txt

    curl_exit_status=$?
    http_code=$(<http_code.txt)
    if [[ $curl_exit_status -eq 0 && $http_code -eq 200 ]]; then
        echo "User id=$USER_ID Deleted ! "
    else
        MSG="User id=$USER_ID Deletion Failed !"
        print_error $curl_exit_status $http_code $MSG
    fi

}

# Function to handle delete action
list_action() {
    echo "List ROBOT_USERNAME: $ROBOT_USERNAME, PROJECTNAME: $PROJECTNAME"
    curl -k -s -X 'GET' \
        "https://$HARBOR_URL/api/v2.0/robots?q=name%3D$ROBOT_USERNAME&page=1&page_size=10" \
        -H 'accept: application/json' \
        -H 'X-Request-Id: 1' \
        -H 'Content-Type: application/json' \
        -u ${ADMIN_USER}:${ADMIN_PASSWORD} \
        -o response.json -w "%{http_code}" >http_code.txt

    curl_exit_status=$?
    http_code=$(<http_code.txt)
    if [[ $curl_exit_status -eq 0 && $http_code -eq 200 ]]; then
        echo "User Details Found !"
        if [ "$LOG_SENSITIVITY_ENABLED" == "false" ]; then
            cat response.json | jq .
        fi
    else
        MSG="list_action  Failed !"
        print_error $curl_exit_status $http_code $MSG
    fi

}

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 {refresh|create|delete|list|get} username projectname"
    exit 1
fi

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
    echo "Usage: $0 {refresh|create|delete|list|get} username projectname"
    exit 1
    ;;
esac
