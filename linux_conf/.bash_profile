#
# ~/.bash_profile
#

# close the terminal bells
setterm -blength 0
# Activating Numlock
setleds -D +num

[[ -f ~/.bashrc ]] && . ~/.bashrc

#export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
export PATH=$GOROOT/bin:$PATH
export PATH=$LITEIDE_HOME/bin:$PATH

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
