#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


__rmlogger () 
{ 
    time=`TZ="Asia/Shanghai"  date +"%Y-%m-%d %T"`;
    echo "[$time] $*"
}

__myrm () 
{ 
    local limit=500000;
    if [ -d $HOME/.local/share/Trash/files ]; then
        trash="$HOME/.local/share/Trash/files";
    else
        trash="$HOME/.Trash";
    fi;
    local log="/var/log/trash.log";
    while [[ ! -z "$1" ]]; do
        if [[ ! -d "$1" ]]; then
            if [[ ! -f "$1" ]]; then
                shift;
                continue;
            fi;
        fi;
        full=`readlink -f "$1"`;
        base=`basename "$full"`;
        if [[ -n ` echo "$base" |grep "\." ` ]]; then
            new=`echo "$base" |sed -e "s/\([^.]*$\)/$RANDOM.\1/" `;
        else
            new="$base.$RANDOM";
        fi;
        trash_file="$trash/$new";
        local fs=`du -BM -s "$full" |awk -FM '{print $1}'`;
        if [ "$fs" -gt "$limit" ]; then
            read -p "File/Folder is ${fs}Mb, too large. rm it permanently? [Y/n]" answer;
            case "$answer" in 
                "Y" | "" | "y")
                    /bin/rm -rv "$full";
                    __rmlogger "'$full' removed permanently"
                ;;
                *)
                    __rmlogger "aborted from deleting $full"
                ;;
            esac;
            shift;
            continue;
        fi;
        mv "$full" "$trash_file";
        if [ $? -eq 0 ]; then
            if [ -w "$log" ]; then
                __rmlogger "$full => [$trash_file]" | tee -a "$log";
            else
                __rmlogger "$full => [$trash_file]";
            fi;
        else
            __rmlogger "Error deleting $full";
        fi;
        shift;
    done
}

alias rm='__myrm'

#PS1='[\u@\h \W]\$ '
alias ls='ls --color=auto'
alias ll='ls -laF --color=auto'
alias l='ls -lF --color=auto'
alias vi='vim'
alias grep='grep --color=auto'

alias tssh='ssh binzhang3@172.16.59.13 -p 21722'
alias tscp='function __mytscp() { if [[ "$1" == "" || "$2" == "" ]]; then echo "need 2 params"; return 1; fi; scp -r -P 21722 $1 binzhang3@172.16.59.13:~/zybtrans/$2; }; __mytscp'
alias ttscp='function __myttscp() { if [[ "$1" == "" || "$2" == "" ]]; then echo "need 2 params"; return 1; fi; scp -r -P 21722 binzhang3@172.16.59.13:~/zybtrans/$2 $1; }; __myttscp'
#alias vm1='ssh z@172.16.0.130'
#alias vm2='ssh z@172.16.0.131'

#alias eclipse='/usr/local/eclipse/eclipse'
alias eclipse='$HOME/software/eclipse/eclipse'
alias astah='$HOME/software/astah/astah_professional/astah'

#export JAVA_HOME=/usr/local/jdk7
#export JRE_HOME=$JAVA_HOME/jre
export GOROOT=/usr/lib/go
export GOPATH=/home/zyb/gopath:/home/zyb/gows
export LITEIDE_HOME=/usr/local/liteide

