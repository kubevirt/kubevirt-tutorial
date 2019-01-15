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
#yum -y update
