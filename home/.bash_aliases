#!/bin/bash

if [ -e "$HOME/prog/headful-server/.bash_aliases" ]; then
    source "$HOME/prog/headful-server/.bash_aliases"
fi

#alias vss='vagrant ssh $(get-bb-id)'

source ~/.project_dev/bash_aliases

eval $(thefuck --alias)
