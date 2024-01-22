#!/bin/bash
source config.sh

page=1
while :; do
    response=$(curl -k -s \
        -X GET \
        -u ${ADMIN_USER}:${ADMIN_PASSWORD} \
        -H 'accept: application/json' \
        "https://${HARBOR_URL}/api/v2.0/projects?page=$page&page_size=100")
    if [[ "$response" == "[]" ]]; then
        break
    fi
    echo $response >>out/projects.json
    page=$((page + 1))
done

echo "Find projects list at out/projects.txt"
cat out/projects.json | jq -r '.[].name' >out/projects.txt
