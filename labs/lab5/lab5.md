## Install KubeVirt

In this section, download the `kubevirt.yaml` file and explore it.  Then, apply it from the upstream github repo.

```
export VERSION=v0.10.0
```

We will precreate a specific configmap in the kube-system namespace in case nested virtualization is not enabled.
This allows kubevirt to use emulation mode in this case

```
grep -q vmx /proc/cpuinfo || oc create configmap -n kube-system kubevirt-config --from-literal debug.useEmulation=true
```

Grab the kubevirt.yaml file to explore. Review the ClusterRole's, CRDs, ServiceAccounts, DaemonSets, Deployments, and Services.

```
wget https://github.com/kubevirt/kubevirt/releases/download/$VERSION/kubevirt.yaml
less kubevirt.yaml
```

Install KubeVirt. You should see several objects were created.
 
```
oc apply -f https://github.com/kubevirt/kubevirt/releases/download/$VERSION/kubevirt.yaml
```

Define the following policies for OpenShift.

```
oc adm policy add-scc-to-user privileged -n kube-system -z kubevirt-privileged
oc adm policy add-scc-to-user privileged -n kube-system -z kubevirt-controller
oc adm policy add-scc-to-user privileged -n kube-system -z kubevirt-apiserver
```

Give permissions to the qemu user for persistent volume claims 

```
setfacl -m user:107:rwx /root/openshift.local.pv/pv*
```

Review the objects that KubeVirt added.

```
oc project kube-system
oc get sa | grep kubevirt
oc describe sa kubevirt-apiserver # Please feel free to explore the other objects as well. Get a feel for the expected output.
oc get pod
HANDLER_POD=$(oc get  pod -l kubevirt.io=virt-handler -o=custom-columns=NAME:.metadata.name --no-headers=true)
oc describe pod $HANDLER_POD
# review the files on the root of the filesystem of the pod, see the virt-handler executable
oc exec -it $HANDLER_POD ls /
oc get svc
oc describe svc virt-api
```

There are other services and objects to take a look at.

To review the objects through the OpenShift web console, access the console and log in as the `developer` user at `https://student<number>.cnvlab.gce.sysdeseng.com:8443`. Remember, you can use `oc cluster status` to get your URL.

Open that URL in a browser, log in as the `developer` user with a password of `developer`.

![openshift](images/openshift-console-login.png)

Explore the kube-system project by clicking on the `View All` link in the right hand navigation pane.

![openshift](images/openshift-console-view-all.png)

Browse to the `kube-system` project and explore the objects. Click on the different objects, explore the environment.

![openshift](images/openshift-console-kube-system.png)

#### Install virtctl

Return to the CLI and install virtctl. This tool provides quick access to the serial and graphical ports of a VM, and handle start/stop operations. Also run `virtctl` to get an idea of it's options.

```
export VERSION=v0.10.0
curl -L -o virtctl https://github.com/kubevirt/kubevirt/releases/download/$VERSION/virtctl-$VERSION-linux-amd64
chmod -v +x virtctl
./virtctl --help
```

This concludes this section of the lab.

[Next Lab](../lab6/lab6.md)\
[Previous Lab](../lab4/lab4.md)\
[Home](../../README.md)
