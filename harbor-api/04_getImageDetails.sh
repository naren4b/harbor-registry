#!/bin/bash
source config.sh

file=out/$1/repositories.csv

getRepoDetails() {
    project=$1
    repo=$2
    rm -rf out/$project/$repo
    mkdir -p out/$project/$repo
    page=1
    while :; do
        URL="""https://${HARBOR_URL}/api/v2.0/projects/${project}/repositories/${repo}/artifacts?page_size=100&page=${page}"""
        response=$(curl -k -s \
            -X GET \
            -u ${ADMIN_USER}:${ADMIN_PASSWORD} \
            -H 'accept: application/json' \
            $URL)
        if [[ "$response" == "[]" ]]; then

            break
        fi
        echo $response | jq . >out/$project/$repo/response.json
        cat out/$project/$repo/response.json | jq -r '.[] | "\(.addition_links.build_history.href),\(.tags[0].name),\(.size)"' | sed 's,/additions/build_history,,g' | sed 's,/api/v2.0/projects/,,g' >>out/$HARBOR_URL-size.csv
        cat out/$project/$repo/response.json | jq -r '.[] | "\(.addition_links.build_history.href),\(.tags[0].name),\(.size)"' | sed 's,/additions/build_history,,g' | sed 's,/api/v2.0/projects/,,g' >>out/$project/$repo/size.csv
        page=$((page + 1))
    done
}

if [ -e "$file" ] && [ -s "$file" ]; then
    while IFS=, read -r project repo; do
        echo "Fetching for $project/$repo"
        getRepoDetails $project "${repo//\//%2F}"
    done <"$file"
else
    if [ ! -e "$file" ]; then
        echo "Error: $file does not exist."
    elif [ ! -s "$file" ]; then
        echo "Error: $file is empty."
    fi
fi
