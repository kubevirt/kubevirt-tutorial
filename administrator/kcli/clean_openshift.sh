#!/bin/bash -x

OC_DIR=/root/openshift.local.clusterup

if [ -d $OC_DIR ]; 
  then
    oc cluster down
    for i in `mount | grep -i openshift | awk '{ print $3 }'`; do 
      umount $i; 
    done
  rm -rf $OC_DIR
  docker rmi --force $(docker images -q)
  else
    echo "System is clean."
fi
