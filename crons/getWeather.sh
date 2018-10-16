#!/bin/bash

set -euxo pipefail

export DIR_NAME="$(dirname $0)"
cd ${DIR_NAME}
DIR_NAME="$(pwd)"

if [ -f "$DIR_NAME/set_proxy.sh" ]; then
    source "$DIR_NAME/set_proxy.sh"
fi

cp -f screen.extra.css pocasi/
cd pocasi

HOST_NAME=$(getent hosts pocasi | awk '{ print $1 }')

ARROWS=""
#for i in `seq 0 15` ; do
#    ARROWS=" $ARROWS http://${HOST_NAME}/img/ar$i.gif"
#done

if [ 1 -gt 0 ]; then
wget --wait=2 --waitretry=30 --tries=3 --random-wait --limit-rate=5k --backup-converted \
     --no-directories --timestamping \
     "http://${HOST_NAME}/status.html" $ARROWS
fi

cp status.html status.ISO-8859-2.html
iconv --from-code=ISO-8859-2 --to-code=UTF-8 status.ISO-8859-2.html > index.utf8.html
DATE=$(date)
sed "s~img/~~g;s~15.URL=/status.html~60~;s~[a-z]\+.html~#~g;s~script~xscript~g;s~<tr><td colspan=2 height=3 class=\"tl\"></td></tr>~~;s~<span><small>~<strong><span>~;s~<h2>~~;s~</head>~<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"></head>~;s~&copy;~${DATE}<br>&copy;~" < index.utf8.html > index.html

sed "s~http://pocasi/~~;s~http://${HOST_NAME}/~~;s~img/~~" < screen.css > screen.processed.css
cat screen.processed.css screen.extra.css > screen.css
