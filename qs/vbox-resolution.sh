#! /bin/bash

w=1913
h=1010
if [ "" != $1 ]; then
	w=$1
	if [ "" != $2 ]; then
		h=$2
	fi
fi
VBoxManage  controlvm "win10" setvideomodehint $W $h 32
