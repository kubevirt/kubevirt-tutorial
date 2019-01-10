yum -y install NetworkManager wget nc git
{% if not crio %}
yum -y install docker
systemctl enable docker
systemctl start docker
{% endif %}
systemctl enable NetworkManager
systemctl start NetworkManager
#yum -y update
IMAGES="docker.io/kubevirt/virt-api:{{ kubevirt_version}} docker.io/kubevirt/virt-controller:{{ kubevirt_version}} docker.io/kubevirt/virt-handler:{{ kubevirt_version}} docker.io/kubevirt/virt-launcher:{{ kubevirt_version}} docker.io/kubevirt/cdi-uploadproxy:{{ cdi_version }} docker.io/kubevirt/cdi-apiserver:{{ cdi_version }} docker.io/kubevirt/cdi-importer:{{ cdi_version }} docker.io/kubevirt/cdi-controller:{{ cdi_version }}"
for image in $IMAGES; do docker pull $image ; done
