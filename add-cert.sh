#!/bin/sh
# author: joda
openssl=/usr/bin/openssl
certdir=$SSL_CERT_DIR
if [ ! -f $openssl ]; then
  echo "ERROR: Can't find $openssl. openssl-util installed?" >&2
fi
if [[ "$1" = "-f" ]]; then
   overwrite=1
   shift # remove $1
fi
 
if [ -f "$1" ]; then
  certfile=$1
  certname=`basename $certfile`
  echo "Certificate $certname"
  echo "  copy to $certdir"
  if [ "1" -ne "$overwrite" ] && [ -f "$certdir/$certname" ]; then
    echo >&2
    echo "ERROR: certificate $certname exists" >&2
    exit 2;
  fi
  cp "$1" "$certdir/$certname"
 
  # create symbolic link from hash
  echo -n "  generating hash: "
  HASH=`$openssl x509 -hash -noout -in $certfile`
  echo "$HASH"
 
  # handle hash collisions
  suffix=0
  while [ "1" -ne "$overwrite" ] && [ -h "$certdir/$HASH.$suffix" ]; do
    let "suffix += 1"
  done
  echo "  linking $HASH.$suffix -> $certname"
  if [ $overwrite ]; then
    ln -sf "$certname" "$certdir/$HASH.$suffix"
  else
    ln -s "$certname" "$certdir/$HASH.$suffix"
  fi
else
  echo >&2
  echo "ERROR: file does not exist $1" >&2
  echo >&2
  echo "This script adds (root) certificates for wget(ssl) to $certdir." >&2
  echo "SYNTAX: `basename $0` [Options] [x509-certificate]" >&2
  echo >&2
  echo "Option: -f      force overwriting if certificate exists" >&2
fi

