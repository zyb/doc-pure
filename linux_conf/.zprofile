#
# ~/.zprofile

# close the terminal bells
setterm -blength 0
# Activating Numlock
setleds -D +num

#export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
export PATH=$GOROOT/bin:$PATH
export PATH=$LITEIDE_HOME/bin:$PATH

# auto startx
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
