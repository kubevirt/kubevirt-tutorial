# Networking with Multus

## Objectives

- Review Open vSwitch
- Review Network Attachment Definitions
- Create, run and configure two Virtual Machines using Multus

### Open vSwitch Configuration

Since we are using the ovs cni plugin, we need to configure Open vSwitch on
each compute node in the cluster that will run a virtual machine. 
Create a new bridge named br1:

```
ovs-vsctl add-br br1
```

### Create a Network Attachment Definition

a `NetworkAttachmentDefinition` `config` section is a configuration for the CNI plugin where we indicate which bridges to associate to the pod/vm.
Create a new one, pointing to bridge `br1`

```
oc project default
oc create -f /root/nad_br1.yml
```

### Virtual Machine

For a virtual machine to use multiple interfaces, there are a couple of modifications to the VirtualMachine manifest that are required.

- interfaces
- networks

#### Create Virtual Machine

Create two vms with a secondary nic pointing to the previously created bridge/network attachment definition:

```
oc create -f /root/fedora-multus-1.yml 
oc create -f /root/fedora-multus-2.yml 
```

#### Configure Virtual Machine

There are multiple ways to access the machine. You can either use 
vnc from kubevirt-web-ui, `virtctl` or ssh via the cluster ip address.

Locate the ips of the two vms:

```
oc get vmi -n default
```

password is fedora as defined in the cloud-init section of the manifest.

```
ssh fedora@<ip_listed_above>
```

Confirm that `eth1` is available as it should be:

```
[root@fedora-multus-1 ~]# ip a
...OUTPUT...
3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 20:37:cf:e0:ad:f1 brd ff:ff:ff:ff:ff:ff
```

#### Confirm connectivity

Through cloudinit, we also configured fedora-multus-1 vm to have ip 11.0.0.5 and fedora-multus-1 vm to have ip 11.0.0.6 so try to ping or ssh between them

```
ping 11.0.0.5
ping 11.0.0.6
```

[Next Lab](../lab9/lab9.md)\
[Previous Lab](../lab7/lab7.md)\
[Home](../../README.md)
