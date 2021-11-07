#!/bin/bash

video_links='empty'
listFile='./list.tmp'

# needs to be changed so pup will search with variables
# 9now="w8sfks"
# tubicom="ATag"
# joynde="fcxvn8-6"

echo "${1}"

if [[ "${1}" =~ ^(https:\/\/www.9now.com.au\/|https:\/\/9now.com.au\/) && "${1}" == *"/episodes"* ]]; then
    curl "${1}" | pup 'li.w8sfks a attr{href}' | sed -e 's/^/https:\/\/www.9now.com.au/' > "${listFile}"
    video_links="filled"
fi

if [[ "${1}" =~ ^(https:\/\/www.tubitv.com\/series\/|https:\/\/tubitv.com\/series\/)  ]]; then
    echo "Attention this will only download the preselected season since this pup is non interactive with websites"
    curl "${1}" | pup 'a.ATag attr{href}' | grep "/tv-shows/" | sed 's|/tv-shows/|https://tubitv.com/tv-shows/|g' > "${listFile}"
    video_links="filled"
fi

if [[ "${1}" =~ ^(https:\/\/www.netzkino.de|https:\/\/netzkino.de) ]];then
    
    film_id=$(echo "${1}" | sed 's/https:\/\/www.netzkino.de\/filme\///' | sed 's/\///')
    pmdext=$(curl "https://data.netzkino.de/netzkino/graphql?operationName=MovieDetails&variables=%7B%22movieId%22%3A%22$film_id%22%2C%22externalId%22%3A%22$film_id%22%7D&extensions=%7B%22persistedQuery%22%3A%7B%22version%22%3A1%2C%22sha256Hash%22%3A%220c851312c3b1c70912c6164633dcbc632401d59f1f61f69754bb24a4993da54d%22%7D%7D" \
        -H 'Connection: keep-alive' \
        -H 'sec-ch-ua: "Chromium";v="94", "Google Chrome";v="94", ";Not A Brand";v="99"' \
        -H 'accept: */*' \
        -H 'content-type: application/json' \
        -H 'sec-ch-ua-mobile: ?0' \
        -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36' \
        -H 'sec-ch-ua-platform: "Windows"' \
        -H 'Origin: https://www.netzkino.de' \
        -H 'Sec-Fetch-Site: same-site' \
        -H 'Sec-Fetch-Mode: cors' \
        -H 'Sec-Fetch-Dest: empty' \
        -H 'Referer: https://www.netzkino.de/' \
        -H 'Accept-Language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7,zh-CN;q=0.6,zh;q=0.5' \
        --compressed | jq -r '.data.movieBySlug.nodes[0].videoSource.pmdUrl')
    if [[ "$pmdext" == "null"* ]];then 
        echo "the link could not be retrieved"
        exit 1
    fi
    wget -c "https://pmd.netzkino-seite.netzkino.de/$pmdext" || exit 1
    exit 0
fi 

echo looper

[[ video_links -eq "filled" ]] && file_variable="${listFile}"
   while IFS= read -r link
       do
           youtube-dl $link
done <"$file_variable"
