## Student Connection Process

In this lab, OpenShift is already installed via [openshift-ansible](https://github.com/openshift/openshift-ansible) and running. 

### Find your GCP Instance
This lab is designed to accommodate many students. As a result, each student will be given a VM running on GCP with nested virtualization, 4 vcpus and 12Gb of RAM. The naming convention for the lab VMs is:

**student\<number\>**.cnvlab.gce.sysdeseng.com

You will be assigned a number by the instructor.

Retrieve the keys from the [instructor host](http://people.redhat.com/kboumedh/cnv_rsa) so that you can _SSH_ into the instances by using the dedicated key. Download the `cnv_rsa`  file to your local machine and change the permissions of the file to 600.

```
wget http://people.redhat.com/kboumedh/cnv_rsa
chmod 600 cnv_rsa
```

### Connecting to your GCP Instance
This lab should be performed on **YOUR ASSIGNED GCP INSTANCE** as `centos` user unless otherwise instructed.

**_NOTE_**: Please be respectful and only connect to your assigned instance. Every instance for this lab uses the same public key so you could accidentally connect to the wrong system. If you have any issues, please inform an instructor.

```
ssh -i cnv_rsa centos@student<number>.cnvlab.gce.sysdeseng.com
```

This concludes this section of the lab.

[Next Lab](../lab2/lab2.md)\
[Home](../../README.md)
