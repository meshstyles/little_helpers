#!/bin/bash

link="$1"
min_max_cashback=$(echo "$2" | sed 's/[^0-9]*//g')
# min_max_cashback="$2"
discord_webhook_url="$3"
page=$(curl "$link")
username="lety updater"
avatar_url="https://avatars.githubusercontent.com/u/29343041?v=4"


# follows scheme letyshops.com/$countrycode/shops/$retailer
retailer="${link##*shops\/}"

teaser_percentage=$(echo "$page" | pup 'span.b-shop-teaser__cash text{}' | sed 's/[^0-9]*//g')
# i don't really wanna do anything with this but i'd rather have the infrastructure ready
# other_percentages=$(echo "$page" | pup 'span.b-module-info__new-value text{}' | sed 's/[^0-9]*//g ; s/\n/,/g ')
echo "$page" > index.html


echo "$min_max_cashback - $teaser_percentage"   
if [[ "$min_max_cashback" == "" ]]; then
    echo "$min_max_cashback"
    discord.sh \
    --webhook-url="$discord_webhook_url" \
    --text "!!min percentage not correctly set!! -  max cashback ${teaser_percentage}% @${retailer}" \
    --avatar "$avatar_url" \
    --username "$username"

# when min_max_cashback < current_cashback than send message
elif [[ "$min_max_cashback" -lt "$teaser_percentage" ]]; then
    discord.sh \
    --webhook-url="$discord_webhook_url" \
    --text "max cashback ${teaser_percentage}% @${retailer}" \
    --avatar "$avatar_url" \
    --username "$username"
fi
