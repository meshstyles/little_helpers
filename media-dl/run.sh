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

# if [["${1}" =~ ^(https:\/\/www.joyn.de\/serien\/|https:\/\/joyn.de\/serien\/)]]; then
#     echo "Attention this will only download the preselected season since this pup is non interactive with websites"
#     curl "${1}" | pup 'div.fcxvn8-6 div div a attr{href}' | grep "serien" | sed 's|/serien/|https://www.joyn.de/serien/|g'
#     video_links="filled"
# fi

echo looper

[[ video_links -eq "filled" ]] && file_variable="${listFile}"
   while IFS= read -r link
       do
           #youtube-dl $link
           echo $link
done <"$file_variable"
