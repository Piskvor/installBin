#!/bin/sh

touch ${SSH_KEY_FILE:=/id_rsa}
chmod 0400 ${SSH_KEY_FILE:=/id_rsa}

STRICT_HOSTS_KEY_CHECKING=no
KNOWN_HOSTS=${KNOWN_HOSTS_FILE:=/known_hosts}
if [ -f "${KNOWN_HOSTS}" ]; then
    chmod 0400 ${KNOWN_HOSTS}
    KNOWN_HOSTS_ARG="-o UserKnownHostsFile=${KNOWN_HOSTS}"
    STRICT_HOSTS_KEY_CHECKING=yes
fi

CONFIG_FILE=${SSH_CONFIG_FILE:=/ssh_config}
if [ -f "${CONFIG_FILE}" ]; then
    chmod 0400 ${CONFIG_FILE}
    CONFIG_FILE_ARG="-F ${CONFIG_FILE}"
fi

if [ ! -z "${SSH_HOSTPORT:=}" ]; then
    HOSTPORT_ARG="-p ${SSH_HOSTPORT}"
fi

# Pick a random port above 32768
DEFAULT_PORT=$RANDOM
let "DEFAULT_PORT += 32768"
echo [INFO] Tunneling ${SSH_HOSTUSER:=root}@${SSH_HOSTNAME:=localhost}:${SSH_TUNNEL_REMOTE:=${DEFAULT_PORT}} to ${SSH_TUNNEL_HOST=localhost}:${SSH_TUNNEL_LOCAL:=22}

echo autossh \
 ${CONFIG_FILE_ARG:=} \
 -M 0 \
 -N \
 -o StrictHostKeyChecking=${STRICT_HOSTS_KEY_CHECKING} ${KNOWN_HOSTS_ARG:=} \
 -o ServerAliveInterval=5 \
 -o ServerAliveCountMax=1 \
 -o IdentitiesOnly=yes \
 -o VisualHostKey=yes \
 -t -t \
 -i ${SSH_KEY_FILE:=/id_rsa} \
 ${SSH_MODE:=-R} ${SSH_TUNNEL_REMOTE}:${SSH_TUNNEL_HOST}:${SSH_TUNNEL_LOCAL} \
 ${HOSTPORT_ARG:=} \
 ${SSH_EXTRA_OPTIONS:=} \
 ${SSH_HOSTUSER}@${SSH_HOSTNAME}

AUTOSSH_PIDFILE=/autossh.pid \
AUTOSSH_POLL=10 \
AUTOSSH_LOGLEVEL=2 \
AUTOSSH_LOGFILE=/dev/stdout \
autossh \
 ${CONFIG_FILE_ARG:=} \
 -M 0 \
 -N \
 -o StrictHostKeyChecking=${STRICT_HOSTS_KEY_CHECKING} ${KNOWN_HOSTS_ARG:=}  \
 -o ServerAliveInterval=5 \
 -o ServerAliveCountMax=1 \
 -o IdentitiesOnly=yes \
 -o VisualHostKey=yes \
 -t -t \
 -i ${SSH_KEY_FILE:=/id_rsa} \
 ${SSH_MODE:=-R} ${SSH_TUNNEL_REMOTE}:${SSH_TUNNEL_HOST}:${SSH_TUNNEL_LOCAL} \
 ${HOSTPORT_ARG:=} \
 ${SSH_EXTRA_OPTIONS:=} \
 ${SSH_HOSTUSER}@${SSH_HOSTNAME} 2>&1 | ts '[%Y-%m-%d %H:%M:%S]'
