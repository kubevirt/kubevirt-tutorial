sleep 60
docker ps && echo Requirements already installed && exit 0
sysctl -w net.ipv4.conf.all.forwarding=1
sysctl -w net.bridge.bridge-nf-call-iptables=1
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=permissive/" /etc/selinux/config
yum install -y wget docker kubelet-{{ kubernetes_version }} kubectl-{{ kubernetes_version }} kubeadm-{{ kubernetes_version }}
sed -i "s/--selinux-enabled //" /etc/sysconfig/docker
systemctl enable docker && systemctl start docker
systemctl enable kubelet && systemctl start kubelet
VERSION=v{{ kubernetes_version }}
IMAGES="k8s.gcr.io/kube-apiserver-amd64:$VERSION k8s.gcr.io/kube-scheduler-amd64:$VERSION k8s.gcr.io/kube-proxy-amd64:$VERSION k8s.gcr.io/kube-controller-manager-amd64:$VERSION k8s.gcr.io/etcd-amd64:3.1.12 k8s.gcr.io/kubernetes-dashboard-amd64:v1.8.3 k8s.gcr.io/k8s-dns-dnsmasq-nanny-amd64:1.14.8 k8s.gcr.io/k8s-dns-sidecar-amd64:1.14.8 k8s.gcr.io/k8s-dns-kube-dns-amd64:1.14.8 k8s.gcr.io/pause-amd64:3.1 quay.io/coreos/flannel:v0.7.1-amd64"
for image in $IMAGES; do docker pull $image ; done
sed -i "/sleep 60/d" /root/requirements.sh
