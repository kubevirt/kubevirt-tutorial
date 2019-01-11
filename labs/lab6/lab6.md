## Use KubeVirt

### Create a Virtual Machine

explore The VM Manifest. Note it uses a [container disk](https://kubevirt.io/user-guide/docs/latest/creating-virtual-machines/disks-and-volumes.html#containerdisk) and as such doesn't persist data. Such container disks currently exist for alpine, cirros and fedora.

```
cat vm_containerdisk.yml
```

We change the yaml definition of this Virtual Machine to inject the default public key of root user in the GCP Virtual Machine and apply the manifest to OpenShift.

```
oc project myproject
PUBKEY=`cat ~/.ssh/id_rsa.pub`
sed -i "s%ssh-rsa.*%$PUBKEY%" vm_containerdisk.yml
oc create -f vm_containerdisk.yml
  virtualmachine.kubevirt.io "vm1" created
```

### Manage Virtual Machines

To get a list of existing Virtual Machines. Note the `running` status.

```
oc get vms
oc get vms -o yaml vm1
```

To start a Virtual Machine you can use:

```
virtctl start vm1
```

Now that the Virtual Machine has been started, check the status. Note the `running` status.

```
oc get vms
oc get vms -o yaml vm1
```

### Accessing VMs (serial console & spice)

Connect to the serial console of the Cirros VM. Hit return / enter a few times and login with the displayed username and password. 

```
virtctl console vm1
```

### Communication Between Application and Virtual Machine

While in the console of the `vm1` let's run `curl` to confirm our virtual machine
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

Disconnect from the virtual machine console by typing: `ctrl+]`.

### Connect to the graphical display.

Note: Requires `remote-viewer` from the `virt-viewer` package. This is out of scope for this lab. 

```
virtctl vnc vm1
```

### Connect using service 

We can "expose" any port of the vm so that we can access it from the outside.
For instance, run the following to expose the ssh port of your vm

```
oc create -f /root/vm1_svc.yml
```

You can then access to your vm from the outside

```
ssh -p 30000 fedora@student<number>.cnvlab.gce.sysdeseng.com
```

### Controlling the State of the VM

To shut it down:

```
virtctl stop vm1
```

To delete a Virtual Machine:

```
oc delete vms vm1
```

This concludes this section of the lab.

[Next Lab](../lab7/lab7.md)\
[Previous Lab](../lab5/lab5.md)\
[Home](../../README.md)
