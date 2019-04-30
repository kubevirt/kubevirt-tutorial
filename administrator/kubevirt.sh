#!/bin/bash
VERSION="v0.11.0"

# Instal x11 virt viewer
yum -y install xorg-x11-xauth virt-viewer

# Install virctl utility
wget https://github.com/kubevirt/kubevirt/releases/download/$VERSION/virtctl-$VERSION-linux-amd64
mv virtctl-$VERSION-linux-amd64 /usr/bin/virtctl
chmod u+x /usr/bin/virtctl

# Deploy kubevirt
oc project kube-system
wget https://github.com/kubevirt/kubevirt/releases/download/$VERSION/kubevirt.yaml
oc adm policy add-scc-to-user privileged -z kubevirt-privileged -n kube-system
oc adm policy add-scc-to-user privileged -z kubevirt-controller -n kube-system

oc create -f kubevirt.yaml
docker pull kubevirt/virt-launcher:$VERSION

ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa
setfacl -m user:107:rwx /root/openshift.local.pv/pv*
oc adm policy add-scc-to-user privileged -z kubevirt-controller -n kube-system
