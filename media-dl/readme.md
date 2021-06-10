# Media-DL
This shellscript is supposed to make usage of Youtube-DL easier and more efficient.  
  
## Dependencies
  - pup
  - youtube-dl
  - gnu core utils and other various default utils
  
## Supported Platforms
- 9now
- tubitv *
- netzkino **

\* partially so just the default selected season will be downloaded  
\*\* the #! must be escaped as \#\! or bash will interprete these! Also the script will download direct from this site and it won't output a link list

## How to use

- 9now 
  ```./run.sh linkToSeasonOfTvShow```
  example : ```./run.sh https://www.9now.com.au/sliders/season-1/episodes```
- tubitv 
  ``` ./run.sh linkToTvShow```
  example : ```./run.sh https://tubitv.com/series/300004676/fix-foxi```
