#! /bin/bash

#herbstclient attr clients. | grep 0x | xargs -I {} herbstclient attr clients.{}. | grep -E "tag|class|instance|title" | sed '/instance/G'
herbstclient attr clients. | grep 0x | xargs -I {} herbstclient attr clients.{}. | grep -E "tag|class|instance|title" | awk 'BEGIN{cnt=0}{$1=null;$2=null;$3=null;$4=null;if (cnt%4==0){title=$0}else if(cnt%4==1){tag=$0}else if(cnt%4==2){class=$0}else{printf "%1s%15s%15s%s\n", tag, class, $0, title;}; cnt++}' | sort
