wget -P /root https://raw.githubusercontent.com/kubevirt/containerized-data-importer/[[ cdi_version ]]/manifests/example/golden-pvc.yaml
wget -P /root https://raw.githubusercontent.com/kubevirt/containerized-data-importer/[[ cdi_version ]]/manifests/controller/cdi-controller-deployment.yaml
kubectl create namespace golden-images
kubectl create -f /root/cdi-controller-deployment.yaml -n golden-images
