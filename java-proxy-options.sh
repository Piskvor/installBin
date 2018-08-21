#!/bin/bash

# Author : Kerim BASOL
# Twitter : http://twitter.com/kerimbasol
# URL : http://kerimbasol.com
# Version : 0.1
# Java Proxy support script
# You can use with GNU License

set -uo pipefail

#Automatically import system proxy settings
if [ -n "${http_proxy:-}" ] ; then
    echo ${http_proxy} | grep "@"
    if [ $? -eq 0 ]; then # If variable has username and password, its parse method is different
        PROXY_HOST=$(echo ${http_proxy} | sed 's/http:\/\/.*@\(.*\):.*/\1/')
        PROXY_PORT=$(echo ${http_proxy} | sed 's/http:\/\/.*@.*:\(.*\)/\1/' | tr -d "/")
        USERNAME=$(echo ${http_proxy} | sed 's/http:\/\/\(.*\)@.*/\1/'|awk -F: '{print $1}')
        PASSWORD=$(echo ${http_proxy} | sed 's/http:\/\/\(.*\)@.*/\1/'|awk -F: '{print $2}')
    else # If it doesn't have username and password, its parse method is this
        PROXY_HOST=$(echo ${http_proxy} | sed 's/http:\/\/\(.*\):.*/\1/')
        PROXY_PORT=$(echo ${http_proxy} | sed 's/http:\/\/.*:\(.*\)/\1/' | tr -d "/")
    fi
fi

# Display usage
if [ $# -gt 0 ] ; then
    if [ $1 = "--help" ] ; then
            echo "$0 [<proxy-server> <proxy-port> [<username>  <password> ] ] "
            exit 0
    fi
fi

# Command line proxy pass
if [ $# -gt 1 ] ; then
    PROXY_HOST=$1
    PROXY_PORT=$2
    if [ $# -gt 3 ] ; then
            USERNAME=$3
            PASSWORD=$4
    fi
fi

CMD=""
if [ -n "${PROXY_HOST:-}" ] && [ -n "${PROXY_PORT:-}" ] ; then
    CMD="-Dhttp.proxyHost=$PROXY_HOST -Dhttp.proxyPort=$PROXY_PORT"
    CMD="$CMD -Dhttps.proxyHost=$PROXY_HOST -Dhttps.proxyPort=$PROXY_PORT"
    if [ -n "${USERNAME:-}" ] && [ -n "${PASSWORD:-}" ]; then
        CMD="$CMD -Dhttp.proxyUser=$USERNAME -Dhttp.proxyPassword=$PASSWORD"
        CMD="$CMD -Dhttps.proxyUser=$USERNAME -Dhttps.proxyPassword=$PASSWORD"
    fi
fi

echo ${CMD}
