## APBs and the Service Catalog

You can provision Virtual Machines using a dedicated APB through the Service Catalog, who leverages kubevirt and cdi

Navigate to `https://student<number>.cnvlab.gce.sysdeseng.com:8443` in your browser.

![catalog-home](images/catalog-home.png)


Click the `Import Virtual Machine` icon in the catalog to pull up the info page, then click `Next`.

![apb-info](images/import-vm-apb-info.png)


Select the plan `Import from URL`

![apb-config](images/import-vm-apb-config.png)

Fill the form with the following data:

- Add to Project `myproject` 
- Disk Image URL `http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img`
- Operating system type `linux`
- Virtual Machine Name `cirrosapb`

![apb-config2](images/import-vm-apb-config2.png)

This concludes this section of the lab.

[Next Lab](../lab9/lab9.md)\
[Previous Lab](../lab7/lab7.md)\
[Home](../../README.md)
