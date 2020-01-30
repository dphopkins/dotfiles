#!/usr/bin/env bash

#### Functions ####

function certify() {
    openssl x509 -text -noout -in $1
    # where $1 is a .crt file
}

function ksecret() {
    kubectl get secret $1 -o jsonpath="{.data.$2}" | base64 --decode
    echo
}

function annotate() {
    annotate_stdout () { awk '{ print "[STDOUT]", $0; fflush(); }'; }
    annotate_stderr () { awk '{ print "[STDERR]", $0; fflush(); }'; }
    { eval "$*" 2>&1 1>&3 3>&- | annotate_stderr; } 3>&1 1>&2 | annotate_stdout
}

function grepno() {
    git grep $1 -- "./*" ":!*$2"
}

function f_titular_grep() {
     read; printf '%s\n' "$REPLY"; egrep "$@"
}
alias tgrep=f_titular_grep

alias howtar='echo "tar -czf *.tar.gz /path/"; echo "tar xf *.tar.gz"'

function del_tag() {
    git tag -d $1
    git push origin :refs/tags/$1
}

# Finding things # TODO: make this go into directories recursively
function findin () {
    find . -exec grep -q "$1" '{}' \; -print
}

# Extracting files
function extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1    ;;
            *.tar.gz)    tar xvzf $1    ;;
            *.tgz)       tar xvzf $1    ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xvf $1     ;;
            *.tbz2)      tar xvjf $1    ;;
            *.tgz)       tar xvzf $1    ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Print specific column
function fawk {
    first="awk '{print "
    last="}'"
    cmd="${first}\$${1}${last}"
    eval $cmd
}

alias htmldiff='pygmentize -l diff -O full=true -f html'

# Shows a specific part of a file
# args: [path/to/file, start_line, context_lines]
# TODO: put in default context
function context {
    half=`expr $3 / 2`
    start=`expr $2 - $half`
    tail -n +$start $1 | head -n $3
    # tail -n +$2 $1 | head -n $3
}

function fixssh {
    for key in SSH_AUTH_SOCK SSH_CONNECTION SSH_CLIENT; do
        if (tmux show-environment | grep "^${key}" > /dev/null); then
            value=`tmux show-environment | grep "^${key}" | sed -e "s/^[A-Z_]*=//"`
            export ${key}="${value}"
        fi
    done
}

# Make things lowercase
function lowercase {
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

function utime {
    if [[ -n "$1" ]]; then
        # Translate unix timestamp into human-readable date
        date -d @$1
    else
        # Print time in unix format
        date +%s
    fi
}

function locate {
    grep -ril "$@" /usr/local/bin
}

function vimi {
    $EDITOR *$1*
}

function cdi {
    cd *$1*
}


#### Aliases ####
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias ls="ls --color"
alias ll="ls --group-directories-first -halp"
alias tree="tree --dirsfirst"
alias rm="rm -i"

alias v="$EDITOR"
alias vi="vimi"
alias vim="$EDITOR"

alias trim='cut -b -$(tput cols)'  # cuts output to fit window width
alias trimw="grep -rli '[[:blank:]]$'"  # show all files with trailing whitespace in a dir

alias brc="$EDITOR ~/.bashrc && . ~/.bash_profile"  # edit bashrc and source bash_profile
alias gcf="$EDITOR ~/.gitconfig"  # edit gitconfig
alias kcf="$EDITOR ~/.kube/config"  # edit kubeconfig
alias tmc="$EDITOR ~/.tmux.conf"  # edit tmux.conf
alias vrc="$EDITOR ~/.vimrc"  # edit vimrc
alias bcf="$EDITOR ~/.config/bat/config"  # edit bat config

alias acs='apt-cache search'
alias acp='apt-cache policy'

alias grep='grep --color=auto --line-buffered'
alias sudo='sudo -E'

alias xl='xargs -L1'

alias kc='kubectl'

#### Exports ####
# shell prompt
source ~/.git-prompt.sh
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM="verbose"
export PS1='\t \[\e[34m\](${PWD/"/usr/local/"/})\[\e[00m\] $(__git_ps1 "\[\e[37m\](%s)\[\e[00m\]") $(kube_ps1)\n$ '

# ls color
export LS_COLORS='di=34:ln=94:ex=33'

# Setting for the new UTF-8 terminal support in Lion
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export GIT_EMPTY_TREE=$(git hash-object -t tree /dev/null)

# Exposing editor for things
export EDITOR='/usr/local/bin/nvim'

# Flush bash history after each command (keeps command history even in tmux!)
export PROMPT_COMMAND='history -a'

# Ignore duplicate lines in bash history
# Also, command prefixed with a space don't show up in bash history
export HISTCONTROL=ignoreboth:erasedups

# Infinity (!!!) command history file
export HISTFILESIZE=-1
export HISTSIZE=-1

#### Sourcing ####
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Source z
. ~/z/z.sh

export KUBE_PS1_SEPARATOR=''
KUBE_PS1_CTX_COLOR='green'
# KUBE_PS1_NS_COLOR='cyan'
# black, red, green, yellow, blue, magenta, cyan
. /home/dhopkins/kube-ps1/kube-ps1.sh

export PATH=$PATH:/usr/local/go/bin

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
