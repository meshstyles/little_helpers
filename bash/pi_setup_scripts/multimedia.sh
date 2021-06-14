sudo apt install -y ffmpeg
# using two instances of youtube-dl so since they sometimes are not equivalent
sudo apt install -y youtube-dl
sudo apt install -y python
#actually doesn't seem to work as well as bashalias
echo "youtube-dl -f 'bestaudio[ext=m4a]' \$1" > ~/.local/bin/audio
sudo chmod 700 ~/.local/bin/audio