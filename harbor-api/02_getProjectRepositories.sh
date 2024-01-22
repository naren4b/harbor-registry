#!/bin/bash

source config.sh

project=$1
echo "Get info for $project"
rm -rf out/$project
mkdir -p out/$project
page=1
while :; do
    response=$(curl -k -s \
        -X GET \
        -u ${ADMIN_USER}:${ADMIN_PASSWORD} \
        -H 'accept: application/json' \
        "https://${HARBOR_URL}/api/v2.0/projects/${project}/repositories?page=$page&page_size=100")
    if [[ "$response" == "[]" ]]; then
        break
    fi
    echo $response >>out/$project/repositories.json
    page=$((page + 1))
done

# cat out/$project/repositories.json | jq .
