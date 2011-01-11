#!/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin

MOUNTP=/home/ssp/sub1

SERVER=sub1.sub.uni-goettingen.de
SERVERNAME=SUB1

CHECKNAME=USER
CHECKTYPE=-d

NWUSER=porst
NWPWD=$(cat /home/ssp/.novellpwd)

MOUNTUID=ssp

TIMEOUT=120
RETRIES=10
CHARSET="iso8859-1"
CODEPAGE=cp850

SIGNING=2

FILEMODE=0664
DIRMODE=0775

if ! [ $CHECKTYPE "$MOUNTP/$CHECKNAME" ]; then
	# Ping Test:
	ping -c 1 "$SERVER" >/dev/null 2>&1 || exit 1
	# Unmount the dead connection:
	sudo ncpumount "$MOUNTP" >/dev/null 2>&1
	# Wait for everything to settle:
	sleep 4
	# do mount:
	sudo mount -t ncp -o server="$SERVER",\
user="$NWUSER",\
passwd="$NWPWD",\
uid="$MOUNTUID",\
owner="$MOUNTUID",\
filemode="$FILEMODE",\
dirmode="$DIRMODE",\
timeout="$TIMEOUT",\
retry="$RETRIES",\
iocharset="$CHARSET",\
codepage="$CODEPAGE",\
ipserver="$SERVER",\
tcp\
		"$SERVER/$NWUSER" "$MOUNTP"
fi

