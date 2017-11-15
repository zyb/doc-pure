#! /bin/bash

if [[ "" == "$1" ]]; then
  cmd="/bin/bash"
else
  cmd=$1
fi

sudo docker exec -it $(sudo docker ps -q -l) $cmd
