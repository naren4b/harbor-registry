#!/bin/bash
cat out/$1/repositories.json | jq -r '.[].name' >out/repos.txt

while IFS= read -r line; do
    project=$(echo "$line" | cut -d'/' -f1)
    repo=$(echo "$line" | cut -d'/' -f2-)
    echo "$project,$repo" >>out/$1/repositories.csv
done <out/repos.txt
