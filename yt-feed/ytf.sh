#!/bin/bash

#shell variables
preserved=2
ytfpath="/var/www/html/ytf"
ytrss="https://www.youtube.com/feeds/videos.xml?channel_id="

cd "${ytfpath}"

if [[ $# -eq 1 ]]; then
    grep "${1}" "./subscriptions.txt" && exit 0;
    echo ${1} | sudo tee -a ./subscriptions.txt
    sudo mkdir "${1}"
    cd "${1}"
    sudo touch old.xml
    exit 0;
fi

subs="./subscriptions.txt"
    while IFS= read -r sub
       do
            cd "${sub}"
            rss="${ytrss}${sub}"
            sudo curl "${rss}" -o new.xml
            if cmp "old.xml" "new.xml"
            then
                #remove new xml because the files are the same
                sudo rm "./new.xml"
            else
                #################CODE##############
                sudo mv new.xml old.xml
                name=$(cat old.xml | xq -r '.feed.title')
                # there is something new
                # download the three latest episodes
                # download will just "fail" on episodes that are already downloaded

                for k in $(seq 0 $preserved);
                do
                    link=$(cat old.xml | xq -r --arg index $k '.feed.entry[$index | tonumber].link."@href"')
                    ext=$(cat old.xml | xq -r --arg index $k '.feed.entry[$index | tonumber]."yt:videoId"')
		    echo $ext >> /tmp/ytf-save.list
                    sudo youtube-dl -f 'bestaudio[ext=m4a]' $link

                done;
                
                ls >> /tmp/ytf-remove.list
		sed -i '/old.xml/d' /tmp/ytf-remove.list

                save="/tmp/ytf-save.list"
                   while IFS= read -r line
                       do
                        sed -i "/"$line"/d" /tmp/ytf-remove.list
                done <"$save"

                remlist="/tmp/ytf-remove.list"
                   while IFS= read -r filename
                       do
			       echo "${filename}"
                           sudo rm "${filename}"
                done <"$remlist"

                sudo rm /tmp/ytf-save.list /tmp/ytf-remove.list
		#generate static page from file.xml (optional I'll use apache htaccess instead)
            fi
	    cd ..
done <"$subs"
