## Install KubeVirt

In this section, let's use the `kubevirt-operator.yaml` and `kubevirt-cr.yaml` manifest files from upstream github repo and explore it (you should have a copy on your lab machine). Then, we will deploy kubevirt with it.

Explore `~/kubevirt-operator.yaml` file. Review the objects it contains

Now, Install KubeVirt Operator . You should see several objects were created.
 
```
oc apply -f ~/kubevirt-operator.yaml
```

Sample Output:

```
namespace/kubevirt created
customresourcedefinition.apiextensions.k8s.io/kubevirts.kubevirt.io created
clusterrole.rbac.authorization.k8s.io/kubevirt.io:operator created
serviceaccount/kubevirt-operator created
clusterrolebinding.rbac.authorization.k8s.io/kubevirt-operator created
deployment.apps/virt-operator created

```

Now, Install KubeVirt
 
```
oc apply -f ~/kubevirt-cr.yaml
```

Sample Output:

```
kubevirt.kubevirt.io/kubevirt created
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
export VERSION=v0.14.0
curl -L -o /usr/bin/virtctl https://github.com/kubevirt/kubevirt/releases/download/$VERSION/virtctl-$VERSION-linux-amd64
chmod -v +x /usr/bin/virtctl
virtctl version
```

This concludes this section of the lab.

[Next Lab](../lab6/lab6.md)\
[Previous Lab](../lab4/lab4.md)\
[Home](../../README.md)
