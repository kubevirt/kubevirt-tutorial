# Lab 8

## Deploy a multi-homed VM using Multus

In this lab, we will run virtual machines with multiple nics, leveraging Multus and OVS CNI plugins.

Having these two plugins makes possible to define multiple networks in our Kubernetes cluster, once the NADs (NetworkAttachementDefinition) are present, it's only a matter of defining the VM's NICs on each network it needs.

**WARN: We've introduced errors in the laboratory to avoid copy/paste without understanding :), enjoy!!**

### Open vSwitch Configuration

Since we are using the OVS CNI plugin, we need to configure dedicated Open vSwitch bridges.

We already have a provisioned a bridge named `br1`, as a reference, if we were to provision it manually, we'd just need execute the following command:

```console
$ ovs-vsctl add-br br1
```

To see the data already provisioned execute this command:

```console
$ ovs-vsctl show

57b1fe30-b115-45cd-85db-7a205fe60912
    Bridge "br1"
        Port "br1"
            Interface "br1"
                type: internal
    ovs_version: "2.0.0"
```

In a production environment, we would do the same on each of the cluster nodes and attach a dedicated physical interface, to the bridge.

### Create a Network Attachment Definition

A *NetworkAttachmentDefinition*, within its *config* section, configures the CNI plugin. Among other settings there is the bridge itself, which is used by OVS attaching the Pod's virtual interface to it.

```yaml
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: ovs-net-1
  namespace: 'multus'
spec:
  config: '{
      "cniVersion": "0.3.1",
      "type": "ovs",
      "bridge": "br1"
    }'
```

Let's now create a new NAD, which will use the bridge *br1*:


```console
$ cd ~/student-materials
$ kubectl config set-context $(kubectl config current-context) --namespace=default
$ kubectl create -f multus_nad_br1.yml
```

### Create Virtual Machine

So far we've seen *VirtualMachine* resource definitions using just one network, the cluster's default or PodNetwork. Now for using the newly created network, the *VirtualMachine* object needs to reference it and include a new interface that will use it. Similar to what we would do to attach volumes to a regular Pod.

```yaml
...
          interfaces:
          - bridge: {}
            name: default
          - bridge: {}
            macAddress: 20:37:cf:e0:ad:f1
            name: ovs-net-1
...
      networks:
      - name: default
        pod: {}
      - multus:
          networkName: ovs-net-1
        name: ovs-net-1
```

Create two vms named **fedora-multus-1** and **fedora-multus-2**, both with a secondary nic pointing to the previously created bridge/network attachment definition:

```console
$ kubectl create -f vm_multus1.yml
$ kubectl create -f vm_multus2.yml
```

### Verifying the network connectivity

Locate the IPs of the two VMs, open two connections to your GCP instance and connect to both VM serial consoles:

```console
$ virtctl console fedora-multus-1
$ virtctl console fedora-multus-2
```

Confirm the VMs got two network interfaces, *eth0* and *eth1*:

```console
[root@fedora-multus-1 ~]# ip a
...OUTPUT...
2: eth0: ...
3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state UP group default qlen 1000
    link/ether 20:37:cf:e0:ad:f1 brd ff:ff:ff:ff:ff:ff
```

Both VMs should have already an IP address on their *eth1*, cloudinit was used to configure it. The *fedora-multus-1* VM should have the IP address *11.0.0.5* and *fedora-multus-2* VM should have *11.0.0.6*, let's try to use ping or SSH to verify the connectivity:

```console
$ ping 11.0.0.(5|6)
```

Or

```console
$ ssh fedora@11.0.0.(5|6)
```

[Next Lab](../lab9/lab9.md)\
[Previous Lab](../lab7/lab7.md)\
[Home](../../README.md)
