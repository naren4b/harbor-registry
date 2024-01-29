project=$1 #demo
proxy_project_id=$2 #1

cat<<EOF >$project.json
{
  "project_name": "$project",
  "public": false,
  "metadata": {
    "public": "false"
  }
}
EOF


curl -k -s \
        -X POST \
        -u ${ADMIN_USER}:${ADMIN_PASSWORD} \
        -H 'accept: application/json' \
        -H 'Content-Type: application/json' \
        "https://${HARBOR_URL}/api/v2.0/projects" \
        -d @$project.json
