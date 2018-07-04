#!/system/bin/sh

local count=0
local utime
local ktime
local cache_size
local pause_time=10
local file_nubmer=0
local kernel_file_number=0
local del_file_nubmer=0
local kernel_del_file_nubmer=0
local file_size=0
local kernel_size=0
local kernel_max_size=10*1024*1024
local max_size=0
local countn=0
local coefficent=10
local nblog_enable
local filetime

local ftime
LOG_DIR=$1



dump_peripheral () {
	local base=$1
	local size=$2
	local dump_path=$3
	echo $base > $dump_path/address 
	echo $size > $dump_path/count 
	cat $dump_path/data
}



ispoweroffcharge=`getprop sys.poweroffcharge.control`
isnblog=`cat /persist/woodpecker/persist.sys.nblog.enable`
if [ -n "$ispoweroffcharge" ] && [ "$ispoweroffcharge" = "on" ]  && [ -n "$isnblog" ] && [ "$ispoweroffcharge" = "on" ]; then
    cache_freesize=`getprop sys.cache.size`
    ftime=$(date +'%Y-%m-%d_%H-%M-%S')
    filetime=$ftime
    /system/bin/mkdir $LOG_DIR/$filetime
    /system/bin/touch $LOG_DIR/$filetime/kernel_$kernel_file_number.txt
    /system/bin/touch $LOG_DIR/$filetime/fg_$file_nubmer.txt
elif [ -n "$isnblog" ] && [ "$isnblog" = "on" ]; then
    /system/bin/touch $LOG_DIR/fg_$file_nubmer.txt
 else 
	exit
 fi
while true
do
	if [ -n "$ispoweroffcharge" ] && [ "$ispoweroffcharge" = "on" ]  && [ -n "$isnblog" ] && [ "$ispoweroffcharge" = "on" ]; then
		utime=($(cat /proc/uptime))
	        ktime=${utime[0]}
	        echo "SRAM Dump  Started at ${ktime}" >> $LOG_DIR/$filetime/fg_$file_nubmer.txt
	        dump_peripheral 0 500 "/sys/kernel/debug/fg/sram" >> $LOG_DIR/$filetime/fg_$file_nubmer.txt
	        utime=($(cat /proc/uptime))
	        ktime=${utime[0]}
	        echo "SRAM Dump done at ${ktime}" >> $LOG_DIR/$filetime/fg_$file_nubmer.txt
		file_max_size=$((1024*10*1024))
		exit_min_size=$((1*10))
		if [[ $cache_freesize -le $exit_min_size ]]; then
		    echo "$cache_freesize  $exit_min_size  cache partition space less 5 MB !! exit fg dump!" >> $LOG_DIR/$filetime/fg_$file_nubmer.txt
			break
		fi
		file_size=`stat -c%s $LOG_DIR/$filetime/fg_$file_nubmer.txt` 
                kernel_size=`stat -c%s $LOG_DIR/$filetime/kernel_$kernel_file_number.txt`
		if [[ $file_size -gt $file_max_size ]]; then
			let file_nubmer=$file_nubmer+1
			/system/bin/touch $LOG_DIR/$filetime/fg_$file_nubmer.txt
		fi
		if [[ $kernel_size -gt $kernel_max_size ]]; then
			let kernel_file_number=$kernel_file_number+1
			/system/bin/touch $LOG_DIR/$filetime/kernel_$kernel_file_number.txt
		fi
		cache_size=`getprop sys.cache.size`
		if [[ $cache_size -le $(($cache_freesize/5))  ]]; then
			/system/bin/rm -rf $LOG_DIR/$filetime/fg_$del_file_nubmer.txt
			echo "del_file_nubmer $del_file_nubmer!" >> $LOG_DIR/$filetime/fg_$file_nubmer.txt
			let del_file_nubmer=$del_file_nubmer+1
			/system/bin/rm -rf $LOG_DIR/$filetime/kernel_$kernel_del_file_nubmer.txt
			echo "kernel_del_file_nubmer $kernel_del_file_nubmer!" >> $LOG_DIR/$filetime/kernel_$kernel_file_number.txt
			let kernel_del_file_nubmer=$kernel_del_file_nubmer+1
		fi
		/system/bin/dmesg -c  >>  $LOG_DIR/$filetime/kernel_$kernel_file_number.txt
	elif [ -n "$isnblog" ] && [ "$isnblog" = "on" ]; then
		exit
	else 
	        exit
	fi
        sleep $pause_time
	nblog_enable=`getprop persist.sys.nblog.enable`
	if [ "$nblog_enable" = "off" ]; then
		break
	fi
done
