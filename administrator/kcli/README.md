
This repository provides instructions on how to deploy an arbitrary number of vms on gcp with kubevirt, optionally with nested

## Requirements

- a gcp account and the corresponding service account json file
- an image with nested enabled (optional)
- vpc firewall rules allowing tcp:22, tcp:80, tcp:8443 (for openshift)
- a google cloud DNS domain registered
- [*kcli*](https://github.com/karmab/kcli) tool ( configured to point to gcp) with version >= 12.0

### Service account retrieval

To gather your service account file:

- Select the "IAM" → "Service accounts" section within the Google Cloud Platform console.
- Select "Create Service account".
- Select "Project" → "Editor" as service account Role.
- Select "Furnish a new private key".
- Select "Save"

### Preparing a nested enabled image (Optional)

```
# export GOOGLE_APPLICATION_CREDENTIALS=...
# gcloud config set project cnvlab-XXXX
gcloud compute images create nested-centos7 --source-image-family centos-7 --source-image-project centos-cloud --licenses "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"
```

### Create a dns domain

- Select the "Networking" → "Network Services" → "Cloud DNS"
- Select "Create Zone"
- Put the same name as your domain, but with '-' instead

### kcli setup

#### Installation 

```
docker pull karmab/kcli
echo alias kcli=\'docker run -it --rm --security-opt label:disable -v ~/.kcli:/root/.kcli -v ~/.ssh:/root/.ssh -v $PWD:/plans karmab/kcli\' >> $HOME.bashrc
```

#### Configuration

- copy your service account json file location to .kcli directory
- create a directory *.kcli* in your home directory and a file *config.yml* with the following content, specifying your serviceaccount json file location

```
default:
 client: cnvlab

cnvlab:
 type: gcp
 user: cnv
 credentials: ~/.kcli/myproject.json
 enabled: true
 project: cnvlab-209908
 zone: us-central1-b

```

The user indicated in the conf is the one that will be used for ssh access

## How to use

the plan file  *kcli_plan.yml* is the main artifact used to run the deployment.
Run the following command from this same directory

```
kcli plan -f /plans/kcli_plan.yml -P nodes=10 cnvlab
```

this will create 10 vms, named student001,student002,...,student010 and populate them with scripts to deploy the corresponding features
a requisites.sh script will also be executed to install docker and pull relevant images

- openshift.sh/kubernetes.sh
- kubevirt.sh
- cdi.sh
- clean.sh

To launch the plan for kubernetes instead, run this (we can actually use latest kubevirt on this platform)

```
kcli plan -P nodes=10 -P openshift=false -P kubevirt_version=v0.7.0 -f /plans/kcli_plan.yml cnvlab
```

You can then use *
- kcli list*
- *kcli ssh $INSTANCE*
- kcli plan -d cnvlab # for deletion
- relaunch the same command with a different value for nodes so that extra instances get created

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
|kubevirt_version   | v0.7.0-alpha.2           |
|cdi_version        | v0.5.0                   |
