# this is a deepsearch variant of which is very diffrent and uses sha1sum instead of crc32

#create needed search.sh
echo "hash=\$(sha1sum \$1)" > search.sh
echo "echo \$hash>> list.txt" >> search.sh
echo "echo \$hash | awk '{ print \$1 }' >> crc.txt" >> search.sh

>list.txt
>crc.txt
>dupes.txt

find . -type f -name "*.txt" -exec ./search.sh "{}" \;

sort crc.txt > tmp; uniq -d tmp > crc.txt

crclist="./crc.txt"
    while IFS= read -r line
       do
            echo "______${line}________" >> dupes.txt
            grep "${line}" list.txt >> dupes.txt
done<"$crclist"

#remove unneeded files
rm search.sh            #remove search.sh
rm crc.txt list.txt     #remove temporary files
