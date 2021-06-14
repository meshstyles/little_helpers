echo "will download what's in youtube.list"
youtubelist = "youtube.list"
    while IFS= read -r link
       do
           youtube-dl -f bestvideo+bestaudio link
done<"youtubelist"