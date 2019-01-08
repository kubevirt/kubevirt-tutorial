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

- install *docker*, enable and start it as a service
- install *oc* and *kubectl* client
- pull relevant images
- install openshift using *oc cluster up*

As OpenShift is available, let's ask for a cluster status & take a look at our running containers:

```
oc version
  oc v3.10.0-rc.0+c20e215
  kubernetes v1.10.0+b81c8f8
  features: Basic-Auth GSSAPI Kerberos SPNEGO
 
  Server https://127.0.0.1:8443
  openshift v3.10.0-rc.0+ad6a1da-30
  kubernetes v1.10.0+b81c8f8
```

The important item from the `oc cluster status` command output is the `Web console URL`.

```
oc cluster status
  Web console URL: https://student002.cnvlab.gce.sysdeseng.com:8443/console/
  
  Config is at host directory 
  Volumes are at host directory 
  Persistent volumes are at host directory /root/openshift.local.clusterup/openshift.local.pv
  Data will be discarded when cluster is destroyed
```

This concludes this section of the lab.

[Next Lab](../lab3/lab3.md)\
[Previous Lab](../lab1/lab1.md)\
[Home](../../README.md)
