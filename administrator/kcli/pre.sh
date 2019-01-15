yum -y install NetworkManager wget nc git
yum -y install docker
systemctl enable docker
systemctl start docker
systemctl enable NetworkManager
systemctl start NetworkManager
ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa
PUBKEY=`cat ~/.ssh/id_rsa.pub`
sed -i "s%ssh-rsa.*%$PUBKEY%" /root/vm_containerdisk.yml
sed -i "s%ssh-rsa.*%$PUBKEY%" /root/vm_pvc.yml
sed -i "s%ssh-rsa.*%$PUBKEY%" /root/vm_multus1.yml
sed -i "s%ssh-rsa.*%$PUBKEY%" /root/vm_multus2.yml
wget -P /root https://github.com/kubevirt/kubevirt/releases/download/{{ kubevirt_version }}/kubevirt.yaml
wget -P /root https://github.com/kubevirt/containerized-data-importer/releases/download/{{ cdi_version }}/cdi-controller.yaml
#yum -y update
