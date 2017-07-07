#! /bin/bash

if [[ "$1" == "" || "$2" == "" ]]; then
	echo "need 2 params"
	exit 1
fi

name=$1
levels=$2
tar -tvf $name | awk -F/ '{if(NF<'$levels'+2 || (NF=='$levels'+2 && $NF=="")) print $0}'
