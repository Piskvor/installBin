#!/bin/bash
set -uxo pipefail
# Stop all containers
#docker stop $(docker ps -a -q)
# Delete all containers
docker rm $(docker ps -a -q)
# Delete all images
docker rmi $(docker images -q)

# Delete all dangling volumes
docker volume prune -f || true
