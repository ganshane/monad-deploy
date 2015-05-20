#!/bin/bash
if [ -z $REGISTRY ]; then
 REGISTRY="10.1.7.140"
fi

dockers=("dev")
num=${#dockers[@]}

w=$(pwd)
for (( i=0; i < num; i++ )); do
  docker=${dockers[i]}
  docker build -f dockers/$docker/Dockerfile -t monad-${docker} $w
done


