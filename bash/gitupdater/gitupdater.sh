#!/bin/bash
gitdir="/home/pi/git"

cd "${gitdir}"

ls -d */ > /tmp/dir.list
dirlist="/tmp/dir.list"
   while IFS= read -r foldername
       do
           cd "${foldername}"
           git pull
           cd ..
done <"$dirlist"