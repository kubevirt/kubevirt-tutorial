#!/bin/bash -x

KUBE_DIR=/root/.kube

if [ -d $KUBE_DIR ]; 
  then
      kubectl drain `hostname` --delete-local-data --force --ignore-daemonsets
      kubeadm reset
  docker rmi --force $(docker images -q)
  else
    echo "System is clean."
fi
