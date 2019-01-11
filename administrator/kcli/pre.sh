yum -y install NetworkManager wget nc git
yum -y install docker
systemctl enable docker
systemctl start docker
systemctl enable NetworkManager
systemctl start NetworkManager
#yum -y update
