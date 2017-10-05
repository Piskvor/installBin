#!/bin/bash

url="$1"
REWRITE=( $(IFS=" " echo "$(echo $url | sed -s 's/%2F/\//g' | sed -s 's/.*file=\(\/.*\)\&line=\(.*\)/\1\ \2/')") );

line=${REWRITE[1]}
file=${REWRITE[0]}

# Netbeans
#netbeans "$file:$line"
# Kate
#kate --line $line "$file"
# Vim
#vim "$file" +$line
# Gedit
#gedit +$line "$file"
# Komodo
#komodo "$file#$line"
# PhpStorm
#zenity --info --text "~/bin/pstorm --line $line \"$file\""
~/bin/pstorm --line $line "$file"
# Sublime Text 2
#subl "$file:$line"
