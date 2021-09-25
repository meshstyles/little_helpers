# Archive tools

1. archive_dl.sh

This tool downloads all files (except auto generated files by archive.org) and retains the folder structure

-   how to use
    `./archive_dl.sh "url"`

2. waybackmashine.sh

This tool is here to donwload the html of the latest archive snapshot.
Also can be used to download the latest snapshot of an archived file like website pictures.

-   how to use

`./waybackmashine.sh "url"`

3. archviedtails.sh ( depricated)

This tool is getting all links from an archive org entry.
Can be really useful if you want the entire thing.
All the files will that be downloaded into a newly created folder.
For convience you may pass a "second" argument with the file extension you want,
please note that this means only one extension will be excepted at a time.

-   hot to use
    `./archivedetails.sh "url"`  
    `./archivedetails.sh "url" "pdf"`

## dependencies

-   jq

### dependencies most people already have

-   wget
-   curl
-   bash (in a recent-ish version)
-   grep
