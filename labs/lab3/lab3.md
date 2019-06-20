# Lab 3: Deploy KubeVirt/CDI/UI

In this section we're going to deploy the following three components:

* The [KubeVirt Operator](https://github.com/kubevirt/kubevirt) provides a set of Custom Resource Definitions (CRDs) and components required to manage VMs inside Kubernetes
* The Containerized Data Importer [(CDI) Operator](https://github.com/kubevirt/containerized-data-importer) provides another set of CRDs to facilitate the management of persistent storage for KubeVirt-based VMs
* The [KubeVirt Web UI](https://github.com/kubevirt/web-ui) provides a graphical environment to manage VM based workloads

## Install the KubeVirt Operator

We're going to start with the KubeVirt operator.

Connect to your assigned instance and execute the following steps:

```console
$ cd ~/kubevirt/kubevirt-operator-manifests
$ kubectl create -f kubevirt-operator.yaml
$ kubectl config set-context $(kubectl config current-context) --namespace=kubevirt
$ kubectl wait deployment virt-operator --for condition=available
deployment.extensions/virt-operator condition met

$ kubectl create -f kubevirt-cr.yaml
$ kubectl wait kubevirt kubevirt --for condition=ready
kubevirt.kubevirt.io/kubevirt condition met
```

Let's explore what is being deployed as a result:

```console
$ kubectl get all -l kubevirt.io

NAME                                   READY   STATUS    RESTARTS   AGE
pod/virt-api-58554748d5-5lzsd          1/1     Running   0          100m
pod/virt-api-58554748d5-rg5rk          1/1     Running   0          100m
pod/virt-controller-76765f49f9-wphx9   1/1     Running   0          99m
pod/virt-controller-76765f49f9-xdhlp   1/1     Running   0          99m
pod/virt-handler-4nv45                 1/1     Running   0          99m
pod/virt-operator-5ddb4674b9-cj2s6     1/1     Running   0          101m
pod/virt-operator-5ddb4674b9-kvd8r     1/1     Running   0          101m

NAME                                  TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/kubevirt-prometheus-metrics   ClusterIP   10.110.103.5   <none>        443/TCP   100m
service/virt-api                      ClusterIP   10.97.212.57   <none>        443/TCP   100m

NAME                          DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/virt-handler   1         1         1       1            1           <none>          99m

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/virt-api          2/2     2            2           100m
deployment.apps/virt-controller   2/2     2            2           99m
deployment.apps/virt-operator     2/2     2            2           101m

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/virt-api-58554748d5          2         2         2       100m
replicaset.apps/virt-controller-76765f49f9   2         2         2       99m
replicaset.apps/virt-operator-5ddb4674b9     2         2         2       101m
```

Let's verify the KubeVirt API is reachable:

```console
$ virtctl version

Client Version: version.Info{GitVersion:"v0.17.0", GitCommit:"c0f960702dce718419a767f3913669f539229ff0", GitTreeState:"clean", BuildDate:"2019-05-05T08:09:14Z", GoVersion:"go1.11.5", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{GitVersion:"v0.17.0", GitCommit:"a067696ed6c25b0eab9dfcd01bbdc045f500f8ca", GitTreeState:"clean", BuildDate:"2019-05-06T14:58:11Z", GoVersion:"go1.11.5", Compiler:"gc", Platform:"linux/amd64"}
```
### Exercise

Check that a few new Custom Resource Definitions (CRDs) are now available in the cluster.

What are these? What is their purpose? How do they look like?

Do you see any instance of any of these Custom Resources?

## Install the CDI operator

```console
$ cd ~/kubevirt/cdi-operator-manifests
$ kubectl create -f cdi-operator.yaml
$ kubectl config set-context $(kubectl config current-context) --namespace=cdi
$ kubectl wait deployment cdi-operator --for condition=available
deployment.extensions/cdi-operator condition met

$ kubectl create -f cdi-operator-cr.yaml
$ kubectl wait cdi cdi --for condition=running
cdi.cdi.kubevirt.io/cdi condition met
```

Now, let's see what we've got deployed:

```console
$ kubectl get all
NAME                                  READY   STATUS    RESTARTS   AGE
pod/cdi-apiserver-d88b544bb-cbm27     1/1     Running   0          85m
pod/cdi-deployment-6875d8bff8-qnp4p   1/1     Running   0          85m
pod/cdi-operator-5f58bbbbcf-gmk2t     1/1     Running   0          87m
pod/cdi-uploadproxy-cddbb95b-6dzkd    1/1     Running   0          85m

NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/cdi-api           ClusterIP   10.103.200.116   <none>        443/TCP   85m
service/cdi-uploadproxy   ClusterIP   10.103.55.72     <none>        443/TCP   85m

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/cdi-apiserver     1/1     1            1           85m
deployment.apps/cdi-deployment    1/1     1            1           85m
deployment.apps/cdi-operator      1/1     1            1           87m
deployment.apps/cdi-uploadproxy   1/1     1            1           85m

NAME                                        DESIRED   CURRENT   READY   AGE
replicaset.apps/cdi-apiserver-d88b544bb     1         1         1       85m
replicaset.apps/cdi-deployment-6875d8bff8   1         1         1       85m
replicaset.apps/cdi-operator-5f58bbbbcf     1         1         1       87m
replicaset.apps/cdi-uploadproxy-cddbb95b    1         1         1       85m
```

## Enable Prometheus to scrap KubeVirt metrics

```console
$ cd ~/student-materials
$ kubectl create -f kubevirt-servicemonitor.yml
servicemonitor.monitoring.coreos.com/kubevirtlab-kubevirt created
```

## Recap

Let's summarize what happened on this lab:

* We have installed the KubeVirt and CDI operators:
  * The operators enabled us to create instances of KubeVirt and CDI as Custom Resources (CRs).
  * By creating CRs for both KubeVirt and CDI, the operators deployed the necessary KubeVirt and CDI components.
* We verified that KubeVirt's API is available using *virtctl*, the CLI tool to manage KubeVirt VMs.
* Finally, we've deployed a *ServiceMonitor* object to ask Prometheus to scrap the KubeVirt components, including the VMs we'll be running in subsequent labs.


This concludes this section, take your time to review what's been deployed, all the resources, etc and then head off to the next lab!

[Next Lab](../lab4/lab4.md)\
[Previous Lab](../lab2/lab2.md)\
[Home](../../README.md)
