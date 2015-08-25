#! /bin/bash

if [ '$1' == 'ssh' ]; then
  ssh binzhang3@172.16.59.13 -p 21722
elif [ '$1' == 'scp' ]; then
  scp -P 21722 binzhang3@172.16.59.13:$2 $3
fi
