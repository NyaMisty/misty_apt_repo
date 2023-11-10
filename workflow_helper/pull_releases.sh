#!/bin/bash
set -e

CRED="$1"
REPO="$2"

echo "Downloading release for $REPO"

release_info=$(curl -s -u $CRED 'https://api.github.com/repos/'$REPO'/releases?per_page=1')

for i in {0..10}; do # max 10 artifacts
    release_fileurl=$(echo "$release_info" | jq -r ".[0].assets[$i].url")
    release_filename=$(echo "$release_info" | jq -r ".[0].assets[$i].name")

    if [[ "$release_fileurl" == "null" ]]; then
	if [ $i -eq 0 ]; then
	    echo "  No release found for $REPO"
	fi
	break
    fi

    if ! [[ $release_filename == *.deb ]]; then
        continue
    fi

    echo "  Downloading release file $release_filename from $release_fileurl"
    curl -L -H 'Accept: application/octet-stream' -u $CRED -o "$release_filename" "$release_fileurl"
done
