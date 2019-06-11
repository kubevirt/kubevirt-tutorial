# Lab 2

## Review Kubernetes environment

For the sake of time, some of the required setup have already been taken care of. The following was done as part of the deployment:

* Installed Kubernetes prerequisites
* Deployed Kubernetes using *kubeadm*, it's single node cluster
* Deployed all the networking components:
  * Deployed [Flannel](https://coreos.com/flannel/docs/latest/)
  * Deployed [Multus CNI](https://01.org/kubernetes/building-blocks/multus-cni)
  * Deployed [OVS CNI](https://github.com/kubevirt/ovs-cni)
* Deployed [local volumes provisioner](https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner)
* Deployed [Prometheus Operator](https://github.com/coreos/prometheus-operator)
  * [Prometheus](https://prometheus.io)  with its components
  * [Grafana](https://grafana.com)
* Lab manifests have been copied over to your *$HOME/student-materials*

### Verify the cluster

Let's ask the cluster for its status:

```console
$ kubectl version

Client Version: version.Info{Major:"1", Minor:"14", GitVersion:"v1.14.2", GitCommit:"66049e3b21efe110454d67df4fa62b08ea79a19b", GitTreeState:"clean", BuildDate:"2019-05-16T16:23:09Z", GoVersion:"go1.12.5", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"14", GitVersion:"v1.14.2", GitCommit:"66049e3b21efe110454d67df4fa62b08ea79a19b", GitTreeState:"clean", BuildDate:"2019-05-16T16:14:56Z", GoVersion:"go1.12.5", Compiler:"gc", Platform:"linux/amd64"}
```

Now let's check that the physical volumes are ready and available:

```console
$ kubectl get pv

NAME                CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS    REASON   AGE
local-pv-234582fe   5109Mi     RWO            Delete           Available           local-volumes            2d
local-pv-5d33c489   5109Mi     RWO            Delete           Available           local-volumes            2d
local-pv-6035a584   5109Mi     RWO            Delete           Available           local-volumes            2d
local-pv-a56cebb5   5109Mi     RWO            Delete           Available           local-volumes            2d
```

And finally, let's check that Prometheus and Grafana are running and exposed:

```console
$ kubectl get all -n prometheus

NAME                                                         READY   STATUS    RESTARTS   AGE
pod/alertmanager-kubevirtlab-prometheus-ope-alertmanager-0   2/2     Running   0          2d
pod/kubevirtlab-grafana-bf9db4bd9-r8pmt                      2/2     Running   0          2d
pod/kubevirtlab-kube-state-metrics-6544b5778c-gvqc9          1/1     Running   0          2d
pod/kubevirtlab-prometheus-node-exporter-8dp4d               1/1     Running   0          2d
pod/kubevirtlab-prometheus-ope-operator-78d5bbf8ff-rx9kv     1/1     Running   0          2d
pod/prometheus-kubevirtlab-prometheus-ope-prometheus-0       3/3     Running   0          2d

NAME                                              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
service/alertmanager-operated                     ClusterIP   None             <none>        9093/TCP,6783/TCP   2d
service/kubevirtlab-grafana                       ClusterIP   10.96.1.202      <none>        80/TCP              2d
service/kubevirtlab-grafana-nodeport              NodePort    10.111.14.110    <none>        3000:30300/TCP      2d
service/kubevirtlab-kube-state-metrics            ClusterIP   10.101.96.232    <none>        8080/TCP            2d
service/kubevirtlab-prometheus-node-exporter      ClusterIP   10.99.86.74      <none>        9100/TCP            2d
service/kubevirtlab-prometheus-ope-alertmanager   ClusterIP   10.105.253.180   <none>        9093/TCP            2d
service/kubevirtlab-prometheus-ope-operator       ClusterIP   10.109.209.37    <none>        8080/TCP            2d
service/kubevirtlab-prometheus-ope-prometheus     NodePort    10.109.224.249   <none>        9090:30090/TCP      2d
service/prometheus-operated                       ClusterIP   None             <none>        9090/TCP            2d

NAME                                                  DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/kubevirtlab-prometheus-node-exporter   1         1         1       1            1           <none>          2d

NAME                                                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/kubevirtlab-grafana                   1/1     1            1           2d
deployment.apps/kubevirtlab-kube-state-metrics        1/1     1            1           2d
deployment.apps/kubevirtlab-prometheus-ope-operator   1/1     1            1           2d

NAME                                                             DESIRED   CURRENT   READY   AGE
replicaset.apps/kubevirtlab-grafana-bf9db4bd9                    1         1         1       2d
replicaset.apps/kubevirtlab-kube-state-metrics-6544b5778c        1         1         1       2d
replicaset.apps/kubevirtlab-prometheus-ope-operator-78d5bbf8ff   1         1         1       2d

NAME                                                                    READY   AGE
statefulset.apps/alertmanager-kubevirtlab-prometheus-ope-alertmanager   1/1     2d
statefulset.apps/prometheus-kubevirtlab-prometheus-ope-prometheus       1/1     2d
```

Notice that both *PromUI* and *Grafana* have been exposed on the node's ports 30090/tcp and 30300/tcp, both can be accessed with the following details:

* PromUI
  * http://<span></span>kubevirtlab-\<number\>.gce.sexylinux.net:30090
* Grafana
  * http://<span></span>kubevirtlab-\<number\>.gce.sexylinux.net:30300
  * Username: admin
  * Password: kubevirtlab123

## Recap

* We've reviewed the available PVs in the cluster that we'll use later on
* We've reviewed the Prometheus deployment, Grafana and PromUI services exposed on the node

This concludes this section of the lab.

[Next Lab](../lab3/lab3.md)\
[Previous Lab](../lab1/lab1.md)\
[Home](../../README.md)
