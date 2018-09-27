VERSION="[[ kubevirt_version ]]"
yum -y install xorg-x11-xauth virt-viewer
[% if emulation or type == 'aws' %]
kubectl create configmap -n kube-system kubevirt-config --from-literal debug.useEmulation=true
[% endif %]
wget https://github.com/kubevirt/kubevirt/releases/download/$VERSION/kubevirt.yaml
kubectl create -f kubevirt.yaml
docker pull kubevirt/virt-launcher:$VERSION
wget https://github.com/kubevirt/kubevirt/releases/download/$VERSION/virtctl-$VERSION-linux-amd64
mv virtctl-$VERSION-linux-amd64 /usr/bin/virtctl
chmod u+x /usr/bin/virtctl
ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa
