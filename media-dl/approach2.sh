#!/bin/bash

#supply slug from after /filme/ in the url
# will be used in media dl so no bother including code now
film_id="$1"

#might be higher maintance if the query path is changed
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

# movie ext that is the missing part for the url to archive movie
echo $pmdext
