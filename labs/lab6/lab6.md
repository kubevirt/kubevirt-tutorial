## Use KubeVirt

### Create a Virtual Machine

Explore The VM Manifest. Note it uses a [container disk](https://kubevirt.io/user-guide/docs/latest/creating-virtual-machines/disks-and-volumes.html#containerdisk) and as such doesn't persist data. Such container disks currently exist for alpine, cirros and fedora.

```
cat ~/vm_containerdisk.yml
```

Launch this vm:

```
oc project myproject
oc create -f ~/vm_containerdisk.yml
```

Output should be similar to the following

```
  virtualmachine.kubevirt.io "vm1" created
```

### Manage Virtual Machines

Get list of existing Virtual Machines:

Note in the `running` column that our vm has this field set to False and as such isn't running yet.

```
oc get vm
oc get vm vm1 -o yaml
```

Sample output for `oc get vm`

```
# oc get vm
NAME      AGE       RUNNING   VOLUME
vm1       9s        false   
```

Start the Virtual Machine:

```
virtctl start vm1
```

Wait for about a  minute for the vm to fully launch.

Now that the Virtual Machine has been started, check the status. Note how the value in the `running` column has been changed to *True*

```
oc get vm
oc get vm -o yaml vm1
```

Sample output for `oc get vm`

```
# oc get vm
NAME      AGE       RUNNING   VOLUME
vm1       2m        true    
```

Confirm the vm is ready by checking its underlying pod:

In both commands, the indicated ip can be used to connect to the vm

```
oc get pod -o wide
oc get vmi
```

Sample output:

```
# oc get pod -o wide
NAME                      READY     STATUS      RESTARTS   AGE       IP            NODE         NOMINATED NODE
ara-1-build               0/1       Completed   0          16m       10.124.0.27   student001   <none>
ara-1-xpxf2               1/1       Running     0          14m       10.124.0.29   student001   <none>
virt-launcher-vm1-2b2v7   2/2       Running     0          2m        10.124.0.35   student001   <none>
# oc get vmi
NAME      AGE       PHASE     IP            NODENAME
vm1       2m        Running   10.124.0.35   student003

```

### Accessing VMs (serial console & spice)

Connect to the serial console of the VM. Hit return / enter a few times and login with fedora/fedora:

```
virtctl console vm1
```

Log in with the following credentials: 

```
Fedora 29 (Cloud Edition)
Kernel 4.18.16-300.fc29.x86_64 on an x86_64 (ttyS0)

vm1 login: fedora
Password: fedora

```

You can disconnect from the virtual machine console by typing: `ctrl+]` or `ctrl+5` but don't do it yet

### Communication Between Application and Virtual Machine

While in the console of the `vm1` let's run `curl` to confirm our virtual machine
can access the `Service` of the application we deployed earlier

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

Now disconnect from the console

### Connect to the graphical display.

Note: Requires `remote-viewer` from the `virt-viewer` package. This is out of scope for this lab. 

```
virtctl vnc vm1
```

### Connect using service 

We can "expose" any port of the vm so that we can access it from the outside.

Expose the ssh port of your VM:

```
oc create -f ~/vm1_svc.yml
```

Access the VM using the exposed port:

```
ssh -p 30000 fedora@student<number>.cnvlab.gce.sysdeseng.com
```

### Controlling the State of the VM

Shut down the VM:

```
virtctl stop vm1
```

Delete the VM:

```
oc delete vms vm1
```

This concludes this section of the lab.

[Next Lab](../lab7/lab7.md)\
[Previous Lab](../lab5/lab5.md)\
[Home](../../README.md)
