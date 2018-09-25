#!/bin/bash

set -euo pipefail

for i in $(seq 1 20); do
    for j in 24 25 26; do
        for f in $j.$i.*; do
            if [ -f  ${f} ] ; then
                k=$((j - 1))
                g=$(echo ${f} | sed "s/^$j/$k/")
                mv ${f} ${g}
            fi
        done
    done
done
