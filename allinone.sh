#!/bin/bash
export HARBOR_URL="registry.naren.local.com"
export ADMIN_USER=admin
export ADMIN_PASSWORD="Harbor12345"
OUTDIR=$PWD/temp
rm -rf $OUTDIR
rm -rf $HARBOR_URL.csv
mkdir -p $OUTDIR



printAllRepos() {
    while IFS= read -r line; do
        project=$(echo "$line" | cut -d'/' -f1)
        repo=$(echo "$line" | cut -d'/' -f2-)
        echo "$project,$repo" >>$HARBOR_URL.csv
    done <$1
}

getMyProjectRepositories() {
    project=$1
    repofile=$OUTDIR/${project}_repositories.txt
    rm -rf out.json
    rm -rf $repofile
    page=1
    while :; do
        URL="""https://${HARBOR_URL}/api/v2.0/projects/${project}/repositories?page=$page&page_size=100"""
        # echo $URL
        # echo "----------"
        response=$(curl -k -s \
            -X GET \
            -u ${ADMIN_USER}:${ADMIN_PASSWORD} \
            -H 'accept: application/json' \
            $URL)
        if [[ "$response" == "[]" ]]; then
            # echo "no response"
            break
        fi
        # echo response: $response
        # echo "********************"
        echo $response >>$OUTDIR/out.json
        cat $OUTDIR/out.json | jq -r '.[].name' >>$repofile
        page=$((page + 1))
    done
    if [ -e "$repofile" ] && [ -s "$repofile" ]; then
        printAllRepos $repofile
    fi

}

getMyProjects() {
    rm -rf $OUTDIR/projects.json
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
        echo $response >>$OUTDIR/projects.json
        page=$((page + 1))
    done
}

getMyProjects
cat $OUTDIR/projects.json | jq -r '.[].name' >$OUTDIR/projects.txt
projects=$(cat $OUTDIR/projects.txt)
for project in $projects; do
    # echo $project
    # echo "============"
    getMyProjectRepositories $project
done
cat $HARBOR_URL.csv
