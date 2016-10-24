#!/bin/bash
set -e

# Disable Strict Host checking for non interactive git clones
mkdir -p -m 0700 /root/.ssh
echo -e "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

if [ -e /tmp/image ]; then
  rm /tmp/image -R
fi

git clone $GIT_REPO /tmp/image

timestamp() {
  date +"%T"
}

sed -i -e "s/ramdomreplace/$(timestamp)/g" /tmp/image/Dockerfile

docker build --build-arg svn_repo="$SVN_REPO" --build-arg svn_user="$SVN_USER" --build-arg svn_pass="$SVN_REPO" -t $IMAGE_INFOS /tmp/image/

docker login --username=$REPO_USER --password=$REPO_PASS --email=$REPO_EMAIL $DOCKER_REPO

docker tag $IMAGE_INFOS $DOCKER_REPO/$IMAGE_INFOS
docker push $DOCKER_REPO/$IMAGE_INFOS

exec "$@"
