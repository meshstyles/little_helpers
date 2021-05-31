#!/bin/bash  

function stopnotalbum { 
    echo "this is not an album"
    exit 1;
 }

delimitera="albums/"
echo $1 | grep "${delimitera}" || stopnotalbum
PHOTOSETID=${1#*"$delimitera"};
PHOTOSETID=$(echo $PHOTOSETID | cut -d "/" -f 1)
echo $PHOTOSETID
delimiter="root.YUI_config.flickr.api.site_key = "
page=$(curl $1 | grep "${delimiter}")
APIKEY=${page#*"$delimiter"};
APIKEY=$(echo $APIKEY | cut -d "\"" -f 2)
echo $APIKEY

curl "https://api.flickr.com/services/rest?extras=url_h&per_page=5000&page=1&jump_to=&photoset_id=${PHOTOSETID}&viewerNSID=&method=flickr.photosets.getPhotos&csrf=&api_key=${APIKEY}&format=json&nojsoncallback=1" -o "./gallery.json"

# echo $gallery
for k in $( jq '.photoset.photo | keys | .[]' "./gallery.json"); do
    imageLink=$(jq -r ".photoset.photo[$k].url_h" "./gallery.json" | sed 's/\\//g' );
    imagename=$(echo $imageLink | cut -d "/" -f 4-5 | sed 's/\//-/g')
    curl "${imageLink}" -o "${imagename}"
done | column -t -s$'\t'
