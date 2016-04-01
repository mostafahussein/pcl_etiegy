#!/bin/bash

FILE_NAME=Etisalat_USB_Modem
EXE_FILE=Etisalat_USB_Modem
SYS_PATH=/opt
INSTALL_PATH=$SYS_PATH/$FILE_NAME

ZTE_KERNELDIR=/lib/modules/`uname -r`/kernel/drivers/usb/serial 
RULE_DESTINATION=/etc/udev/rules.d
ZTE_mutil_port_device_DIR=/dev/zte_mutil_port_devices

zte_mutil_port_devices_rules_uninstall()
{
    if [ -f $RULE_DESTINATION/*-zte-mutil_port_device.rules ]
    then
        rm  $RULE_DESTINATION/*-zte-mutil_port_device.rules
        echo "mutil_port_devices_rules_uninstall"
    fi
}

zte_modem_script_remove()
{
    if [ -f /bin/remove_device.sh ] 
    then
        rm /bin/remove_device.sh
    fi
}

uninstall_driver()
{
    if [ -f $ZTE_KERNELDIR/zte.ko -o -f $ZTE_KERNELDIR/onda.ko ]
    then
    echo "..............start driver uninstall................."

    if [  -d $ZTE_mutil_port_device_DIR ]
    then
        rm -rf $ZTE_mutil_port_device_DIR
    fi

    zte_mutil_port_devices_rules_uninstall
    zte_modem_script_remove

    rm -rf /dev/serial/   2>/dev/null
    rm /dev/ttyUSB*    2>/dev/null

    modprobe -r option  2>/dev/null

    modprobe -r zte  2>/dev/null
    if [ -n $ZTE_KERNEL/zte.ko ];then
    {
        rm $ZTE_KERNELDIR/zte.ko   2>/dev/null
    }
    fi

    modprobe -r onda 2>/dev/null 
    if [ -n $ZTE_KERNEL/onda.ko ];then
    {
        rm $ZTE_KERNELDIR/onda.ko  2>/dev/null
    }
    fi

    echo "............uninstall driver completed!!!............"
    else 
    echo "No driver found, it have been uninstall or have no exist before"
    fi
}

# main begin

echo "..................start uninstall................."
echo -n "*** Check for root..."
if [ $EUID -ne 0 ]; then
	echo -e "\b\b\b - failed"
	echo "*** Please retry as root user."
        read -p "press any key to exit.... " -n 1
	exit -1
fi


UI_PID=`pidof $EXE_FILE`
if  [ -z $UI_PID ] ;then
     echo "..................start delete the application................."
else
     read -p ".............If you want delete "$FILE_NAME",please close "$FILE_NAME" first!!!..........." -n 1
     exit 0
fi

#added by ChenYing 2009-4-27
cd $INSTALL_PATH/driver
chmod 755 se
if [ -n "`uname -r |grep fc10`" ];then
   ./se "semodule -r disselfirefox"
   ./se "semodule -r nm"
   echo "it's ok!"

#	echo "Enable NetworkManager service!"		cancel by ChenYing 2009-5-27
#	chkconfig NetworkManager on 2>&1 >> /dev/null
#	service NetworkManager start 2>&1 >> /dev/null
fi
#the end


#uninstall driver
uninstall_driver

rm -rf $INSTALL_PATH

TMP_FILE=/etc/tmpwvdial.conf
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/etc/tmpresolv.conf
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/etc/resolv.conf.prev
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/etc/defaultConfig.conf
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/etc/defaultwvdial.conf
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/etc/defaultresolv.conf
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/etc/ppp/defaultoption
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi
 
TMP_FILE=/etc/ppp/defaultresolv.conf
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/etc/ppp/ip-up.local
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/etc/ppp/ip-down.local
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/etc/ppp/get_route_info		#canceled by ChenYing 2009-10-22
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/etc/ppp/tmpoptions
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/etc/ppp/tmpresolv.conf
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/etc/ppp/peers/defaultwvdial
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/etc/ppp/peers/tmpwvdial
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/usr/bin/$EXE_FILE
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/bin/$EXE_FILE
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/bin/launch-gui.sh
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/usr/share/applications/$EXE_FILE.desktop
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

TMP_FILE=/usr/share/pixmaps/$EXE_FILE.png
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

#delete autorun files 
#TMP_FILE=/sbin/join-air-launch.sh
#if [ -f $TMP_FILE ];then
#	rm -f $TMP_FILE
#      echo ..........delete $TMP_FILE ok...........
#fi

#TMP_FILE=/etc/udev/rules.d/998-join-air.rules
#if [ -f $TMP_FILE ];then
#	rm -f $TMP_FILE
#      echo ..........delete $TMP_FILE ok...........
#fi

TMP_FILE=/etc/udev/rules.d/9-cdrom.rules
if [ -f $TMP_FILE ];then
	rm -f $TMP_FILE
      echo ..........delete $TMP_FILE ok...........
fi

#add for udev reload 100414
if [ -f /sbin/udevadm ]
then
    /sbin/udevadm control reload_rules >/dev/null 2>&1
    /sbin/udevadm control --reload-rules >/dev/null 2>&1
    /sbin/udevadm trigger --subsystem-match=block
    echo "udevadm is exist!"
else
    /sbin/udevcontrol reload_rules 
    /sbin/udevtrigger --subsystem-match=block 
    echo "udevadm isn't exist!"
fi

#update applications menu
PARTIAL_NAME=$(locale | head -1)
PARTIAL_NAME=${PARTIAL_NAME#*=}
PARTIAL_NAME=${PARTIAL_NAME%.*}

CACHE_NAME=`ls /usr/share/applications/desktop.*.cache | head -1`
CACHE_NAME=${CACHE_NAME#*.}
CACHE_NAME=${CACHE_NAME%.*}
CACHE_NAME=${CACHE_NAME#*.}

FILENAME=$PARTIAL_NAME.$CACHE_NAME
if [ -f /usr/share/applications/desktop.$FILENAME.cache ]; then
	/usr/share/gnome-menus/update-gnome-menus-cache /usr/share/applications > /usr/share/applications/desktop.$FILENAME.cache
fi
#update end

echo "uninstall completed!!!"

read -p "press any key to continue.... " -n 1

#main end
