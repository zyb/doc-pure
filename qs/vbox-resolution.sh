#! /bin/bash

w=1913
h=1010
if [[ "" != $1 ]]; then
	w=$1
	if [[ "" != $2 ]]; then
		h=$2
	fi
fi
echo "VBoxManage  controlvm \"win10\" setvideomodehint $w $h 32"
