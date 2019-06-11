# Lab 4

## Deploy our first Virtual Machine

To start with, we'll be deploying a VM that uses a [ContainerDisk](https://kubevirt.io/user-guide/docs/latest/creating-virtual-machines/disks-and-volumes.html#containerdisk). It won't use any of the available PVs, ContainerDisk based VMs are ephemeral.

```console
$ cd ~/student-materials
$ kubectl config set-context $(kubectl config current-context) --namespace=default
$ kubectl create -f vm_containerdisk.yml
virtualmachine.kubevirt.io/vm1 created
```

Check for the VM we just created:

```console
$ kubectl get vm vm1
NAME   AGE   RUNNING   VOLUME
vm1    24s   false
```

Notice it's not running, in the YAML definition we can find the following block:

```yaml
...
spec:
  running: false
...
```

The *VirtualMachine* object is the definition of our VM, but it's not instantiated, let's do so with *virtctl* as follows:

```console
$ virtctl start vm1
VM vm1 was scheduled to start
```

A *virt-launcher* Pod should be starting now, which will spawn the actual virtual machine instance (or VMI):

```console
$ kubectl get pods -w
NAME                      READY   STATUS    RESTARTS   AGE
virt-launcher-vm1-2qflc   0/2     Running   0          12s
virt-launcher-vm1-2qflc   0/2     Running   0          12s
virt-launcher-vm1-2qflc   1/2     Running   0          17s
virt-launcher-vm1-2qflc   2/2     Running   0          23s
```

We can also use *kubectl* to check the virtual machine and its instance:

```console
$ kubectl get vm vm1
NAME   AGE   RUNNING   VOLUME
vm1    19m   true

$ kubectl get vmi vm1
NAME   AGE     PHASE     IP            NODENAME
vm1    3m49s   Running   10.244.0.22   sjr-kubemaster.deshome.net
```

Using *virtctl* we can connect to the VMI's console as follows:

```console
$ virtctl console vm1
Successfully connected to vm1 console. The escape sequence is ^]

Fedora 29 (Cloud Edition)
Kernel 4.18.16-300.fc29.x86_64 on an x86_64 (ttyS0)

vm1 login: fedora
Password: fedora

[fedora@vm1 ~]$ ping -c 1 google.com
PING google.com (172.217.16.238) 56(84) bytes of data.
64 bytes from mad08s04-in-f14.1e100.net (172.217.16.238): icmp_seq=1 ttl=54 time=22.1 ms

--- google.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 22.098/22.098/22.098/0.000 ms
[fedora@vm1 ~]$ exit

Fedora 29 (Cloud Edition)
Kernel 4.18.16-300.fc29.x86_64 on an x86_64 (ttyS0)

vm1 login:
```
There is also a graphical console for connecting to the VMs, using the *vnc* subcommand instead of *console*. Note that it requires you to have *remote-viewer* installed and it's out of the scope of this lab.


**NOTE**: To exit the console press *Ctrl+]*

## Recap

* We've defined a *VirtualMachine* object on the cluster which didn't actually instantiate the *vm1*
* We've started the *vm1* using *virtctl*, which instantiated it creating the *VirtualMachineInstance* object
  * *kubectl patch* could have also been used to start *vm1*
* Finally, we've connected to the *vm1's* serial console using *virtctl*


This concludes this section of the lab, before heading off to the next lab, spend some time describing and exploring the objects this lab created on the cluster.

[Next Lab](../lab5/lab5.md)\
[Previous Lab](../lab3/lab3.md)\
[Home](../../README.md)
