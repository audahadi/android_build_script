#!/bin/bash

DIR_1=/home/audahadi/lineage-n
DATE=$(date +%Y%m%d)

repo forall device/asus/Z010D device/asus/Z00ED device/asus/Z00RD -c "git reset --hard HEAD"

cp -f /home/audahadi/.android-certs/* /home/audahadi/lineage-n/build/target/product/security


if [ "$device" == "Z010D" ]
then
sed -i  -e '$a\\' $DIR_1/device/asus/$device/system.prop
sed -i  -e '$a\#Updater override' $DIR_1/device/asus/$device/system.prop
sed -i -e '$a\cm.updater.uri=https://raw.githubusercontent.com/audahadi/android_ota/lineage/lineageos/Z010D/api.json' $DIR_1/device/asus/$device/system.prop
fi

if [ "$device" == "Z00ED" ]
then
sed -i  -e '$a\\' $DIR_1/device/asus/$device/system.prop
sed -i  -e '$a\#Updater override' $DIR_1/device/asus/$device/system.prop
sed -i -e '$a\cm.updater.uri=https://raw.githubusercontent.com/audahadi/android_ota/lineage/lineageos/Z00ED/api.json' $DIR_1/device/asus/$device/system.prop
fi

if [ "$device" == "Z00RD" ]
then
sed -i  -e '$a\\' $DIR_1/device/asus/$device/system.prop
sed -i  -e '$a\#Updater override' $DIR_1/device/asus/$device/system.prop
sed -i -e '$a\cm.updater.uri=https://raw.githubusercontent.com/audahadi/android_ota/lineage/lineageos/Z00RD/api.json' $DIR_1/device/asus/$device/system.prop
fi

wait
. build/envsetup.sh
export USE_CCACHE=1
export CCACHE_DIR=/home/ccache/audahadi
ccache -M 50G
lunch lineage_$device-userdebug
export DEFAULT_SYSTEM_DEV_CERTIFICATE=$DIR_1/build/target/product/security/releasekey
export PRODUCT_DEFAULT_DEV_CERTIFICATE=$DIR_1/build/target/product/security/releasekey
export PRODUCT_OTA_PUBLIC_KEYS=$DIR_1/build/target/product/security/releasekey
mka bacon -j8

#Get file name
FILE_NAME=$(basename $DIR_1/out/target/product/$device/lineage-14.1-*.zip .zip)
FILE_NAME_2=$(echo $FILE_NAME | cut -c9-33)

MD5SUM=$(cut -c1-32 $DIR_1/out/target/product/Z010D/lineage-14.1-*-UNOFFICIAL-*.zip.md5sum)
TIMESTAMP=$(sed '15!d' $DIR_1/out/target/product/"$device"/system/build.prop | cut -c19-28)

URL=https://sourceforge.net/projects/android-rom-ota/files/LineageOS/"$device"/"$FILE_NAME".zip/download

JSON=$DIR_1/android_ota/lineageos/$device/api.json

#Start OTA update
sed -i '1c {' $JSON
sed -i '2c \    "response": [' $JSON
sed -i '3c \    {' $JSON
sed -i '4c \      "filename": "'$FILE_NAME'",' $JSON
sed -i '5c \      "url": "'$URL'",' $JSON
sed -i '6c \      "md5sum": "'$MD5SUM'",' $JSON
sed -i '7c \      "datetime": '$TIMESTAMP',' $JSON
sed -i '8c \      "romtype": "unofficial",' $JSON
sed -i '9c \      "version": "14.1"' $JSON
sed -i '10c \    }' $JSON
sed -i '11c \  ]' $JSON
sed -i '12c }' $JSON


OTAXML=$DIR_1/android_ota/lineageos/$device.xml

sed -i '5c <Filename>'$FILE_NAME_2''$device'</Filename>' $OTAXML
sed -i '6c <RomUrl id="rom" title="Download ROM">https://sourceforge.net/projects/android-rom-ota/files/LineageOS/'$device'/'$FILE_NAME'.zip/download</RomUrl>' $OTAXML

cd /home/audahadi/lineage-n/android_ota
git add -A && git commit -am "$FILE_NAME"
git push origin HEAD:lineage
cd /home/audahadi/lineage-n
#end ota xml update


