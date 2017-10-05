#!/usr/bin/env bash

#!/bin/sh

git filter-branch --env-filter '
OLD_EMAIL="jan.martinec@example.con"
CORRECT_EMAIL="github@piskvor.org"
CORRECT_NAME="Jan Piskvor Martinec"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags