wget -P /root https://raw.githubusercontent.com/kubevirt/containerized-data-importer/[[ cdi_version ]]/manifests/example/golden-pvc.yaml
wget -P /root https://raw.githubusercontent.com/kubevirt/containerized-data-importer/[[ cdi_version ]]/manifests/controller/cdi-controller-deployment.yaml
oc new-project golden-images
oc create -f /root/cdi-controller-deployment.yaml
oc adm policy add-cluster-role-to-user cluster-admin -z cdi-sa -n golden-images
