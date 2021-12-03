# google drive downloader

this downloader can download all files in a publically available google drive folder

## how to use

```
wget https://raw.githubusercontent.com/meshstyles/little_helpers/master/google_drive/gdrive-dl.sh
chmod +x gdrive-dl.sh
./gdrive-dl.sh "https://drive.google.com/drive/folders/somerandomid"
```

## dependencies

-   [pup](https://github.com/ericchiang/pup)
-   wget
-   curl
-   cut
-   ... and more gnu-tools (that should already be on your system )

## interesting articles

[https://medium.com/@acpanjan/download-google-drive-files-using-wget-3c2c025a8b99](https://medium.com/@acpanjan/download-google-drive-files-using-wget-3c2c025a8b99)

## error codes

-   4 missing feature

## knows issues

1. files that include any of the ways google denotes own files there will be an issue with the down.

```
 Google Drive Folder
 Google Docs
 Google Slides
 Google Forms
 Google Sheets
 Google Drawings
 Google My Maps
 Google Sites
 Google Jamboard
```

2. some types like google site, google my maps and google forms can't be downloaded because they lack a download option the links will be stored in a file
