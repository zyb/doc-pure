#!/bin/sh
 
monitor=${1:-0}
echo $monitor
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
    echo "Invalid monitor $monitor"
    exit 1
fi
# geometry has the format W H X Y
x=${geometry[0]}
y=${geometry[1]}
panel_width=${geometry[2]}
#panel_width=1366
panel_height=18
font="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"
#font="-*-WenQuanYi Micro Hei Mono-medium-*-*-*-12-*-*-*-*-*-*-*"
bgcolor='#202020'
fgcolor='#ffffff'

echo "conky -c ~/.conkyrc-dzen2 | dzen2 -w $panel_width -x $x -y $y -fn \"$font\" -h $pannel_height -e - -ta l -bg \"$bgcolor\" -fg \"$fgcolor\""
conky | dzen2 -w $panel_width -x $x -y $y -fn "$font" -h $pannel_height -e - -ta r -bg "$bgcolor" -fg "$fgcolor"
