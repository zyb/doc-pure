#
# ~/.bash_profile
#
setterm -blength 0

[[ -f ~/.bashrc ]] && . ~/.bashrc

export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
export PATH=$GOROOT/bin:$PATH
export PATH=$LITEIDE_HOME/bin:$PATH

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
