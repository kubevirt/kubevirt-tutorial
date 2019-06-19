# NOTES

* Switch to OKD
  * Include a worker node to demo live migrations
* Storage (TBD)
  * Shared NFS server ?
    * Easy to set up and manage
    * Low infra requirements
  * Shared Ceph Cluster (standalone)? 
    * Maintenance
    * External dependency
  * Dedicated Rook cluster by student ?
    * Ansible role
    * No maintenance 
* HCO
  * Once it stabilizes
  * Deploy from UI (requires OKD)
* Ansible
  * One of the VMs could be deployed using Ansible

## Issues

* KubeVirt Pods go on ContainerConfigError
* UI wizard seems to be looking for projects instead of namespaces
* UI operator seems to only work in OCP
