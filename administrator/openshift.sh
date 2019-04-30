#!/bin/bash

# Get our IP
IP=`ip a l  eth0 | grep 'inet ' | cut -d' ' -f6 | awk -F'/' '{ print $1}'`

# Use xip.io redirector as our domain
PUBLICNAME=$IP.xip.io

# Bring OpenShift Cluster up
oc cluster up --public-hostname $PUBLICNAME --routing-suffix $PUBLICNAME --enable=service-catalog,router,registry,web-console,persistent-volumes,rhel-imagestreams,automation-service-broker
oc login -u system:admin
docker update --restart=always origin
oc adm policy add-cluster-role-to-user cluster-admin developer
oc adm policy add-scc-to-user privileged system:serviceaccount:myvms:default
