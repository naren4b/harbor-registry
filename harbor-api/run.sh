#!/bin/bash

source config.sh

set -e

check() {
    project=$1
    response=$(curl -k -s \
        -X GET \
        -u ${ADMIN_USER}:${ADMIN_PASSWORD} \
        -H 'accept: application/json' \
        "https://${HARBOR_URL}/api/v2.0/projects/${project}/repositories?page=1&page_size=100")
    if [[ "$response" == *"UNAUTHORIZED"* && "$response" == *"unauthorized"* ]]; then
        echo HARBOR_URL=$HARBOR_URL
        echo ADMIN_USER=$ADMIN_USER
        echo ADMIN_PASSWORD=$ADMIN_PASSWORD
        echo "ERROR : Wrong Credentials or No Access "
        exit 1
    else

        echo "Report Script is running for "
        echo HARBOR_URL=$HARBOR_URL
        echo ADMIN_USER=$ADMIN_USER
        echo "----------------------"
        echo

    fi
}

mkdir -p out

file=$1

if [ -e "$file" ] && [ -s "$file" ]; then
    projects=$(cat $file)
    for project in $projects; do
        # echo $project
        check $project
        bash $PWD/02_getProjectRepositories.sh $project
        bash $PWD/03_getRepositoryDetails.sh $project
        bash $PWD/04_getImageDetails.sh $project
        echo "Done."
        mv out "$(date +"%Y%m%d_%H%M%S")"
        exit
    done
else

    if [ ! -e "$file" ]; then
        echo "Error: projects.txt $file does not exist."
        exit
    elif [ ! -s "$file" ]; then
        echo "Error: projects.txt $file is empty."
        exit
    fi
    echo "Help !!! "
    echo "Run this script(./01_getProjects.sh) to get the list of projects in registry."
fi
