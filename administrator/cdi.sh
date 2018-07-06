wget -P /root https://raw.githubusercontent.com/kubevirt/containerized-data-importer/v0.5.0/manifests/example/golden-pvc.yaml
wget -P /root https://raw.githubusercontent.com/kubevirt/containerized-data-importer/v0.5.0/example/endpoint-secret.yaml
wget -P /root https://raw.githubusercontent.com/kubevirt/containerized-data-importer/v0.5.0/manifests/controller/cdi-controller-deployment.yaml
oc new-project golden-images
oc create -f /root/cdi-controller-deployment.yaml
oc adm policy add-cluster-role-to-user cluster-admin -z cdi-sa -n golden-images

