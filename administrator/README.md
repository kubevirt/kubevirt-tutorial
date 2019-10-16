# KubeVirt Workshop

This directory provides bases to deploy the lab.

## Requirements

* Terraform (libvirt provider)
* Ansible
* A virtual machine (with nested virtualization)

## Installation on Libvirt

```shell
git clone https://github.com/kubevirt/kubevirt-tutorial
cd kubevirt-tutorial
cd administrator/terraform/libvirt
terraform init
terraform plan -var-file varfiles/<yourvarsfile>.tf
cd ../ansible
ANSIBLE_ROLES_PATH=roles ansible-playbook -i inventories/<inventory> -u cloud --private-key <ssh-private-key> playbooks/kubernetes.yml
```

## Installation on GCE

```
gcloud auth login
gcloud auth application-default login
```

Create your varfile: `varfiles/containerdays-2019.tfvars`

```shell
git clone https://github.com/kubevirt/kubevirt-tutorial
cd kubevirt-tutorial
cd administrator/terraform/gcp
terraform init -get -upgrade=true
terraform plan -var-file varfiles/containerdays-2019.tfvars -refresh=true
terraform apply -var-file varfiles/containerdays-2019.tfvars
### If you want to debug it, just add this env var:
TF_LOG=DEBUG terraform apply -var-file varfiles/containerdays-2019.tfvars -refresh=true
###
```


- Create a service account and download its JSON file

- See the [README for ansible](./ansible/README.md) for details on Ansible configuration


```shell
wget <SSH KEY URL> -O ~/.ssh/kubevirt-tutorial
ssh-add ~/.ssh/kubevirt-tutorial

cd ../ansible

export GCE_CREDENTIALS_FILE_PATH=/path/to/your/gcp/service/account/keyfile.json

ANSIBLE_ROLES_PATH=roles \
                  ansible-playbook \
                  -i gcp_compute.yml \
                  --private-key ~/.ssh/kubevirt-tutorial \
                  -l lab \
                  playbooks/kubernetes.yml
```

## Versions used

| Component   | Version  |
| ----------- | -------- |
| Kubernetes  | stable-1 |
| kubevirt    | v0.22.0  |
| cdi         | 1.9.0    |

## Terraform variable file example

Variable files are used to override (and/or define) variables listed in [terraform variables definition file](terraform/variables.tf).

```hcl
libvirt_url="qemu+ssh://sjr@libvirt.domain.tld/system"
host_bridge_iface="br0"
dns_domain_name="domain.tld"
ssh_pub_key="ssh-rsa AAAABNzaC1yc2EAAAADAQABAAABAQC7ANGakwxmSNsDkvJ3ot0cBVeEIgRNAuCessDFd+6Uk2/zt+aewZn3DGPiWKy8VmprBncXhKIIO0mc1Sh4vnxL8jyho+YowVnD6SyByqkXOvmonY4gfUKEIb5aYMbXIc/wKfKLhWzrqki8HWGOESVxqx6WMN+mkBkarWeEjA7+ZpvpJXtgSZoh378WxnRb8v2Pm6qFgEFJK3kaKwdK/dNCsnnhuLxS0HHT/aTfVFA2rzPBYxbfJr2youztQLrVERxpBqYvov0ydoemdeMRQycNR7EY+fqkD1ABkpFKufZCTYcNuGiuhaOjkmU0uHtztwnV64I5mdeqrITRhHCF7y7"
hostname_prefix="kubevirtlab"
```
