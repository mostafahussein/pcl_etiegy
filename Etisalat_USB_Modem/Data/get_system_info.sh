#! /bin/bash

rm -f $1

ISSUE_NAME="/etc/issue"
if [ -e $ISSUE_NAME -a -f $ISSUE_NAME ]; then
	SYSTEM_STRING=$(cat $ISSUE_NAME)
	if [ "$(grep "Ubuntu" $ISSUE_NAME)" ]; then
		SYSTEM_STRING=${SYSTEM_STRING%%\\*}
	elif [ "$(grep 'SUSE' $ISSUE_NAME)" ]; then
		SYSTEM_STRING=${SYSTEM_STRING%%-*}
		SYSTEM_STRING=${SYSTEM_STRING#*to}
	elif [ "$(grep "Fedora" $ISSUE_NAME)" ]; then
		SYSTEM_STRING=${SYSTEM_STRING%%Kernel*}
	elif [ "$(grep "Mandriva" $ISSUE_NAME)" ]; then
		SYSTEM_STRING=$(head -1 $ISSUE_NAME)
	else
		SYSTEM_STRING=${SYSTEM_STRING%%\\*}
	fi
	echo $SYSTEM_STRING >>$1
else
	uname -r >>$1
fi

echo $LANG>>$1

