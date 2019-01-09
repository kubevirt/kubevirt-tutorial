#!/bin/bash


NODES=`oc get node -l node-role.kubernetes.io/compute=true --template '{{ range .items}}{{.metadata.name}} {{end}}'`

for N in ${NODES};
do
	ssh ${N} ovs-vsctl add-br br1
	ssh ${N} ovs-vsctl add-port br1 eth1
done
