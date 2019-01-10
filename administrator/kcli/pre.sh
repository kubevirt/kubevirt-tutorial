yum -y install NetworkManager wget nc git
{% if not crio %}
yum -y install docker
systemctl enable docker
systemctl start docker
{% endif %}
systemctl enable NetworkManager
systemctl start NetworkManager
#yum -y update
