# Networking with Multus

In this lab, we will Run Virtual machines with multiple nics by leveraging Multus integration
Multus CNI enables attaching multiple network interfaces to pods in Kubernetes and has integration with Kubevirt

## Open vSwitch Configuration

Since we are using the ovs cni plugin, we need to configure dedicated Open vSwitch bridges
Create a new bridge named br1:

```
ovs-vsctl add-br br1
```

In a production setup, we would do the same on each of the cluster nodes and add a dedicated interface to the bridge

## Create a Network Attachment Definition

a `NetworkAttachmentDefinition` `config` section is a configuration for the CNI plugin where we indicate which bridges to associate to the pod/vm.
Create a new one, pointing to bridge `br1`

```
oc create -f ~/nad_br1.yml
```

## Virtual Machine

For a virtual machine to use multiple interfaces, there are a couple of modifications to the VirtualMachine manifest that are required.

- interfaces
- networks

## Create Virtual Machine

Create two vms named fedora-multus-1 and fedora-multus-2, both with a secondary nic pointing to the previously created bridge/network attachment definition:

```
oc create -f ~/vm_multus1.yml 
oc create -f ~/vm_multus2.yml 
```

In this case, we set running to *True* in the definition  of those vms so they will launch with no further action

## Access Virtual Machines

There are multiple ways to access the machine. You can either use 
vnc from kubevirt-web-ui, `virtctl` or ssh via the cluster ip address.

Locate the ips of the two vms:

```
oc get vmi
```

password is fedora as defined in the cloud-init section of the manifest.

```
ssh fedora@<ip_listed_above>
```

Confirm that `eth1` is available:

```
[root@fedora-multus-1 ~]# ip a
...OUTPUT...
3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 20:37:cf:e0:ad:f1 brd ff:ff:ff:ff:ff:ff
```

## Confirm connectivity

Through cloudinit, we also configured fedora-multus-1 vm to have ip 11.0.0.5 and fedora-multus-1 vm to have ip 11.0.0.6 so try to ping or ssh between them

```
ping 11.0.0.5
ping 11.0.0.6
```

[Next Lab](../lab9/lab9.md)\
[Previous Lab](../lab7/lab7.md)\
[Home](../../README.md)
