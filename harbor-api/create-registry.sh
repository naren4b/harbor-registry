cat<<EOF >my-registry.json
{
  "id": 0,
  "url": "demo.goharbor.io",
  "name": "goharbor",
  "credential": {
    "type": "basic",
    "access_key": "demo",
    "access_secret": "demo123"
  },
  "type": "harbor",
  "insecure": true,
  "description": "Demo harbor account",
  "status": "string",
  "creation_time": "2024-01-28T02:10:19.389Z",
  "update_time": "2024-01-28T02:10:19.389Z"
}
EOF

curl -k -s \
        -X POST \
        -u ${ADMIN_USER}:${ADMIN_PASSWORD} \
        -H 'accept: application/json' \
        -H 'Content-Type: application/json' \
        "https://${HARBOR_URL}/api/v2.0/registries" \
        -d @my-registry.json

        
