#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:19031340:669085a0286b0d5d12180848eae0ce2e6fea3335; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:15316264:610f76df20002b487c4f29a274fe682704144ee7 EMMC:/dev/block/bootdevice/by-name/recovery 669085a0286b0d5d12180848eae0ce2e6fea3335 19031340 610f76df20002b487c4f29a274fe682704144ee7:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
