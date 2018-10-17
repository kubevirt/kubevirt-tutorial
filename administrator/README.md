This page provides instructions on how to manually deploy the demo on 
For an automated way using kcli, use [this](kcli/README.md) instead

## Requirements

- a virtual machine (ideally with nested virtualization)

#### Installation 

Run the following in your vm to move all artifacts under /root

```
git clone https://github.com/scollier/kubevirt-tutorial
mv kubevirt-tutorial/administrator/* /root
```

## Versions used

| Component        | Version                  |
|------------------|--------------------------|
|openshift         | 3.11                     |
|kubevirt_version  | v0.9.1                   |
|cdi_version       | 1.2.0                    |
