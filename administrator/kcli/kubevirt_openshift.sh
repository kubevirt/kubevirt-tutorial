VERSION="[[ kubevirt_version ]]"
yum -y install xorg-x11-xauth virt-viewer
oc project kube-system
oc adm policy add-scc-to-user privileged -z kubevirt-privileged -n kube-system
oc adm policy add-scc-to-user privileged -z kubevirt-controller -n kube-system
[% if emulation %]
oc create configmap -n kube-system kubevirt-config --from-literal debug.useEmulation=true
[% endif %]
wget https://github.com/kubevirt/kubevirt/releases/download/$VERSION/kubevirt.yaml
oc create -f kubevirt.yaml
docker pull kubevirt/virt-launcher:$VERSION
wget https://github.com/kubevirt/kubevirt/releases/download/$VERSION/virtctl-$VERSION-linux-amd64
mv virtctl-$VERSION-linux-amd64 /usr/bin/virtctl
chmod u+x /usr/bin/virtctl
ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa
setfacl -m user:107:rwx /root/openshift.local.clusterup/openshift.local.pv/pv*
oc adm policy add-scc-to-user privileged -z kubevirt-controller -n kube-system
