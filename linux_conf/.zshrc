# The following lines were added by compinstall
zstyle :compinstall filename '/home/zyb/.zshrc'

# Command automatic completion
autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install

autoload -U promptinit
promptinit
prompt walters

# ignore duplicate lines in the history
setopt HIST_IGNORE_DUPS
ttyctl -f

autoload -U colors && colors

HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
bindkey -e

zstyle ':completion:*' rehash true

source ./.zybshellrc
# End of lines configured by zsh-newuser-install

