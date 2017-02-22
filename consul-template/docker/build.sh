#!/bin/bash
# Borrowed from https://github.com/skippy/docker-repo/blob/master/consul-template/build.sh

set -m

mkdir ${1}
cd ${1}
git clone https://github.com/hashicorp/consul-template
cd consul-template
git checkout ${1}

export XC_OS="linux"
export XC_ARCH="amd64"

make bin

cd ../..
mv ${1}/consul-template/pkg/linux_amd64/consul-template .

docker build -t sethkarlo/consul-template:${1} .

docker push sethkarlo/consul-template:${1}
