#!/bin/bash

apiurl="http://archive.org/wayback/available?url="
searchedurl="${1}"

function downloadresult () {
    url=$(echo "$archival" | jq -r '.archived_snapshots.closest.url')
    mkdir "${searchedurl/https:\/\//}"
    cd "${searchedurl/https:\/\//}"
    wget $url
    cd ..
}

echo "$apiurl$searchedurl"
archival=$(curl "$apiurl$searchedurl")
echo "$archival" | grep "web.archive.org/web/" && downloadresult

