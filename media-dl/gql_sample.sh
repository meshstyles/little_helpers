#!/bin/bash

link=$1

vid_id=$(curl ${link} | pup 'a.r-1ui2xcl attr{href}' | cut -d '/' -f 3)
echo -$vid_id-

pmdext=$( curl 'https://data.netzkino.de/netzkino/graphql' -H 'Connection: keep-alive' -H 'sec-ch-ua: "Chromium";v="94", "Google Chrome";v="94", ";Not A Brand";v="99"' -H 'accept: _/_' -H 'content-type: application/json' -H 'sec-ch-ua-mobile: ?0' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36' -H 'sec-ch-ua-platform: "Windows"' -H 'Origin: https://www.netzkino.de' -H 'Sec-Fetch-Site: same-site' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Dest: empty' -H 'Referer: https://www.netzkino.de/' -H 'Accept-Language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7,zh-CN;q=0.6,zh;q=0.5' --data-raw $'{"operationName":"VideoData","variables":{"contentId":"'$vid_id'"},"extensions":{"persistedQuery":{"version":1,"sha256Hash":"07da13d28e4668828482196ead7538eda8f166f75a04d218a5c427ec787f1477"}},"query":"fragment ImageData on CmsImage {\\n  masterUrl\\n  name\\n  __typename\\n}\\n\\nfragment AudioInfo on CmsMovieContentAudioLanguageInfo {\\n  sourceLabel\\n  language\\n  languageCode\\n  representationIds\\n  isSurround\\n  isStereo\\n  type\\n  __typename\\n}\\n\\nfragment TextTrackInfo on CmsMovieContentTextLanguageInfo {\\n  sourceLabel\\n  language\\n  languageCode\\n  representationIds\\n  isForced\\n  type\\n  __typename\\n}\\n\\nquery VideoData($contentId: Guid\u0021) {\\n contentData: cmsMovieById(id: $contentId) {\\n videoSource {\\n hlsUrl\\n dashUrl\\n pmdUrl\\n **typename\\n }\\n **typename\\n }\\n}\\n"}' --compressed | jq -r '.data.contentData.videoSource.pmdUrl' )

echo "https://pmd.netzkino-seite.netzkino.de/$pmdext"
wget -c "https://pmd.netzkino-seite.netzkino.de/$pmdext"

exit 1;
