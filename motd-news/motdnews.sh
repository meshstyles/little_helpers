#!/bin/dash

standard="The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
# permitted by applicable law.\n\n"

tageschaulength=$(jq -r '.tageschaulength' settings.json )

weatherLoc=$(jq '.weatherLoc' settings.json)
weatherLoc=$(echo $weatherLoc | sed 's/ /%20/g' | sed 's/"//g')
weatherapi=$(jq '.weatherapi' settings.json | sed 's/"//g')

news=""

stories=$(curl -s "https://www.tagesschau.de/api2/news/?ressort=inland"| jq '.')

for I in `seq 1 $tageschaulength`
do
    story=$(echo $stories | jq --arg index "$I" '.news[$index|tonumber]')
    title=$(echo $story | jq -r '.title')
    abstract=$(echo $story | jq -r '.firstSentence')
    news="${news}${title}\n${abstract}\n\n"
done

weather=$(curl -s "http://api.weatherapi.com/v1/current.json?key=${weatherapi}&q=${weatherLoc}" | jq ".current")
temp=$(echo $weather | jq -r '.temp_c')
cloudiness=$(echo $weather | jq -r '.condition.text')
weather=" ===WEATHER===
temperature ${temp}C | weather: ${cloudiness}\n"

sudo printf "${standard}${news}${weather}" > /etc/motd
