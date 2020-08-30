#!/bin/dash

# call like ./run.sh filetype

ls  *.$1 >  files.list

filename="./files.list"
    while IFS= read -r linevar
       do
            echo ${linevar} >> crc32.list
            crc32 "${linevar}" >> crc32.list
done<"$filename"

rm files.list