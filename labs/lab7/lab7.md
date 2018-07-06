#### Use CDI

As an example, we will import a Fedora28 Cloud Image as a Pvc and launch a Virtual Machine making use of it

```
oc project myproject
oc create -f pvc_fedora.yml
```

This will create the Pvc with a proper annotation so that CDI controller detects it and launches an importer pod to gather the image specified in the *kubevirt.io/storage.import.endpoint* annotation

```
oc get pvc fedora -o yaml
oc get pod
# replace with your importer pod name
oc logs importer-fedora-pnbqh
```

Once the importer pod completes, this Pvc is ready for use in kubevirt.

Let's create a Virtual Machine making use of it. Review the file *vm1_pvc.yml*

```
cat ~/vm1_pvc.yml
```

We change the yaml definition of this Virtual Machine to inject the default public key of root user in the GCP Virtual Machine.

```
PUBKEY=`cat ~/.ssh/id_rsa.pub`
sed -i "s%ssh-rsa.*%$PUBKEY%" vm1_pvc.yml
oc create -f vm1_pvc.yml
```

This will create and start a Virtual Machine named vm1. We can use the following command to check our Virtual Machine is running and to gather its ip.

```
oc get pod -o wide
```

Since we are running an all in one setup, the corresponding Virtual Machine is actually running on the same node, we can check its qemu process

```
ps -ef | grep qemu | grep vm1
```

Finally, use the gathered ip to connect to the Virtual Machine, create some files, stop and restart the Virtual Machine with virtctl and check how data persists

```
ssh fedora@VM_IP
```

[Previous Lab](../lab6/lab6.md)\
[Next Lab](../lab8/lab8.md)\
[Home](../../README.md)
