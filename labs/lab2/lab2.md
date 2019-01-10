## Set up your Environment

For the sake of time, some of the required setup has already been taken care of on your GCP VM. For future reference though, the easiest way to get started is to head over to the OpenShift Origin repo on github and follow the "[Getting Started](https://github.com/openshift/origin/blob/master/docs/cluster_up_down.md)" instructions. The instructions cover getting started on Windows, MacOS, and Linux.

### Requirements 

First, let's escalate privileges. The remaining commands will be run as _root_ on the GCP instance.

```
sudo -i
```

Create an SSH key that you will be using later.

```
ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa
```

The following was done as part of the deployment

- Install OpenShift prerequisites 
- Pull relevant images
- Install OpenShift using openshift-ansible
- Install Multus, Docker (start and enable)

As OpenShift is available, let's ask for a cluster status & take a look at our running containers:

`oc version`
```
oc v3.11.0+62803d0-1
kubernetes v1.11.0+d4cacc0
features: Basic-Auth GSSAPI Kerberos SPNEGO

Server https://student001.cnvlab.gce.sysdeseng.com:8443
openshift v3.11.0+1a90c5c-83
kubernetes v1.11.0+d4cacc0
```

This concludes this section of the lab.

[Next Lab](../lab3/lab3.md)\
[Previous Lab](../lab1/lab1.md)\
[Home](../../README.md)
