## Kubevirt UI

You can also interact with kubevirt using the dedicated UI

First Install it

```
oc new-project kweb-ui
oc apply -f kubevirt-web-ui.yaml
oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:kweb-ui:default
```

You can then access it at `kubevirt-web-ui-kweb-ui.student<number>.cnvlab.gce.sysdeseng.com` and use it to 

- stop/start/delete vms
- create ones
- access vm console through your browser

![kubevirt-ui](images/ui.png)

This concludes this section of the lab.

[Next Lab](../lab10/lab10.md)\
[Previous Lab](../lab8/lab8.md)\
[Home](../../README.md)
