#!/system/bin/sh
systrace_enable=`getprop persist.sys.systrace.enable`

if [ "$systrace_enable" == "1" ]; then
    /system/bin/atrace -b 16384 -n -f /system/etc/systrace/categorys.txt --async_start
else
    /system/bin/atrace -n --async_stop
fi
