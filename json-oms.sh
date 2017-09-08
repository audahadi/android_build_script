#!/bin/bash

DIR_1=/home/audahadi/lineage-n

#Get file name
FILE_NAME=$(basename $DIR_1/out/target/product/$device/lineage-14.1-*.zip .zip)

MD5SUM=$(cut -c1-32 $DIR_1/out/target/product/$device/lineage-14.1-*.zip.md5sum)
TIMESTAMP=$(sed '15!d' $DIR_1/out/target/product/"$device"/system/build.prop | cut -c19-28)

URL=https://sourceforge.net/projects/android-rom-ota/files/LineageOS-OMS/"$device"/"$FILE_NAME".zip/download

JSON=$DIR_1/android_ota/lineage-oms/$device/api.json

#Start OTA update
sed -i '4c \      "filename": "'$FILE_NAME'",' $JSON
sed -i '5c \      "url": "'$URL'",' $JSON
sed -i '6c \      "md5sum": "'$MD5SUM'",' $JSON
sed -i '7c \      "datetime": '$TIMESTAMP',' $JSON

cd /home/audahadi/lineage-n/android_ota
git add -A && git commit -am "$FILE_NAME"
git push private HEAD:lineage
cd /home/audahadi/lineage-n
#end ota xml update
