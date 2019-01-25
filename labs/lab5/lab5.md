## Install KubeVirt

In this section, let's download the `kubevirt.yaml` manifest file upstream github repo and explore it (you should have a copy on your lab machine). Then, we will deploy kubevirt with it.

Explore `~/kubevirt.yaml` file. Review the ClusterRole's, CRDs, ServiceAccounts, DaemonSets, Deployments, and Services.

Now, Install KubeVirt. You should see several objects were created.
 
```
oc apply -f /root/kubevirt.yaml
```

Sample Output:

```
namespace/kubevirt created
service/kubevirt-prometheus-metrics created
clusterrole.rbac.authorization.k8s.io/kubevirt.io:default created
clusterrolebinding.rbac.authorization.k8s.io/kubevirt.io:default created
clusterrole.rbac.authorization.k8s.io/kubevirt.io:admin created
clusterrole.rbac.authorization.k8s.io/kubevirt.io:edit created
clusterrole.rbac.authorization.k8s.io/kubevirt.io:view created
serviceaccount/kubevirt-privileged created
clusterrolebinding.rbac.authorization.k8s.io/kubevirt-privileged-cluster-admin created
serviceaccount/kubevirt-apiserver created
clusterrole.rbac.authorization.k8s.io/kubevirt-apiserver created
clusterrolebinding.rbac.authorization.k8s.io/kubevirt-apiserver created
clusterrolebinding.rbac.authorization.k8s.io/kubevirt-apiserver-auth-delegator created
role.rbac.authorization.k8s.io/kubevirt-apiserver created
rolebinding.rbac.authorization.k8s.io/kubevirt-apiserver created
serviceaccount/kubevirt-controller created
clusterrole.rbac.authorization.k8s.io/kubevirt-controller created
clusterrolebinding.rbac.authorization.k8s.io/kubevirt-controller created
service/virt-api created
deployment.apps/virt-api created
deployment.apps/virt-controller created
daemonset.apps/virt-handler created
customresourcedefinition.apiextensions.k8s.io/virtualmachineinstances.kubevirt.io created
customresourcedefinition.apiextensions.k8s.io/virtualmachineinstancereplicasets.kubevirt.io created
customresourcedefinition.apiextensions.k8s.io/virtualmachineinstancepresets.kubevirt.io created
customresourcedefinition.apiextensions.k8s.io/virtualmachines.kubevirt.io created
customresourcedefinition.apiextensions.k8s.io/virtualmachineinstancemigrations.kubevirt.io created
```

The following [SCCs](https://docs.openshift.com/container-platform/3.7/admin_guide/manage_scc.html) need to be added so that kubevirt controllers can launch privileged pods:

```
oc adm policy add-scc-to-user privileged -n kubevirt -z kubevirt-privileged
oc adm policy add-scc-to-user privileged -n kubevirt -z kubevirt-controller
oc adm policy add-scc-to-user privileged -n kubevirt -z kubevirt-apiserver
```

Review the objects that KubeVirt added.

```
oc project kubevirt
oc get serviceaccount | grep kubevirt
oc describe serviceaccount kubevirt-apiserver
oc get pod
HANDLER_POD=$(oc get pod -l kubevirt.io=virt-handler -o=custom-columns=NAME:.metadata.name --no-headers=true)
oc describe pod $HANDLER_POD
# review the files on the root of the filesystem of the pod, see the virt-handler executable
oc exec -it $HANDLER_POD ls /bin
oc get svc
oc describe svc virt-api
```

There are other services and objects to take a look at.

To review the objects through the OpenShift web console, access the console and log in as the `admin` user at `https://student<number>.cnvlab.gce.sysdeseng.com:8443`. Remember, you can use `oc status` to get your URL. Ignore the self signed certificate warning

Open that URL in a browser, log in as the `admin` user with a password of `admin`.

![openshift](images/openshift-console-login.png)

Explore the `kubevirt` project by clicking on the project link in the right hand navigation pane.

![openshift](images/openshift-console-view-all.png)

Click on the different objects, explore the environment.

#### Install virtctl

Return to the CLI and install virtctl. This tool provides quick access to the serial and graphical ports of a VM, and handle start/stop operations. Also run `virtctl` to get an idea of it's options.

```
export VERSION=v0.13.0
curl -L -o /usr/bin/virtctl https://github.com/kubevirt/kubevirt/releases/download/$VERSION/virtctl-$VERSION-linux-amd64
chmod -v +x /usr/bin/virtctl
virtctl version
```

This concludes this section of the lab.

[Next Lab](../lab6/lab6.md)\
[Previous Lab](../lab4/lab4.md)\
[Home](../../README.md)
