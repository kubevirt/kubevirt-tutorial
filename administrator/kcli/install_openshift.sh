#!/bin/bash
curl -o ansible.rpm https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-2.6.5-1.el7.ans.noarch.rpm
yum -y install epel-release wget git bind-utils ansible.rpm
git clone -b release-3.11 https://github.com/openshift/openshift-ansible /root/openshift-ansible
mkdir /var/lib/etcd
semanage fcontext -a -t container_file_t /var/lib/etcd
restorecon -v /var/lib/etcd
sed -i "s/#host_key_checking/host_key_checking = True/" /etc/ansible/ansible.cfg
sed -i "s/#log_path/log_path/" /etc/ansible/ansible.cfg
ansible-playbook -i /root/inventory /root/openshift-ansible/playbooks/prerequisites.yml
ansible-playbook -i /root/inventory /root/openshift-ansible/playbooks/deploy_cluster.yml
ansible-playbook -i /root/inventory /root/multus.yml
sh /root/nfs.sh
IMAGES="docker.io/kubevirt/virt-api:{{ kubevirt_version}} docker.io/kubevirt/virt-controller:{{ kubevirt_version}} docker.io/kubevirt/virt-handler:{{ kubevirt_version}} docker.io/kubevirt/virt-launcher:{{ kubevirt_version}} docker.io/kubevirt/cdi-uploadproxy:{{ cdi_version }} docker.io/kubevirt/cdi-apiserver:{{ cdi_version }} docker.io/kubevirt/cdi-importer:{{ cdi_version }} docker.io/kubevirt/cdi-controller:{{ cdi_version }} docker.io/kubevirt/fedora-cloud-container-disk-demo:latest"
{% if crio %}
for image in $IMAGES; do crictl pull $image ; done
{% else %}
for image in $IMAGES; do docker pull $image ; done
{% endif %}
