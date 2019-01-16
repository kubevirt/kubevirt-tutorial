## Student Connection Process

In this section, we review how to connect how to your instance

### Find your GCP Instance

This lab is designed to accommodate many students. As a result, each student will be given a VM running on GCP with nested virtualization, 4 vcpus and 12Gb of RAM.

No GCP knowledge is required.

The naming convention for the lab VMs is: **student\<number\>**.cnvlab.gce.sysdeseng.com

You will be assigned a number by the instructor.

Retrieve the keys from the [instructor host](http://people.redhat.com/kboumedh/cnv_rsa) so that you can _SSH_ into the instances by using the dedicated key. Download the `cnv_rsa`  file to your local machine and change the permissions of the file to 600.

```
wget http://people.redhat.com/kboumedh/cnv_rsa
chmod 600 cnv_rsa
```

### Connecting to your Instance
This lab should be performed on **YOUR ASSIGNED INSTANCE** as `centos` user unless otherwise instructed.

**_NOTE_**: Please be respectful and only connect to your assigned instance. Every instance for this lab uses the same public key so you could accidentally connect to the wrong system. If you have any issues, please inform an instructor.

```
ssh -i cnv_rsa centos@student<number>.cnvlab.gce.sysdeseng.com
```

The output should be something similar to:

```
The authenticity of host 'student002.cnvlab.gce.sysdeseng.com (35.188.64.157)' can't be established.
ECDSA key fingerprint is SHA256:36+hPGyR9ZxYRRfMngif8PXLR1yoVFCGZ1kylpNE8Sk.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'student002.cnvlab.gce.sysdeseng.com,35.188.64.157' (ECDSA) to the list of known hosts.
```

This means the host you are about to connect is not in the known_hosts list. Just accept the fingerprint in order to connect to the instance.

This concludes this section of the lab.

[Next Lab](../lab2/lab2.md)\
[Previous Lab](../lab0/lab0.md)\
[Home](../../README.md)
