continue(){
    echo "###############################"
    echo "#CONTINUING DOWNLOAD FROM LIST#"
    echo "###############################"

    scriptdllist="./continuefile"
    while IFS= read -r link
    do
        wget -c "${link}"
        #echo "${link}"
        echo "${link}" >> done.log
        sed -i '1d' continuefile
        clear

    done <"$scriptdllist"

    echo continuefile >> done.log
    rm continuefile

    echo "###################"
    echo "#finished download#"
    echo "###################"
    exit 0

}

[ -f continuefile ] && continue
echo "there was no file provided"