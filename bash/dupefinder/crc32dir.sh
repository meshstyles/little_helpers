ls *.mp4 > dir.txt
>list.txt
>crc.txt
>dupes.txt
dirfile="./dir.txt"
    while IFS= read -r line
       do
            crc=$(crc32 ${line})
            echo ${crc} >> crc.txt
            echo "${crc} -- ${line} " >> list.txt
done<"$dirfile"

sort crc.txt > tmp; uniq -d tmp > crc.txt
sort list.txt > tmp ; mv tmp list.txt

crclist="./crc.txt"
    while IFS= read -r line
       do
            echo "______${line}________" >> dupes.txt
            grep "${line}" list.txt >> dupes.txt
done<"$crclist"
            echo "______________________" >> dupes.txt

rm crc.txt list.txt
rm dir.txt 