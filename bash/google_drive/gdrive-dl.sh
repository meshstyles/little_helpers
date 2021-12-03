#!/bin/bash

link="$1"

download_regular_file(){
    # obtain token and cookie see readme for source
    confirmtoken=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=${fileid}" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')
    wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=${confirmtoken}&id=${fileid}" -O "$fname" && rm -rf /tmp/cookies.txt
}

if [[ "$link" == *"drive.google.com/drive/folders/"* ]]; then

    folderid=$(echo ${link##*drive\/folders\/} | cut -d '?' -f 1)

    page=$(curl "https://drive.google.com/drive/folders/${folderid}" \
        -H 'authority: drive.google.com' \
        -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,_/_;q=0.8,application/signed-exchange;v=b3;q=0.9' \
        -H 'accept-language: en-US,en;q=0.9,de;q=0.8' \
        -- compressed)

    list_fname_r=$(echo "$page" |  pup 'div.WYuW0e div.jGNTYb attr{aria-label}')
    list_id_r=$(echo "$page" | pup 'div.WYuW0e attr{data-id}')

    echo "====================="
    echo "-$list_fname_r-"
    echo "---------------------"
    echo $list_id_r
    echo "====================="

    #preserver ifs
    SAVEIFS=$IFS   # Save current IFS
    IFS=$'\n'      # Change IFS to new line
    list_fname_a=($list_fname_r)
    list_id_a=($list_id_r)
    IFS=$SAVEIFS

    arr_length="${#list_id_a[@]}"

    cur_folder_name=$(echo "$page" | pup "title text{}")
    cur_folder_name=$(echo "${cur_folder_name::-15}" | sed "s/[:/|]/-/g; s/ $//") 
    mkdir "$cur_folder_name"
    cd "$cur_folder_name"

    for i in $(seq 0 $arr_length)
    do
        
    	curr_fname="${list_fname_a[$i]}"
    	curr_id="${list_id_a[$i]}"

        echo "====================="
        echo "-$curr_fname-"
        echo "$curr_id"
        echo "====================="

        if [[ "$curr_fname" == *" Google Drive Folder"* ]]; then
            echo "folders are not yet supported"
        
        elif [[ "$curr_fname" == *" Google Docs"* ]]; then
            curr_fname="${curr_fname%% Google Docs*}"
            fname=$( echo "${curr_fname%%.*}.docx" | sed "s/[:/|]/-/g; s/ $//")
            wget "https://docs.google.com/document/d/${curr_id}/export?format=docx&authuser=" -O "$fname"
        
        elif [[ "$curr_fname" == *" Google Slides"* ]]; then
            curr_fname="${curr_fname%% Google Slides*}"
            fname="${curr_fname%%.*}.pptx"
            wget "https://docs.google.com/presentation/d/${curr_id}/export/pptx?authuser=" -O "$fname"

        elif [[ "$curr_fname" == *" Google Forms"* ]]; then
            echo "++++++++++++++++++++++++++++++++++++"
            echo "+ WARNING : Forms is not supported +"
            echo "+ link will be placed in directory +"
            echo "++++++++++++++++++++++++++++++++++++"

            echo "https://docs.google.com/forms/d/${curr_id}/edit?usp=sharing" >> ./links_unable_to_download.txt
        
        elif [[ "$curr_fname" == *" Google Sheets"* ]]; then
            curr_fname="${curr_fname%% Google Sheets*}"
            fname=$( echo "${curr_fname%%.*}.xlsx" | sed "s/[:/|]/-/g; s/ $//")
            wget "https://docs.google.com/spreadsheets/d/${curr_id}/export?format=xlsx&authuser=" -O "$fname"

        elif [[ "$curr_fname" == *" Google Drawings"* ]]; then
            curr_fname="${curr_fname%% Google Drawings*}"
            fname=$( echo "${curr_fname%%.*}.jpeg" | sed "s/[:/|]/-/g; s/ $//")
            wget "https://docs.google.com/drawings/d/${curr_id}/export/jpeg?authuser=" -O "$fname"
        
        elif [[ "$curr_fname" == *" Google My Maps"* ]]; then
            echo "++++++++++++++++++++++++++++++++++++"
            echo "+ WARNING :  Maps is not supported +"
            echo "+ link will be placed in directory +"
            echo "++++++++++++++++++++++++++++++++++++"

            echo "https://www.google.com/maps/d/edit?mid=${curr_id}&usp=sharing" >> ./links_unable_to_download.txt
      
        elif [[ "$curr_fname" == *" Google Sites"* ]]; then
            echo "++++++++++++++++++++++++++++++++++++"
            echo "+ WARNING : Pages is not supported +"
            echo "+   No link can be extracted atm   +"
            echo "++++++++++++++++++++++++++++++++++++"
        
        elif [[ "$curr_fname" == *" Google Jamboard"* ]]; then
            curr_fname="${curr_fname%% Google Jamboard*}"
            fname=$( echo "${curr_fname%%.*}.png" | sed "s/[:/|]/-/g; s/ $//")
            wget "https://jamboard.google.com/d/${curr_id}/export/0/0?QN=01" -O "$fname"

        else
            if [[ "$curr_id" == "" ]]; then
                echo "the id seems to be empty so this might have been all files"
            fi

            # echo "this is downloadable file"
            fileid="$curr_id"

            ## univeral extension creator
            curr_ext=$(echo $curr_fname | rev | cut -d '.' -f 1 | rev | cut -d ' ' -f 1)
            curr_fname=$(echo "${curr_fname%%.*}" | sed "s/[:/|]/-/g; s/%20/ /g; s/ $//; s/ /_/g; s/&amp;/\&/g; s/&#39;/'/g")
            fname="${curr_fname}.${curr_ext}"
            download_regular_file
        fi

    done

elif  [[ "$link" == *"drive.google.com/file/d/"* ]]; then

    echo "this function is still in development"
    exit 4

else
    echo "this link does not see to be supported yet"
    exit 4
fi
