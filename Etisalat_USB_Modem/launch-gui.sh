#!/bin/bash
#This script will launch a GUI program once
#file:launch-gui.sh
SU="/bin/su"
XHOST="/usr/bin/xhost"
#NICE="/bin/nice"
#NICE="/usr/bin/nice"
WHO="/usr/bin/who"
PUI=`pidof Etisalat_USB_Modem`


#the GUI progranm to launch by this script
GUI2LAUNCH="/bin/Etisalat_USB_Modem"

#define a file to collect info in the progress
LAUNCH_INFO="/tmp/modem-gui-launch-info"

#define a lock that make sure there is at most only one UI is running
GUI_LOCK="/tmp/modem-gui-launch-lock"

function get_distro_name {
    ISSUE_NAME="/etc/issue"
    DIS_NAME="other"
    if [ -e $ISSUE_NAME -a -f $ISSUE_NAME ]; then
        if [ "$(grep "Ubuntu" $ISSUE_NAME)" ]; then
            DIS_NAME="Ubuntu"
        elif [ "$(grep 'SUSE' $ISSUE_NAME)" ]; then
            DIS_NAME="OpenSUSE"
        elif [ "$(grep "Fedora" $ISSUE_NAME)" ]; then
            DIS_NAME="Fedora"
        elif [ "$(grep "Mandriva" $ISSUE_NAME)" ]; then
            DIS_NAME="Mandriva"
        fi
    fi
    echo $DIS_NAME
}

#lock or unlock when add or remove device, make sure there is only one $GUI2LAUNCH is running
if [ "add" = "$ACTION" ];then
	if [ ! -f "$GUI_LOCK" ];then
#        if [ ""!="$PUI" ];then
		        touch "$GUI_LOCK"
		else
		        echo "The  $GUI2LAUNCH can't have two instances!" >> $LAUNCH_INFO
		        exit 1
		fi
elif [ "remove" = "$ACTION" ];then
		rm -rf "$GUI_LOCK"
		exit 1
else
	echo "ACTION=$ACTION" >> $LAUNCH_INFO
	exit 1
fi

#export display variable
export DISPLAY=":0.0"
#export XAUTHORITY="$(echo `ls /tmp/.gdm* -t` | awk '{print $1}')"

#find a valid X Server User
#XHOST_LIST=`$XHOST`
#XHOST_SI=`echo ${XHOST_LIST##*SI}`
#XUSER=`echo ${XHOST_SI//:/ } | awk '{print $2}'`
#if [ -z "$XUSER" ];then
#	echo "XUSER is NULL:$XUSER" > $LAUNCH_INFO
#	exit 1
#fi
XUSER=`$WHO | grep tty7 | awk '{print $1}'`
if [ "" == "$XUSER" ];then
    XUSER=`$WHO |  grep --regexp=:0[\ ] | awk '{print $1}'`
    if [ "" == "$XUSER" ];then
        XUSER=`$WHO |  grep --regexp=:0[\)] | awk '{print $1}'`
    fi
fi

if [ "" == "$XUSER" -a "Ubuntu" == $(get_distro_name) ];then
    XUSER=`ps axu |  grep --invert-match grep | grep unity | head -1 | awk '{print $1}'`
elif [ "Fedora" == $(get_distro_name) ];then
    `/usr/sbin/setenforce 0`
fi

#another way that make sure there is only one $GUI2LAUNCH is running
#if [ ""!="$(ps aux | grep $GUI2LAUNCH | grep $XUSER)" ];then
#	echo "The  $GUI2LAUNCH can't have two instances!" >> $LAUNCH_INFO
#	exit 1
#fi

#get the user's HOME dir
XUSER_PSW=`cat /etc/passwd | grep $XUSER`
XUSER_PSW=`echo ${XUSER_PSW#"$XUSER"*/}`
XUSER_HOME=`echo /${XUSER_PSW%%:*}`

