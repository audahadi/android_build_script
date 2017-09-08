#!/bin/bash

DIR_1=/home/audahadi/lineage-n

#Get file name
FILE_NAME=$(basename $DIR_1/out/target/product/$device/lineage-14.1-*.zip .zip)
FILE_NAME_2=$(echo $FILE_NAME | cut -c9-33)

MD5SUM=$(cut -c1-32 $DIR_1/out/target/product/$device/lineage-14.1-*-UNOFFICIAL-*.zip.md5sum)
TIMESTAMP=$(sed '15!d' $DIR_1/out/target/product/"$device"/system/build.prop | cut -c19-28)

URL=https://sourceforge.net/projects/android-rom-ota/files/LineageOS/"$device"/"$FILE_NAME".zip/download

JSON=$DIR_1/android_ota/lineageos/$device/api.json

#Start OTA update
sed -i '4c \      "filename": "'$FILE_NAME'",' $JSON
sed -i '5c \      "url": "'$URL'",' $JSON
sed -i '6c \      "md5sum": "'$MD5SUM'",' $JSON
sed -i '7c \      "datetime": '$TIMESTAMP',' $JSON


OTAXML=$DIR_1/android_ota/lineageos/$device.xml

sed -i '5c <Filename>'$FILE_NAME_2''$device'</Filename>' $OTAXML
sed -i '6c <RomUrl id="rom" title="Download ROM">https://sourceforge.net/projects/android-rom-ota/files/LineageOS/'$device'/'$FILE_NAME'.zip/download</RomUrl>' $OTAXML

cd /home/audahadi/lineage-n/android_ota
git add -A && git commit -am "$FILE_NAME"
git push private HEAD:lineage
cd /home/audahadi/lineage-n
#end ota xml update
