## Use KubeVirt

### Create a Virtual Machine

Download the VM manifest and explore it. Note it uses a [registry disk](https://kubevirt.io/user-guide/#/workloads/virtual-machines/disks-and-volumes?id=registrydisk) and as such doesn't persist data. Such registry disks currently exist for alpine, cirros and fedora.

```
wget https://raw.githubusercontent.com/kubevirt/demo/master/manifests/vm.yaml
less vm.yaml
```

Apply the manifest to OpenShift.

```
oc apply -f https://raw.githubusercontent.com/kubevirt/demo/master/manifests/vm.yaml
 virtualmachine.kubevirt.io "testvm" created
 virtualmachineinstancepreset.kubevirt.io "small" created
```

To start a Virtual Machine you can use:

```
./virtctl start testvm
```

### Manage Virtual Machines (optional):

To get a list of existing Virtual Machines. Note the `running` status.

```
oc get vms
oc get vms -o yaml testvm
```


To get a list of existing Virtual Machines. Note the `running` status.

```
oc get vms
oc get vms -o yaml testvm
```

### Accessing VMs (serial console & spice)

Connect to the serial console of the Cirros VM. Then disconnect from the virtual machine console `ctrl+]`.

```
./virtctl console testvm
```
Hit return/enter a few times and login with the displayed username and password.

### Communication Between Application and Virtual Machine

While in the console of the `testvm` let's run `curl` to confirm our virtual machine
can access the `Service` of the application deployment.
```
curl ara.myproject.svc.cluster.local:8080
```
The expected output from the curl command should be:
```
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<title>Redirecting...</title>
<h1>Redirecting...</h1>
<p>You should be redirected automatically to target URL: <a href="/about/">/about/</a>.  If not click the link.
```

Connect to the graphical display.

Note: Requires `remote-viewer` from the `virt-viewer` package. This is out of scope for this lab. 

```
./virtctl vnc testvm
```

### Controlling the State of the VM

To shut it down:

```
./virtctl stop testvm
```

To delete a Virtual Machine:

```
oc delete vms testvm
```

## Experiment with CDI

[CDI](https://github.com/kubevirt/containerized-data-importer) is an utility designed to import Virtual Machine images for use with Kubevirt. 

At a high level, a persistent volume claim (Pvc) is created. A custom controller watches for importer specific claims, and when discovered, starts an import process to create a raw image named *disk.img* with the desired content into the associated Pvc

#### Install CDI

to install the components, we will execute `cdi.sh` script in root home directory. Be sure to review the contents of this file first

```
~/cdi.sh
```

Review the objects that were added.

```
oc get project| grep golden
oc get pods --namespace=golden-images
```

[Previous Lab](../lab5/lab5.md)\
[Next Lab](../lab7/lab7.md)\
[Home](../../README.md)