#set something that depend on linux release version
if [ "$(cat /etc/lsb-release | grep Ubuntu)" != "" ];then
	export XAUTHORITY="$XUSER_HOME/.Xauthority"
	NICE="/usr/bin/nice"
elif [ "$(cat /etc/redhat-release | grep Fedora)" != "" ];then
	export XAUTHORITY="$(echo `ls /tmp/.gdm* -t` | awk '{print $1}')"
        if [ -n "`uname -r | grep fc10`" -o -n "`uname -r | grep fc14`" ];then
	      XAUTHORITY1="$(echo `ls /var/run/gdm/auth-for* -t` | awk '{print $1}')"
              XAUTHORITY1="${XAUTHORITY1%:}"
              export XAUTHORITY="$XAUTHORITY1"/database  
        elif [ -n "`uname -r|grep fc9`" ];then
             export XAUTHORITY="`ls /var/run/gdm/auth* | grep $XUSER`"
        fi
	NICE="/bin/nice"
elif [ "$(cat /etc/debian_version)" == "4.0" ] || [ "$(cat /etc/debian_version)" == "5.0" ];then
       export XAUTHORITY="$XUSER_HOME/.Xauthority"
       NICE="/usr/bin/nice"
elif [ "$(cat /etc/debian_version)" == "6.0" ];then
    XAUTHORITY1="$(echo `ls /var/run/gdm3/auth-for* -t` | awk '{print $1}')"
    XAUTHORITY1="${XAUTHORITY1%:}"
    export XAUTHORITY="$XAUTHORITY1"/database
    NICE="/usr/bin/nice"
elif [ "Mandriva" == $(get_distro_name) ] ;then
	echo "Mandriva"
	NICE="/bin/nice"
else
	echo "Your System maybe not Fedora or Ubuntu or Debian!" >> $LAUNCH_INFO
    	NICE="/usr/bin/nice"
fi

		
#make the user's ENVIROMENT VARIABLEs take effect
. "$XUSER_HOME/.bash_profile"

#set the user's LANGUAGE enviroment variable
LANG_STR=`cat $XUSER_HOME/.dmrc | grep "Language"`
if [ ""!="$LANG_STR" ];then
	export LANG=`echo ${LANG_STR##*=}`
	export LC_ALL=$LANG
fi

#debug 
echo "XHOST=$XHOST" >>  $LAUNCH_INFO
#echo "XHOST_LIST=$XHOST_LIST" >>  $LAUNCH_INFO
#echo "XHOST_SI=$XHOST_SI" >>  $LAUNCH_INFO
echo "XUSER=$XUSER" >> $LAUNCH_INFO
echo "XUSER_HOME=$XUSER_HOME" >> $LAUNCH_INFO
echo "LANG_STR=$LANG_STR" >> $LAUNCH_INFO
echo "LANG=$LANG" >> $LAUNCH_INFO
echo "LC_ALL=$LC_ALL" >> $LAUNCH_INFO
echo "SU=$SU" >> $LAUNCH_INFO
echo "NICE=$NICE" >> $LAUNCH_INFO
echo "XAUTHORITY=$XAUTHORITY" >> $LAUNCH_INFO
echo "who=`who`" >> $LAUNCH_INFO

#mkxauth -u eagle -l eagle -c 127.0.0.1 >  ~eagle/mkauth.txt

$SU $XUSER -c "$XHOST +local:"

#if [ "" != "`uname -r |grep fc13`" -o "" != "`cat /etc/issue |grep 10.04`" ];then
#   if [ "" == "`who`" ];then
   if [ "" == "$XUSER" ];then
       echo "fail" >> $LAUNCH_INFO
       exit -1
   fi
#fi
echo "success1" >> $LAUNCH_INFO
nohup $NICE --adjustment=5 $SU $XUSER -c "$GUI2LAUNCH &" &

echo "success" >> $LAUNCH_INFO
exit 0
