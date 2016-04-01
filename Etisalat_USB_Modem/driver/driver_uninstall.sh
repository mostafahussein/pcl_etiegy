#!/bin/bash

ZTE_KERNELDIR=/lib/modules/`uname -r`/kernel/drivers/usb/serial 
RULE_DESTINATION=/etc/udev/rules.d
ZTE_mutil_port_device_DIR=/dev/zte_mutil_port_devices

zte_mutil_port_devices_rules_uninstall()
{
    if [ -f $RULE_DESTINATION/*-zte-mutil_port_device.rules ]
    then
        rm  $RULE_DESTINATION/*-zte-mutil_port_device.rules
        echo "zte_mutil_port_devices_rules_uninstall"
    fi
}

zte_modem_script_remove()
{
    if [ -f /bin/remove_device.sh ] 
    then
        rm /bin/remove_device.sh
    fi
}
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
    rm $ZTE_KERNELDIR/zte.ko   2>/dev/null
    
    modprobe -r onda 2>/dev/null 
    rm $ZTE_KERNELDIR/onda.ko  2>/dev/null

    echo "............uninstall driver completed!!!............"
else 
    echo "No driver found, it have been uninstall or have no exist before"
fi
