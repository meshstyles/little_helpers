# gathered intel

-   page can be curled
-   folders and google docs can be identified
-   normal files can be pulled with `https://drive.google.com/uc?id=${id}&export=download`

## google docs and folders

this info can be found in ``

-   `Google Drive Folder`
-   `Google Docs`
-   `Google Slides`
-   `Google Forms` no download offered
-   `Google Sheets`
-   `Google Drawings`
-   `Google My Maps` no download offered
-   `Google Sites` no download offered
-   `Google Jamboard`

other types that can be downloaded normally {some are in german here}

-   Image
-   Video
-   Audio
-   ZIP-Datei
-   Unbekanntes Format
-   PDF

the main takeaway should be is you need to assume to there is a space in the name but no period  
this solution won't work for files without file extension but they are an edge case

```
cur_ext=$(echo $curr_fname | rev | cut -d '.' -f 1 | rev | cut -d ' ' -f 1)
fname="${curr_fname%%.*}.$cur_ext"
```

## page load curl

google does not seem to block curl for downloading the page html, therefore i currently see no point in obfuscating the usage of curl through user-agent

```
curl "https://drive.google.com/drive/folders/${folderid}" \
 -H 'authority: drive.google.com' \
 -H 'accept-language: en-US,en;q=0.9,de;q=0.8' \
 --compressed"
```

## obtaining file id's

`echo $page | pup 'div.WYuW0e attr{data-id}'`  
get file IDs this thank will be turned into an array.  
from here on out we need to check what is a normal file (they can be downloaded through the normal download method) and what is a folder or google docs type of item.

## obtaining docs downloads

there is a diffrent endpoint for all of the types and variations of google documens.  
with the correct url and wget you can just directly download from here but if you desire more you can curl and look at the header.

### google docs

mime-type = docx  
`wget "https://docs.google.com/document/d/${itemid}/export?format=docx&authuser=" -O "$fname"`

### google slides

mime-type = pptx  
`wget "https://docs.google.com/presentation/d/${itemid}/export/pptx?authuser=" -O "$fname"`

### google spreadsheets

mime-type = xlsx  
`wget "https://docs.google.com/spreadsheets/d/${itemid}/export?format=xlsx&authuser=" -O "$fname"`

### google drawings

mime-type = jpg  
`wget "https://docs.google.com/drawings/d/${itemid}/export/jpeg?authuser=" -O "$fname"`

### google jamboard

mime-type = pdf  
`wget "https://jamboard.google.com/export?${itemid}&authuser=" -O "$fname"`

mime-type = png  
`wget "https://jamboard.google.com/d/${itemid}/export/0/0?QN=01" -O "$fname"`
