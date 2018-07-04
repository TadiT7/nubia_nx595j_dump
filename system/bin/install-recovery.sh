#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:18945324:1165f9bffde00d77d9a44400d8ffee772a57c81d; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:15316264:f783b0abb4a69d97541a91610ff212a342f13efb EMMC:/dev/block/bootdevice/by-name/recovery 1165f9bffde00d77d9a44400d8ffee772a57c81d 18945324 f783b0abb4a69d97541a91610ff212a342f13efb:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
