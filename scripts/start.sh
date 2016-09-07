#!/bin/bash
set -e

# Disable Strict Host checking for non interactive git clones
mkdir -p -m 0700 /root/.ssh
echo -e "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

docker build -t $IMAGEINFOS $GITREPO

docker tag $IMAGEINFOS $DOCKERREPO/$IMAGEINFOS
docker push $DOCKERREPO/$IMAGEINFOS

exec "$@"
