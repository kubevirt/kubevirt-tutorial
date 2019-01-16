## Explore OpenShift

### Basic OpenShift Commands

Common OpenShift commands can be found below. There are quite a few more though, so be sure to refer to the [OpenShift CLI reference documentation](https://docs.openshift.org/latest/cli_reference/basic_cli_operations.html#cli-reference-basic-cli-operations). Descriptions for the following commands can be found in the CLI guide too.

```
oc
oc whoami
oc projects
oc project default
oc config view
oc get all
oc status
oc get pods
oc describe pod <pod id>
oc logs -f router-<rest of pod id>
oc types
```

Try to use tab completion with the `oc` command

```
oc # Try tabbing for auto-completion now
```

### Log into OpenShift

```
oc logout
oc login -u system:admin
oc whoami
```

Make sure you are logged in for the remainder of the lab :sweat_smile:

### Container Runtime 

OpenShift can either be run using docker as container runtime or [crio](https://cri-o.io/).

We used crio so we can list running containers and images with `crictl`

 ```
crictl ps
crictl images
```

Docker is also installed and running, just to provide the build fonctionality needed by OpenShift and to be demonstrated in the next lab

### Storage

A PersistentVolume (PV) is a piece of storage in the cluster that has been provisioned by an administrator

```
oc get pv 
```

By examining the nfs section of one of the existing PVS, we can see how we are using the node to provide such storage.

The *-o yaml* flag allows us to gather full information for the corrresponding object

```
oc get pv pv001 -o yaml
```

This concludes this section of the lab.

[Next Lab](../lab4/lab4.md)\
[Previous Lab](../lab2/lab2.md)\
[Home](../../README.md)
