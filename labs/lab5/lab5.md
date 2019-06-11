# Lab 5

## Deploy a VM using a DataVolume

Explore the VM manifests, notice it uses a [DataVolume](https://kubevirt.io/user-guide/docs/latest/creating-virtual-machines/disks-and-volumes.html#datavolume)

```console
$ view ~/student-materials/vm_datavolume.yml
```

Now let's start this VM and we'll observe the image importing process before the VMI is created:

```console
$ cd ~/student-materials/
$ kubectl create -f vm_datavolume.yaml
virtualmachine.kubevirt.io/vm2 created

$kubectl get pods | grep importer
importer-vm2-dv-sgch7

$ kubectl logs -f importer-vm2-dv-sgch7
I0517 14:43:45.670580       1 importer.go:58] Starting importer
I0517 14:43:45.670866       1 importer.go:100] begin import process
I0517 14:43:47.098597       1 data-processor.go:237] Calculating available size
I0517 14:43:47.102760       1 data-processor.go:245] Checking out file system volume size.
I0517 14:43:47.102885       1 data-processor.go:249] Request image size not empty.
I0517 14:43:47.102915       1 data-processor.go:254] Target size 10692100096.
I0517 14:43:47.271400       1 data-processor.go:167] New phase: Convert
I0517 14:43:47.271430       1 data-processor.go:173] Validating image
I0517 14:43:49.478205       1 qemu.go:205] 0.00
I0517 14:43:51.845307       1 qemu.go:205] 1.19
I0517 14:43:51.846846       1 qemu.go:205] 2.38
...
I0517 14:44:04.279388       1 qemu.go:205] 99.21
I0517 14:44:04.296137       1 data-processor.go:167] New phase: Resize
W0517 14:44:04.316865       1 data-processor.go:224] Available space less than requested size, resizing image to available space 10692100096.
I0517 14:44:04.317260       1 data-processor.go:230] Expanding image size to: 10692100096
I0517 14:44:04.373807       1 data-processor.go:167] New phase: Complete
```

Again, we can connect to the VM's serial console and check if we've got that extra space that CDI made for us:

```console
$ virtctl console vm2
Successfully connected to vm2 console. The escape sequence is ^]

login as 'cirros' user. default password: 'gocubsgo'. use 'sudo' for root.
cirros login: cirros
Password:
$ df -h /
Filesystem                Size      Used Available Use% Mounted on
/dev/vda1                 4.8G     24.1M      4.6G   1% /
```

## Explore the DataVolume

```console
$ kubectl describe dv vm2-dv
Name:         vm2-dv
Namespace:    default
Labels:       kubevirt.io/created-by=09dda4d2-78b2-11e9-b502-e6faa692a1af
Annotations:  kubevirt.io/delete-after-timestamp: 1558104328
API Version:  cdi.kubevirt.io/v1alpha1
Kind:         DataVolume
Metadata:
  Creation Timestamp:  2019-05-17T14:42:57Z
  Generation:          15
  Owner References:
    API Version:           kubevirt.io/v1alpha3
    Block Owner Deletion:  true
    Controller:            true
    Kind:                  VirtualMachine
    Name:                  vm2
    UID:                   09dda4d2-78b2-11e9-b502-e6faa692a1af
  Resource Version:        286134
  Self Link:               /apis/cdi.kubevirt.io/v1alpha1/namespaces/default/datavolumes/vm2-dv
  UID:                     10054733-78b2-11e9-b502-e6faa692a1af
Spec:
  Pvc:
    Access Modes:
      ReadWriteOnce
    Data Source:  <nil>
    Resources:
      Requests:
        Storage:         10229Mi
    Storage Class Name:  local-volumes
  Source:
    Http:
      URL:  https://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
Status:
  Phase:     Succeeded
  Progress:  100.0%
Events:
  Type     Reason            Age                  From                   Message
  ----     ------            ----                 ----                   -------
  Normal   ImportScheduled   19m                  datavolume-controller  Import into vm2-dv scheduled
  Normal   ImportInProgress  18m (x2 over 19m)    datavolume-controller  Import into vm2-dv in progress
  Normal   Synced            8m3s (x24 over 19m)  datavolume-controller  DataVolume synced successfully
```

The associated PVC has the same name, *vm2-dv*, let's describe it as well, it contains some interesting data:

```console
$ kubectl describe pvc vm2-dv
Name:          vm2-dv
Namespace:     default
StorageClass:  local-volumes
Status:        Bound
Volume:        local-pv-6035a584
Labels:        app=containerized-data-importer
               cdi-controller=vm2-dv
Annotations:   cdi.kubevirt.io/storage.contentType: kubevirt
               cdi.kubevirt.io/storage.import.endpoint: https://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
               cdi.kubevirt.io/storage.import.importPodName: importer-vm2-dv-sgch7
               cdi.kubevirt.io/storage.import.source: http
               cdi.kubevirt.io/storage.pod.phase: Succeeded
               pv.kubernetes.io/bind-completed: yes
               pv.kubernetes.io/bound-by-controller: yes
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      10229Mi
Access Modes:  RWO
VolumeMode:    Filesystem
Events:
  Type       Reason                Age                From                         Message
  ----       ------                ----               ----                         -------
  Normal     WaitForFirstConsumer  22m (x3 over 22m)  persistentvolume-controller  waiting for first consumer to be created before binding
Mounted By:  virt-launcher-vm2-92pm2
```

Pay special attention to the *Annotations* section where CDI introduces interesting data like the endpoint where the image was imported from, the phase and pod name.

## Recap

* We've created a second VM, *vm2*, this one included a *DataVolume* template which instructs KubeVirt and CDI to:
  * Create a PVC which uses a PV already created on the cluster
  * The CDI importer pod, takes the source, in this case a URL, and imports the image directly to the PV attached to the PVC
  * Once that process finishes, a *virt-launcher* pod starts using the same PVC, with the imported image, as boot disk
* A detail that might go unnoticed, CDI is able to detect the requested storage size, the available space (accounting for file system overhead) and resize the image accordingly
* We've connected to *vm2's* serial console and verified the root partition was expanded to the disk size, this is usually done through configuration services like *cloud-init*

This concludes this section of the lab, spend some time checking out all the objects and how they relate to each other, then head off to the next lab!

[Next Lab](../lab6/lab6.md)\
[Previous Lab](../lab5/lab5.md)\
[Home](../../README.md)
