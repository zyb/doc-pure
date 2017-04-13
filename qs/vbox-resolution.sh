#! /bin/bash

w=1920
h=1080
if [[ "" != $1 ]]; then
	w=$1
	if [[ "" != $2 ]]; then
		h=$2
	fi
fi
echo "VBoxManage  controlvm \"win10\" setvideomodehint $w $h 32"
