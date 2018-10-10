wget -P /root/ https://github.com/kubevirt/containerized-data-importer/releases/download/[[ cdi_version ]]/cdi-controller.yaml
wget -P /root https://github.com/kubevirt/containerized-data-importer/releases/download/[[ cdi_version ]]/golden-pvc.yaml
sed -i "s/namespace:.*/namespace: golden/" cdi-controller.yaml
kubectl create namespace golden
kubectl create -f /root/cdi-controller.yaml -n golden
