cat<<EOF >my-project.json
{
  "project_name": "naren",
  "public": false,
  "metadata": {
    "public": "false"
  },
 "registry_id": 1 #If you need proxy project
}
EOF


curl -k -s \
        -X POST \
        -u ${ADMIN_USER}:${ADMIN_PASSWORD} \
        -H 'accept: application/json' \
        -H 'Content-Type: application/json' \
        "https://${HARBOR_URL}/api/v2.0/projects" \
        -d @my-project.json
