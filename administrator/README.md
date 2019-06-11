# KubeVirt Workshop

This directory provides bases to deploy the lab.

## Requirements

* Terraform (libvirt provider)
* Ansible
* A virtual machine (with nested virtualization)

## Installation on Libvirt

```shell
git clone https://github.com/tripledes/kubevirt-tutorial
cd kubevirt-tutorial
git checkout sjr-refactor
cd administrator/terraform
terraform init
terraform plan -var-file varfiles/<yourvarsfile>.tf
cd ../ansible
ANSIBLE_ROLES_PATH=roles ansible-playbook -i inventories/<inventory> -u cloud --private-key <ssh-private-key> playbooks/kubernetes.yml
```

## Installation on GCE

```shell
git clone https://github.com/tripledes/kubevirt-tutorial
cd kubevirt-tutorial
git checkout sjr-refactor
cd administrator/terraform
terraform init -get -upgrade=true
terraform plan -var-file varfiles/opensouthcode19.tfvars -refresh=true
terraform apply -var-file varfiles/opensouthcode19.tfvars
### If you want to debug it, just add this env var:
TF_LOG=DEBUG terraform apply -var-file varfiles/opensouthcode19.tfvars -refresh=true
###
cd ../ansible
wget <SSH KEY URL> -O ~/.ssh/cnv_lab_new
wget <SSH PUB URL> -O ~/.ssh/cnv_lab_new.pub
ssh-add ~/.ssh/cnv_lab_new
### Here you need to put the right password
ANSIBLE_ROLES_PATH=roles GCE_INI_PATH=~/.ansible/inventory/gce.ini ansible-playbook -i ~/.ansible/inventory/gce.py --private-key ~/.ssh/cnv_lab_new -l tag_kubevirtlab playbooks/kubernetes.yml
```

## Versions used

| Component   | Version  |
| ----------- | -------- |
| Kubernetes  | stable-1 |
| kubevirt    | v0.17.0  |
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
