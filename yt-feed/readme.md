# YT Feed / YTF

This is a simple script that uses youtube-dl and xq to download your subscriptions as an audiofile.  
This project is mostly thought for those who just want audio for videos in browser or on a file sharing server.
It's currently layed out for apache2 webserver and you will need to create a ytf directory or modify the script. 
With minor edits you can make the script download your subscriptions as videos aswell.
The script is currently proven to run on a raspberry pi 0w which is a neat little mashine for your personal intranet.

## Dependencies
- xq / therefore also python and possibly jq
- youtube-dl / and it's dependencies
- gnu core utils and other stuff you already should have on your linux mashine

## How to subscribe
call the script itself and have a single channel ID as argument
```./ytf.sh channelid```
Please note to use the channel ID not the username itself.  

## How to use the script
Ideally you'll have the script running as a crontab, please keep in mind that it currently does not play well running as a superuser.
You can choose to create a new user for this script itself but keep in mind that it still needs sudoers permissions or edit the script so that you can run into the apache2 directory or the directory where the you want to download your new audios to.
You can also manually run the script by calling it in shell yourself.
