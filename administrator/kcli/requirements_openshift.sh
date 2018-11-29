{%- set releaseurls = {
                  'v3.9'  : 'v3.9.0/openshift-origin-client-tools-v3.9.0-191fece',
                  'v3.10' : 'v3.10.0-rc.0/openshift-origin-client-tools-v3.10.0-rc.0-c20e215',
                  'v3.11' : 'v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b',
               }
-%}
sleep 60
docker ps && echo Requirements already installed && exit 0
sysctl -w net.ipv4.ip_forward=1
yum -y install wget docker git bash-completion qemu-img
systemctl enable docker
sed -i "s@# INSECURE_REGISTRY=.*@INSECURE_REGISTRY='--insecure-registry 172.30.0.0/16'@" /etc/sysconfig/docker
wget -O /root/oc.tar.gz https://github.com/openshift/origin/releases/download/{{ releaseurls[openshift_version] }}-linux-64bit.tar.gz
export HOME=/root
cd /root ; tar zxvf oc.tar.gz
mv /root/openshift-origin-client-tools-*/oc /usr/bin
rm -rf  /root/openshift-origin-client-tools-*
curl -L https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl -o /usr/bin/kubectl
chmod +x /usr/bin/kubectl
chmod +x /root/*sh
sed -i "s@OPTIONS=.*@OPTIONS='--selinux-enabled --insecure-registry 172.30.0.0/16'@" /etc/sysconfig/docker
systemctl start docker --ignore-dependencies
IMAGES="docker.io/openshift/origin-node:{{ openshift_version }} docker.io/openshift/origin-control-plane:{{ openshift_version }} docker.io/openshift/origin:{{ openshift_version }} docker.io/openshift/origin-hypershift:{{ openshift_version }} docker.io/openshift/origin-hyperkube:{{ openshift_version }} docker.io/openshift/origin-pod:{{ openshift_version }} docker.io/automationbroker/automation-broker-apb:latest docker.io/openshift/origin-cli:{{ openshift_version }} quay.io/coreos/etcd:v3.3 docker.io/openshift/origin-service-catalog:{{ openshift_version }} docker.io/openshift/origin-template-service-broker:{{ openshift_version }} docker.io/ansibleplaybookbundle/origin-ansible-service-broker:latest docker.io/openshift/origin-web-console:{{ openshift_version }} docker.io/openshift/origin-docker-registry:{{ openshift_version }} docker.io/openshift/jenkins-2-centos7:{{ openshift_version }} docker.io/centos/nodejs-6-centos7:latest"
for image in $IMAGES; do docker pull $image ; done
KUBEVIRT_IMAGES="docker.io/kubevirt/virt-api:{{ kubevirt_version}} docker.io/kubevirt/virt-controller:{{ kubevirt_version}} docker.io/kubevirt/virt-handler:{{ kubevirt_version}} docker.io/kubevirt/virt-launcher:{{ kubevirt_version}}"
for image in $KUBEVIRT_IMAGES; do docker pull $image ; done
sed -i "/sleep 60/d" /root/requirements.sh
