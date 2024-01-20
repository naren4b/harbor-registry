#!/bin/bash

file=$1

export HARBOR_URL="registry.local"
export ADMIN_USER=admin
export ADMIN_PASSWORD="Harbor12345"
OUTDIR=$PWD/temp
rm -rf $OUTDIR
mkdir -p $OUTDIR

getRepoDetails() {
    project=$1
    repo=$2
    page=1
    while :; do
        URL="""https://${HARBOR_URL}/api/v2.0/projects/${project}/repositories/${repo}/artifacts?page_size=100&page=${page}"""
        # echo curl -k -s -X GET -u ${ADMIN_USER}:${ADMIN_PASSWORD} -H 'accept: application/json' $URL
        response=$(curl -k -s \
            -X GET \
            -u ${ADMIN_USER}:${ADMIN_PASSWORD} \
            -H 'accept: application/json' \
            $URL)
        if [[ "$response" == "[]" ]]; then
            echo "done"
            break
        fi
        echo $response | jq . >response.json
        out=$(cat response.json | jq -r '.[] | "\(.addition_links.build_history.href),\(.tags[0].name),\(.size)"' | sed 's,/additions/build_history,,g' | sed 's,/api/v2.0/projects/,,g')
        # echo $out
        echo $out >>$HARBOR_URL-size.csv
        page=$((page + 1))
    done

}

if [ -e "$file" ] && [ -s "$file" ]; then
    while IFS=, read -r project repo; do
        echo "Project: $project"
        echo "Repo: $repo"
        echo "---"
        getRepoDetails $project "${repo//\//%2F}"
        # exit
    done <"$file"
else
    if [ ! -e "$file" ]; then
        echo "Error: $file does not exist."
    elif [ ! -s "$file" ]; then
        echo "Error: $file is empty."
    fi
fi
