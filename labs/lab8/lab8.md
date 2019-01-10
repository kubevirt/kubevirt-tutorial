# Networking with Multus

## Objectives

- Configure Open vSwitch
- Create Network Attachment
- Create, run and configure two Virtual Machines using Multus

### Open vSwitch Configuration

Since we are using the ovs cni need to configure Open vSwitch on
each compute node in the cluster that will run a virtual machine. 
Fortunately we only have a single node so it just needs to be executed once.
So let's create a new bridge `br1`.

```
ovs-vsctl add-br br1
```

**NOTE**: For our lab we only have a single node so its easy to run a single command to create the bridge
but what if you have more?  Here is an example how to create the bridge on multiple nodes:

```bash
NODES=`oc get node -l node-role.kubernetes.io/compute=true --template '{{ range .items }} {{.metadata.name}}{{end}}'`
for N in ${NODES}; 
do 
  ssh root@${N} ovs-vsctl add-br br1
  ssh root@${N} ovs-vsctl add-port br1 eth1
done
```


### Create a Network Attachment Definition

The `NetworkAttachmentDefinition` `config`
section is the configuration for the CNI plugin.
Below is a manifest the [ovs-cni](https://github.com/kubevirt/ovs-cni) plugin.

```yaml
---
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: ovs-br1
spec:
  config: '{
      "cniVersion": "0.3.1",
      "type": "ovs",
      "bridge": "br1"
    }'
```

Let's create it and make sure its available for use.

```
oc new-project multus-vm
oc create -f /path/to/net-attachment.yaml 
oc get net-attach-def
```

### Virtual Machine

For a virtual machine to use multiple interfaces 
there are couple modifications to the VirtualMachine manifest that is required.

- interfaces
- networks

**NOTE**: if a MAC address is not specified each time the virtual machine is stopped
or started the interface will receive a new MAC. (Or deletion of the VirtualMachineInstance).

#### Create Virtual Machine

The virtual machine manifests are available in the repository `lab8/`.  
It would be good to review them to see the changes required to support multus as described above.

```
oc create -f /path/to/fedora-multus-1.yaml 
oc create -f /path/to/fedora-multus-2.yaml 
```

#### Run Virtual Machine

```
virtctl start fedora-multus-1
virtctl start fedora-multus-2
```

#### Configure Virtual Machine

There are multiple ways to access the machine. You can either use 
vnc from kubevirt-web-ui, `virtctl` or ssh via the cluster ip address.

I find it easier to ssh so from the master:

```
oc get pod -n multus-vm -o wide

# password is fedora as defined in the cloud-init section of the manifest.
ssh fedora@<ip_listed_above>
```

Confirm that `eth1` is available as it should be:

```
[root@fedora-multus-1 ~]# ip a
...OUTPUT...
3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 20:37:cf:e0:ad:f1 brd ff:ff:ff:ff:ff:ff
```

Create `/etc/sysconfig/network-scripts/ifcfg-eth1` for each
new virtual machine or make a copy of `eth0` and reconfigure for `eth1`:

- `fedora-multus-1`: `172.16.0.1`
- `fedora-multus-2`: `172.16.0.2`

```
sudo cp /etc/sysconfig/network-scripts/ifcfg-eth{0,1}
sudo vi /etc/sysconfig/network-scripts/ifcfg-eth1
```

Make sure to remove MACADDRESS and the file should more or less look like the
one below.
```
BOOTPROTO=none
TYPE=Ethernet
DEVICE=eth1
NAME=eth1
IPADDR=172.16.0.1
NETMASK=255.255.255.0
```

Then bring up the interface: `ifup eth1` and check `ip a`.

#### Confirm connectivity

```
ping 172.16.0.1
ping 172.16.0.2
```

[Next Lab](../lab9/lab9.md)\
[Previous Lab](../lab7/lab7.md)\
[Home](../../README.md)


