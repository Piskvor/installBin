#!/bin/bash

set -euxo pipefail

docker run --volume "$(pwd):/code" pipelinecomponents/shellcheck:latest shellcheck "$@"
