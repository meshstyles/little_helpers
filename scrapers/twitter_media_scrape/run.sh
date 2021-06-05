#!/bin/sh

username="$1"
max="$2"
link="https://en.whotwi.com/${username}/tweets/media?&page="
userAgent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36 OPR/76.0.4017.177"
df="./failed-download-$username.file"
jsonfile="/tmp/index-$username.json"

mkdir "$username"
cd "$username"

> "$df"

for I in `seq 1 $max`
do
    echo "$link$I"
        
    curl --user-agent "$userAgent" "$link$I" | pup 'div.main_column ul.media_list li json{}' > "$jsonfile"
    
    for k in $( jq '. | keys | .[]' "$jsonfile"); do
        # generate link for image
        imageLink=$(jq -r ".[$k].children[0].children[0].src" "$jsonfile" | sed 's/\/\//https:\/\//');
        # echo "$imageLink"
        # postLink=$(jq -r ".[$k].children[0].href" "$jsonfile" | sed 's/\/\//https:\/\//');
        # echo $postLink
        
        # try downloading image and log on fail
        # wget -c "$imageLink" --user-agent="${userAgent}" || jq -r ".[$k].children[0].href" "$jsonfile" | sed 's/\/\//https:\/\//' >> "$df"
        wget -c "$imageLink" --user-agent="${userAgent}" || echo "$imageLink" >> 0.txt
        
    # this causes a replace of t though it should replace tabs but it's not required because of jq
    # done | column -t -s$'\t'

    done
    
done

# rm "$jsonfile"