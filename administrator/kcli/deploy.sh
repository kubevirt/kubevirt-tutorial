[% if openshift %]
sh /root/requirements.sh
sh /root/openshift.sh
[% else %]
sh /root/kubernetes.sh
[% endif %]
sh /root/kubevirt.sh
sh /root/cdi.sh
