This repository provides instructions on how to deploy an arbitrary number of vms on aws with kubevirt (no nested)
You can find similar information for gcp [here](README.md)

## Requirements

- [*kcli*](https://github.com/karmab/kcli) tool ( configured to point to aws) with version >= 12.8
- an aws account and its access key id and secret
- vpc firewall rules allowing tcp:22, tcp:80, tcp:8443 (for openshift) and tcp:30000
- a route53 DNS domain registered

### Access key id and secret retrieval

[https://aws.amazon.com/blogs/security/wheres-my-secret-access-key](https://aws.amazon.com/blogs/security/wheres-my-secret-access-key)

### Create a dns domain

[https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html)

### kcli setup

#### Installation 

```
docker pull karmab/kcli
echo alias kcli=\'docker run -it --rm --security-opt label:disable -v ~/.kcli:/root/.kcli -v ~/.ssh:/root/.ssh -v $PWD:/workdir karmab/kcli\' >> $HOME.bashrc
```

#### Configuration

- create a directory *.kcli* in your home directory and a file *config.yml* with the following content, specifying your credentials and your aws keypair

```
default:
 client: aws

aws:
 type: aws
 access_key_id: XXXXXX
 access_key_secret: XXXXXX
 enabled: true
 region: eu-west-3
 keypair: karim
```

## How to use

the plan file  *kcli_plan.yml* is the main artifact used to run the deployment.
Run the following command from this same directory

```
kcli plan -P nodes=10 -P domain=cnvlab.aws.sysdeseng.com -P template=ami-262e9f5b cnvlab
```

this will create 10 vms, named student001,student002,...,student010 and populate them with scripts to deploy the corresponding features
a requisites.sh script will also be executed to install docker and pull relevant images

- openshift.sh/kubernetes.sh
- kubevirt.sh
- cdi.sh
- clean.sh

It will also force emulation regardless of the emulation parameter

To launch the plan for kubernetes instead, run this

```
kcli plan -P openshift=false -P nodes=10 -P domain=cnvlab.aws.sysdeseng.com -P template=ami-262e9f5b cnvlab
```

You can relaunch the same command with a different value for nodes so that extra instances get created

Vms will be accessible using the injected keys and using their fqdn

## Available parameters:

| Parameter         | Default Value            |
|------------------ |--------------------------|
|template           | nested-centos7           | 
|domain             | cnvlab.gce.sysdeseng.com |
|openshift          | true                     |
|disk_size          | 60                       |
|numcpus            | 4                        |
|memory             | 12288                    |
|nodes              | 40                       |
|deploy             | true                     |
|emulation          | false                    |
|openshift_version  | 3.10                     |
|kubernetes_version | 1.10.5                   |
|kubevirt_version   | v0.8.0                   |
|cdi_version        | v0.5.0                   |

## Clean up

```
kcli plan --yes -d cnvlab
```
