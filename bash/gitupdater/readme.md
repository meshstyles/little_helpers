# gitupdater

if you have a rpi with a bunch of copies of source code you can use this script to keep it up to date.
This script is mostly aimed at archivalists who want to keep current version of source code in a locally backed up form.
Add a cronjob to and it will run git pull for all subfolders of `gitdir`

## use

change variable `gitdir` to the folder with all the repos you want to keep up to date.
add a crontab and you're golden

## sample crontab

this runs every dat at 00:00
`0 0 * * * ~/.local/bin/gitupdater.sh`
