#!/bin/bash

HASH=$(base64 "$1")
MIME=$(file "$1" --mime --brief | sed 's/;.*//')

echo -n '<img src="data:'
echo -n ${MIME}
echo -n ';base64,'
echo -n ${HASH}
echo '"/>'
