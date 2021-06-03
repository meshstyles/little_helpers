#!/bin/bash

targetfilefinal="/var/www/html/api/excluded.json"
targetfile="/tmp/jsonfinal"
tmpfilename="/tmp/jsonlitelist"

> "${targetfile}"
> "${tmpfilename}"

echo "downloading page"
curl "https://www.gamestop.de/Views/Locale/Content/Data/ExcludeList/de-list.html" | pup 'td text{}' | sed 's/Wii/WII/g' > raw.list
# for testing use this to not hammer the server more than needed
# cat index.html | pup 'td text{}' > raw.list

sed 's/\&amp;/\&/g' raw.list > tmp ; mv tmp raw.list

echo "sorting out non-games"
# I don't wanna loop through consoles.txt to get this so this needs to be updated manually
grep -iv "^DS\|^PS3\|^PS3M\|^WII\|^Wii U\|^360\|^3DS\|^PSV\|^PS4\|^Xbox One\|^Switch" raw.list > other.list

# now grep file for each console.
# attention this relies on a qwirk of this function where the last line will not be read
consolesGreper="./consoles.txt"
   while IFS= read -r console
       do
            # put matching into file
            grep -i "${console}" raw.list > "${console}.list"
            # remove matching from raw.list (strategic use for wii and wii u to not also include all wii u games with wii)
            sed -i "/${console}/d" raw.list
            # remove console demarkation from name in list file (needs better soltuion to delete leading spaces)
            sed -e "s/${console}//g" -i "${console}.list"
            sed 's/^ *//g' -i "${console}.list"
done <"$consolesGreper"

# read from each file and create a "json" object from the data
consolesJsonBuilder="./consoles.txt"
while IFS= read -r console
do
    reedConsolesLists="./${console}.list"
    while IFS= read -r entry
    do
        if [[ "$console" == "Wii U " ]]
        then 
            console="Wii U"
        fi
        echo "    {\"name\":\"${entry}\", \"console\":\"${console}\"}," >> "${tmpfilename}"
    done <"$reedConsolesLists"
done <"$consolesJsonBuilder"

othervars="./other.list"
   while IFS= read -r other
       do
        echo "    {\"name\":\"${other}\", \"console\":\"other\"}," >> "${tmpfilename}"
done <"$othervars"

#remove comma from last line
lastLine=$( tail -n 1 "${tmpfilename}" | sed 's/},/}/')
sed '$d' "${tmpfilename}"
echo "${lastLine}" >> "${tmpfilename}"

# TODO find a better solution to solve the issue of the last line not
echo "{\"games\":[" >> "${targetfile}"
cat "${tmpfilename}" >> "${targetfile}"
echo "]}" >> "${targetfile}"
sudo mv "${targetfile}" "${targetfilefinal}"
rm *.list
