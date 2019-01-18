## Experiment with CDI

[CDI](https://github.com/kubevirt/containerized-data-importer) is an utility designed to import Virtual Machine images for use with Kubevirt. 

At a high level, a persistent volume claim (PVC) is created. A custom controller watches for importer specific claims, and when discovered, starts an import process to create a raw image named *disk.img* with the desired content into the associated PVC.

#### Install CDI

To install Cdi, we apply the proper manifest, along with the proper SCCs

```
oc adm policy add-scc-to-user privileged system:serviceaccount:kube-system:default
oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:kube-system:cdi-apiserver
oc create -f ~/cdi-controller.yaml
```

Review the objects that were added. Note the pods starting with *cdi*

```
oc get pods -n kube-system
```

You should see some thing like this:

```
# oc get pods -n kube-system | grep cdi
cdi-apiserver-7f46fd54f4-8fn2m    1/1       Running   0          41s
cdi-deployment-c8b8cbf66-pn48q    1/1       Running   0          40s
cdi-uploadproxy-7d87748cb-6cdpz   1/1       Running   0          41s
```

#### Use CDI

As an example, we will import a Cirros Cloud Image as a PVC and launch a Virtual Machine making use of it.

```
oc project myproject
oc create -f ~/pvc_cirros.yml
```

This will create the PVC with a proper annotation so that CDI controller detects it and launches an importer pod to gather the image specified in the *cdi.kubevirt.io/storage.import.endpoint* annotation.

```
oc get pvc cirros -o yaml
oc get pod
IMPORTER_POD=$(oc get pod -l app=containerized-data-importer -o=custom-columns=NAME:.metadata.name --no-headers=true)
oc logs -f $IMPORTER_POD
```

This is a sample output of the importer pod logs:

```
# oc logs -f $IMPORTER_POD
I0118 10:40:32.938365       1 importer.go:45] Starting importer
I0118 10:40:32.939305       1 importer.go:58] begin import process
I0118 10:40:32.939375       1 importer.go:82] begin import process
I0118 10:40:32.939417       1 dataStream.go:293] copying "http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img" to "/data/disk.img"...
I0118 10:40:33.102412       1 prlimit.go:107] ExecWithLimits qemu-img, [info --output=json http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img]
I0118 10:40:34.975749       1 prlimit.go:107] ExecWithLimits qemu-img, [convert -p -f qcow2 -O raw json: {"file.driver": "http", "file.url": "http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img", "file.timeout": 3600} /data/disk.img]
I0118 10:40:34.983868       1 qemu.go:189] 0.00
I0118 10:40:35.525892       1 qemu.go:189] 1.19
I0118 10:40:35.572275       1 qemu.go:189] 2.38
....
....
I0118 10:40:37.597856       1 qemu.go:189] 98.02
I0118 10:40:37.598886       1 qemu.go:189] 99.21
I0118 10:40:37.689849       1 prlimit.go:107] ExecWithLimits qemu-img, [info --output=json /data/disk.img]
I0118 10:40:37.710083       1 dataStream.go:349] Expanding image size to: 10Gi
I0118 10:40:37.712784       1 prlimit.go:107] ExecWithLimits qemu-img, [resize -f raw /data/disk.img 10G]
I0118 10:40:37.729748       1 importer.go:89] import complete

```

As the image downloaded is small, the importer pod might actually have disappeared by the time you check its logs

Notice that the importer downloaded the publically available Cirros Cloud qcow image. Once the importer pod completes, this PVC is ready for use in kubevirt.

Let's create a Virtual Machine making use of it. Review the file *vm_pvc.yml*.

```
cat ~/vm_pvc.yml
```

Launch this vm

```
oc create -f ~/vm_pvc.yml
```

This will create and start a Virtual Machine named vm2. We can use the following command to check our Virtual Machine is running and to gather its IP.

```
# oc get  vmi
NAME      AGE       PHASE     IP            NODENAME
vm2       1m        Running   10.124.0.64   student003

```


Finally, use the gathered ip to connect to the Virtual Machine, create some files, stop and restart the Virtual Machine with virtctl and check how data persists. Use password *gocubsgo* if needed

```
ssh cirros@VM_IP
```

This concludes this section of the lab.

[Next Lab](../lab8/lab8.md)\
[Previous Lab](../lab6/lab6.md)\
[Home](../../README.md)
