# Sample Scaper

This is a sample scraper using pup to parse the web page and discord.sh to send you a notificaiton.

-   bash script
-   uses [pup](https://github.com/ericchiang/pup)
-   uses [discord.sh](https://github.com/ChaoticWeg/discord.sh/)

## how to use

    - download the file (clone the repo or curl via github raw)
    - give it permission to execute `chmod +x lety_cashback_scriaper.sh`
    - to use this specific script use `./lety_cashback_scriaper.sh "a_vendor_url" "minimum percentage" "webhookurl"`
    - ideally run it as a cronjob
    - ideally you place discord.sh into a folder on path something like `~/.local/bin` or just hardlink in the script

## dependencies

-   curl
-   [pup](https://github.com/ericchiang/pup)
-   [discord.sh](https://github.com/ChaoticWeg/discord.sh/)
    -   jq (for discord.sh)
