#!/bin/bash

video_links='empty'
listFile='./list.tmp'

# needs to be changed so pup will search with variables
# 9now="w8sfks"
# tubicom="ATag"
# joynde="fcxvn8-6"

echo "${1}"

download_list(){
    [[ video_links -eq "filled" ]] || exit 1 
    file_variable="${listFile}"
    while IFS= read -r "link"
        do
            youtube-dl $link
    done <"$file_variable"

    rm "${listFile}"
}


if [[ "${1}" =~ ^(https:\/\/www.9now.com.au\/|https:\/\/9now.com.au\/) && "${1}" == *"/episodes"* ]]; then
    curl "${1}" | pup 'li.w8sfks a attr{href}' | sed -e 's/^/https:\/\/www.9now.com.au/' > "${listFile}"
    video_links="filled"
    download_list

elif [[ "${1}" =~ ^(https:\/\/www.tubitv.com\/series\/|https:\/\/tubitv.com\/series\/)  ]]; then
    echo "Attention this will only download the preselected season since this pup is non interactive with websites"
    curl "${1}" | pup 'a.ATag attr{href}' | grep "/tv-shows/" | sed 's|/tv-shows/|https://tubitv.com/tv-shows/|g' > "${listFile}"
    video_links="filled"
    download_list

elif [[ "${1}" =~ ^(https:\/\/www.netzkino.de|https:\/\/netzkino.de) ]];then
    page=$(curl "${1}")
    pmdext=$(echo "$page" | pup 'script#__NEXT_DATA__ text{}' | jq '.' | grep 'pmdUrl' | cut -d '"' -f 4)
    echo $pmdext
    wget -c "https://pmd.netzkino-seite.netzkino.de/$pmdext" || exit 1
    exit 0

else
    youtube-dl "$1"

fi 
