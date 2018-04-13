#!/bin/sh

set -uxo pipefail
touch ${SSH_KEY_FILE:=/id_rsa} || true
chmod 0400 ${SSH_KEY_FILE:=/id_rsa} || true

if [ ! -x "${AUTOSSH:=}" ]; then
    AUTOSSH=$(which autossh)
fi
if [ ! -x "${SSH:=}" ]; then
    SSH=$(which ssh)
fi
STRICT_HOSTS_KEY_CHECKING=no
KNOWN_HOSTS=${SSH_KNOWN_HOSTS:=/known_hosts}
if [ -f "${KNOWN_HOSTS}" ]; then
    chmod 0400 ${KNOWN_HOSTS} || true
    KNOWN_HOSTS_ARG="-o UserKnownHostsFile=${KNOWN_HOSTS}"
    STRICT_HOSTS_KEY_CHECKING=yes
fi

CONFIG_FILE=${SSH_CONFIG_FILE:=/ssh_config}
if [ -f "${CONFIG_FILE}" ]; then
    chmod 0400 ${CONFIG_FILE} || true
    CONFIG_FILE_ARG="-F ${CONFIG_FILE}"
fi

SSH_CONTROL_PATH_ARG=""
export SSH_CONTROL_PATH_EXISTS=0
cleanup() {
    if [ "${SSH_CONTROL_PATH_EXISTS:=}" != "1" ]; then
        rm -f -- "$SSH_CONTROL_PATH"
    fi
}
trap "cleanup" INT TERM QUIT ABRT HUP EXIT
if [ "${SSH_CONTROL_PATH:=}" != "" ] && [ -e "${SSH_CONTROL_PATH:=}" ]; then
    if (${SSH} ${CONFIG_FILE_ARG:=} -O check ${SSH_HOSTUSER}@${SSH_HOSTNAME}) ; then
        SSH_CONTROL_PATH_EXISTS=1
    else
        if [ "${REMOVE_BROKEN_SSHMUX:=}" = "1" ]; then
            cleanup
        fi
    fi
fi

if [ "${SSH_CONTROL_PATH:=}" != "" ]; then
    SSH_CONTROL_PATH_ARG="-o ControlPath=${SSH_CONTROL_PATH}"
fi

if [ ! -z "${SSH_HOSTPORT:=}" ]; then
    HOST_PORT_ARG="-p ${SSH_HOSTPORT}"
fi

# Pick a random port above 32768
DEFAULT_PORT=$RANDOM
let "DEFAULT_PORT += 32768"
echo [INFO] Tunneling ${SSH_HOSTUSER:=root}@${SSH_HOSTNAME:=localhost}:${SSH_TUNNEL_REMOTE:=${DEFAULT_PORT}} to ${SSH_TUNNEL_HOST=localhost}:${SSH_TUNNEL_LOCAL:=22}
let "DEFAULT_PORT += 1"

AUTOSSH_PIDFILE=/autossh.pid \
AUTOSSH_FIRST_POLL=${AUTOSSH_FIRST_POLL:-30} \
AUTOSSH_GATETIME=${AUTOSSH_GATETIME:-60} \
AUTOSSH_POLL=${AUTOSSH_POLL:-10} \
AUTOSSH_LOGLEVEL=${AUTOSSH_LOGLEVEL:-2} \
AUTOSSH_LOGFILE=/dev/stdout \
${AUTOSSH} \
 -M ${DEFAULT_PORT:=0} \
 ${CONFIG_FILE_ARG:=} \
 -N \
 -o StrictHostKeyChecking=${STRICT_HOSTS_KEY_CHECKING} ${KNOWN_HOSTS_ARG:=}  \
 -o ServerAliveInterval=3 \
 -o ServerAliveCountMax=1 \
 -o IdentitiesOnly=yes \
 -o BatchMode=yes \
 -o VisualHostKey=yes \
 ${SSH_CONTROL_PATH_ARG:=} \
 ${SSH_EXTRA_OPTIONS:=} \
 -t -t \
 -i ${SSH_KEY_FILE:=/id_rsa} \
 ${SSH_MODE:=-R} ${SSH_TUNNEL_REMOTE}:${SSH_TUNNEL_HOST}:${SSH_TUNNEL_LOCAL} \
 ${HOST_PORT_ARG:=} \
 ${SSH_HOSTUSER}@${SSH_HOSTNAME} 2>&1 | ts '[%Y-%m-%d %H:%M:%S]'
