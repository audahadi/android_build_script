#!/bin/bash

DIR_1=/home/audahadi/lineage-n
DATE=$(date +%Y%m%d)

repo forall device/asus/Z010D device/asus/Z00ED device/asus/Z00RD -c "git reset --hard HEAD"

cp -f /home/audahadi/.android-certs/* /home/audahadi/lineage-n/build/target/product/security


if [ "$device" == "Z010D" ]
then
sed -i  -e '$a\\' $DIR_1/device/asus/$device/system.prop
sed -i  -e '$a\#Updater override' $DIR_1/device/asus/$device/system.prop
sed -i -e '$a\cm.updater.uri=https://raw.githubusercontent.com/audahadi/android_ota/lineage/lineage-oms/Z010D/api.json' $DIR_1/device/asus/$device/system.prop
fi

if [ "$device" == "Z00ED" ]
then
sed -i  -e '$a\\' $DIR_1/device/asus/$device/system.prop
sed -i  -e '$a\#Updater override' $DIR_1/device/asus/$device/system.prop
sed -i -e '$a\cm.updater.uri=https://raw.githubusercontent.com/audahadi/android_ota/lineage/lineage-oms/Z00ED/api.json' $DIR_1/device/asus/$device/system.prop
fi

if [ "$device" == "Z00RD" ]
then
sed -i  -e '$a\\' $DIR_1/device/asus/$device/system.prop
sed -i  -e '$a\#Updater override' $DIR_1/device/asus/$device/system.prop
sed -i -e '$a\cm.updater.uri=https://raw.githubusercontent.com/audahadi/android_ota/lineage/lineage-oms/Z00RD/api.json' $DIR_1/device/asus/$device/system.prop
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
make installclean
mka bacon -j8

#Get file name
FILE_NAME=$(basename $DIR_1/out/target/product/$device/lineage-14.1-*.zip .zip)

mv $DIR_1/out/target/product/$device/lineage-14.1-*.zip $DIR_1/out/target/product/$device/$FILE_NAME-OMS.zip

