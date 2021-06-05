#!/bin/bash

apiurl="http://archive.org/wayback/available?url="

function downloadresult () {
    url=$(echo "$archival" | jq -r '.archived_snapshots.closest.url')
    wget $url
}

urls="./url.list"
    while IFS= read -r url
        do
            echo "$apiurl$url"
            archival=$(curl "$apiurl$url")
            echo "$archival" | grep "web.archive.org/web/" && downloadresult
done <"$urls"
