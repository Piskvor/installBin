#!/bin/sh

export HTTP_PROXY=http://${1:-threepio}:${2:-8888}/
export HTTPS_PROXY=${HTTP_PROXY}
export http_proxy=${HTTP_PROXY}
export https_proxy=${HTTP_PROXY}

