[%- set releaseurls = {
                  '3.10' : 'v3.10.0-rc.0/openshift-origin-client-tools-v3.10.0-rc.0-c20e215',
                  '3.11' : 'v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b',
               }
-%]
sleep 60
sysctl -w net.ipv4.ip_forward=1
docker ps && echo Requirements already installed && exit 0
yum -y install wget docker git bash-completion qemu-img
systemctl enable docker
sed -i "s@# INSECURE_REGISTRY=.*@INSECURE_REGISTRY='--insecure-registry 172.30.0.0/16'@" /etc/sysconfig/docker
wget -O /root/oc.tar.gz https://github.com/openshift/origin/releases/download/[[ releaseurls[openshift_version] ]]-linux-64bit.tar.gz
export HOME=/root
cd /root ; tar zxvf oc.tar.gz
mv /root/openshift-origin-client-tools-*/oc /usr/bin
rm -rf  /root/openshift-origin-client-tools-*
curl -L https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl -o /usr/bin/kubectl
chmod +x /usr/bin/kubectl
chmod +x /root/*sh
sed -i "s@OPTIONS=.*@OPTIONS='--selinux-enabled --insecure-registry 172.30.0.0/16'@" /etc/sysconfig/docker
systemctl start docker --ignore-dependencies
IMAGES="docker.io/openshift/origin-node:v3.10 docker.io/openshift/origin-control-plane:v3.10 docker.io/openshift/origin:v3.10 docker.io/openshift/origin-hypershift:v3.10 docker.io/openshift/origin-hyperkube:v3.10 docker.io/openshift/origin-pod:v3.10 docker.io/automationbroker/automation-broker-apb:latest docker.io/openshift/origin-cli:v3.10 quay.io/coreos/etcd:v3.3 docker.io/openshift/origin-service-catalog:v3.10 docker.io/openshift/origin-template-service-broker:v3.10 docker.io/ansibleplaybookbundle/origin-ansible-service-broker:latest docker.io/openshift/origin-web-console:v3.10 docker.io/openshift/origin-docker-registry:v3.10 docker.io/openshift/jenkins-2-centos7:v3.10 docker.io/centos/nodejs-6-centos7:latest"
for image in $IMAGES; do docker pull $image ; done
KUBEVIRT_IMAGES="docker.io/kubevirt/virt-api:[[ kubevirt_version]] docker.io/kubevirt/virt-controller:[[ kubevirt_version]] docker.io/kubevirt/virt-handler:[[ kubevirt_version]] docker.io/kubevirt/virt-launcher:[[ kubevirt_version]]"
for image in $KUBEVIRT_IMAGES; do docker pull $image ; done
sed -i "/sleep 60/d" /root/requirements.sh
