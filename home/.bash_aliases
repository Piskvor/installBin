#!/bin/bash

alias lo=libreoffice
alias xo=xdg-open

alias vin=vim
alias vi,=vim

alias c=composer
alias co=composer
alias com=composer
alias comp=composer
alias compo=composer
alias compos=composer
alias compose=composer

alias coin='composer install'

alias dokcer=docker
alias dpcker=docker
alias ocker=docker
alias dcker=docker
alias ddocker=docker
alias d=docker

alias doco=docker-compose
alias dodo=docker-compose
alias dc=docker-compose

alias dropbox='ddropbox'
alias lrs='less -R -S +G'

alias xt='xat --encoding=png/L --speaker=off --microphone=off --webcam=off'

alias did="env LANG=C LC_ALL=C vim +'normal Go' +'r!date' ~/did.txt"
alias yts='youtube-dl --restrict-filenames -f bestaudio'
alias slowrsync='rsync -avP --times --no-perms --no-group --no-owner --stats --itemize-changes --inplace --bwlimit=1000'
alias gzip='pigz'

# fat fingers - alles ist git!
alias gi='git'
alias igt='git'
alias it='git'
alias gti='git'
alias ggit='git'
alias gut='git'
alias gitt='git'
alias giut='git'
alias gtit='git'
alias fit='git'
alias got='git'
alias g='git'

alias night='git checkout nightly'
alias master='git checkout master'
alias gp='git pull'
# --verbose'

alias tulen='export http_proxy=http://localhost:13128/;export https_proxy=$http_proxy'
alias mrog='export http_proxy=http://localhost:13128/;export https_proxy=$http_proxy'
alias noproxy='export http_proxy= ;export https_proxy=$http_proxy'
alias mcb='mc -bs'
alias tvoc='tail -F /var/log/syslog'

alias ss='screen -xR'

alias l='ls -CF'
alias latr='ls -latr'
alias ll='ls -l'
alias la='ls -A'

alias sl='ls'
alias sxc='screen -xR'
alias scx='screen -xR'
alias vss='ssh vagrant'

alias gw='$(yarn bin)/gulp watch --no-uglify'

#alias vss='vagrant ssh $(get-bb-id)'

source ~/.project_dev/bash_aliases

eval $(thefuck --alias)
