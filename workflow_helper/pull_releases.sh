#!/bin/bash
set -e

CRED="$1"
REPO="$2"

echo "Downloading release for $REPO"

release_info=$(curl -s -u $CRED 'https://api.github.com/repos/'$REPO'/releases?per_page=1')
release_fileurl=$(echo $release_info | jq -r ".[0].assets[0].url")
release_filename=$(echo $release_info | jq -r ".[0].assets[0].name")

if [[ "$release_file" == "null" ]]; then
    echo "  No release found for $REPO"
fi

echo "  Downloading release file $release_filename from $release_fileurl"
curl -L -H 'Accept: application/octet-stream' -u $CRED -o "$release_filename" "$release_fileurl"
