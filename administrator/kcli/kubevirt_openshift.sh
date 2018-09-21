VERSION="[[ kubevirt_version ]]"
KUBELET_ROOTFS=$(docker inspect $(docker ps | grep kubelet | cut -d" " -f1) | grep MergedDir | cut -d: -f2 | sed 's/"//g' | sed 's/,//')
[ -z $KUBELET_ROOTFS ] && KUBELET_ROOTFS=/var/lib/docker/devicemapper/mnt/$(docker inspect $(docker ps | grep kubelet | cut -d" " -f1) | grep DeviceName  | awk -F- '{print $4}' | sed 's/",//')/rootfs
mkdir -p /var/lib/kubelet/device-plugins $KUBELET_ROOTFS/var/lib/kubelet/device-plugins
mount -o bind $KUBELET_ROOTFS/var/lib/kubelet/device-plugins /var/lib/kubelet/device-plugins
yum -y install xorg-x11-xauth virt-viewer
oc project kube-system
oc adm policy add-scc-to-user privileged -z kubevirt-privileged -n kube-system
oc adm policy add-scc-to-user privileged -z kubevirt-controller -n kube-system
[% if emulation or type == 'aws' %]
oc create configmap -n kube-system kubevirt-config --from-literal debug.useEmulation=true
[% endif %]
wget https://github.com/kubevirt/kubevirt/releases/download/$VERSION/kubevirt.yaml
oc create -f kubevirt.yaml
docker pull kubevirt/virt-launcher:$VERSION
wget https://github.com/kubevirt/kubevirt/releases/download/$VERSION/virtctl-$VERSION-linux-amd64
mv virtctl-$VERSION-linux-amd64 /usr/bin/virtctl
chmod u+x /usr/bin/virtctl
ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa
setfacl -m user:107:rwx /root/openshift.local.pv/pv*
oc adm policy add-scc-to-user privileged -z kubevirt-controller -n kube-system
