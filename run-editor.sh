#!/bin/bash
url="$1"
REWRITE=( $(IFS=" " echo "$(echo $url | sed -s 's/%2F/\//g;s~file://~file=~g' | sed -s 's/.*file=\(.*\)\&line=\(.*\)/\1\ \2/')") );

line=${REWRITE[1]}
file=${REWRITE[0]}

# Vim
#vim "$file" +$line
# PhpStorm
project_dir=$(realpath $(readlink "$HOME/.project"))
~/bin/pstorm --line $line "$project_dir/$file"
# Sublime Text 2
#subl "$file:$line"
