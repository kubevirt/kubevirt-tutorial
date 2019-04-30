#!/bin/bash
# Check if docker is installed and running or continue
docker ps && echo Requirements already installed && exit 0

# Install docker, git, qemu, etc
yum -y install wget docker git bash-completion qemu-img

# Enable docker daemon
systemctl enable docker

# Enable insecure registry
sed -i "s@# INSECURE_REGISTRY=.*@INSECURE_REGISTRY='--insecure-registry 172.30.0.0/16'@" /etc/sysconfig/docker
sed -i "s@OPTIONS=.*@OPTIONS='--insecure-registry 172.30.0.0/16'@" /etc/sysconfig/docker

# Download OC binaries
wget -O /root/oc.tar.gz https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz

export HOME=/root
cd /root ; tar zxvf oc.tar.gz
mv /root/openshift-origin-client-tools-*/oc /usr/bin
rm -rf  /root/openshift-origin-client-tools-*

# Download kubectl
curl -L https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl -o /usr/bin/kubectl
chmod +x /usr/bin/kubectl

# Enable auxiliary script execution flag
chmod +x /root/*sh

# Start docker daemon
systemctl start docker --ignore-dependencies

# Download docker images
IMAGES="docker.io/openshift/origin-node:v3.11 docker.io/openshift/origin-control-plane:v3.11 docker.io/openshift/origin:v3.11 docker.io/openshift/origin-hypershift:v3.11 docker.io/openshift/origin-hyperkube:v3.11 docker.io/openshift/origin-pod:v3.11 docker.io/automationbroker/automation-broker-apb:latest docker.io/openshift/origin-cli:v3.11 quay.io/coreos/etcd:v3.3 docker.io/openshift/origin-service-catalog:v3.11 docker.io/openshift/origin-template-service-broker:v3.11 docker.io/ansibleplaybookbundle/origin-ansible-service-broker:latest docker.io/openshift/origin-web-console:v3.11 docker.io/openshift/origin-docker-registry:v3.11 docker.io/openshift/jenkins-2-centos7:v3.11 docker.io/centos/nodejs-6-centos7:latest"
for image in $IMAGES; do docker pull $image ; done
