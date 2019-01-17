## Deploy a Container-based Application to OpenShift

The purpose of this section is to deploy an example application on top of OpenShift so we later on demonstrate how containers and virtual machines can be orchestrated side by side within a single OpenShift cluster.

We will deploy the application [ARA Records Ansible](https://github.com/openstack/ara) or ARA for short, using the build feature of OpenShift which allows to create containers from a github repo source.

According to the project's README, `ARA Records Ansible playbook runs and makes the recorded data available and intuitive for users and systems`. It is a simple web-based python application that is easily deployed to OpenShift.

### Create new Project and Add Template

```
oc new-project myproject
oc create -f /root/app-template.yaml
```

### Deploy Application

```
oc new-app --template ara
```
Be patient, it takes some time to build and deploy (~2m-3m). Watch the build and ara pods:

```
# oc get pod -w
NAME          READY     STATUS    RESTARTS   AGE
ara-1-build   1/1       Running   0          7s
ara-1-deploy   0/1       Pending   0         0s
ara-1-deploy   0/1       Pending   0         0s
ara-1-deploy   0/1       ContainerCreating   0         0s
ara-1-build   0/1       Completed   0         1m
ara-1-build   0/1       Completed   0         1m
ara-1-deploy   0/1       ContainerCreating   0         2s
ara-1-xpxf2   0/1       Pending   0         0s
ara-1-xpxf2   0/1       Pending   0         0s
ara-1-xpxf2   0/1       ContainerCreating   0         1s
ara-1-deploy   1/1       Running   0         3s
ara-1-xpxf2   0/1       ContainerCreating   0         3s
ara-1-xpxf2   1/1       Running   0         12s
ara-1-deploy   0/1       Completed   0         15s
ara-1-deploy   0/1       Terminating   0         15s
ara-1-deploy   0/1       Terminating   0         15s
```

You can see the deployment status with `oc status` command. You should see something like this when it finish:

```
# oc status
In project myproject on server https://student001.cnvlab.gce.sysdeseng.com:8443

http://ara-myproject.app.student001.cnvlab.gce.sysdeseng.com to pod port 8080-tcp (svc/ara)
  dc/ara deploys istag/ara:latest <- bc/ara docker builds https://github.com/jcpowermac/openshift-presentation#master 
    deployment #1 deployed 15 seconds ago - 1 pod


2 infos identified, use 'oc status --suggest' to see details.

```

The following objects will be created:

- [BuildConfig](https://docs.openshift.org/latest/dev_guide/builds/build_strategies.html#docker-strategy-options) 
- [ImageStream](https://docs.openshift.org/latest/dev_guide/managing_images.html) 
- [DeploymentConfig](https://docs.openshift.org/latest/dev_guide/deployments/how_deployments_work.html)
- [Route](https://docs.openshift.org/latest/dev_guide/routes.html)
- [Service](https://docs.openshift.org/latest/architecture/core_concepts/pods_and_services.html#services)

### Review Objects

Let's show our `BuildConfig` and watch the container build log. The ara `BuildConfig` creates a new container image from the Dockerfile provided in our GitHub repository. While this is running, feel free to explore the links above to learn more about these OpenShift objects.

```
oc get bc
oc logs -f bc/ara
```

Once that is complete we can confirm that our `DeploymentConfig` has rolled out. The `ara` `DeploymentConfig` 
describes the desired state of the application. 

```
oc get dc
oc rollout status dc/ara
```

Now let's take a look at the `Service` and `Route`. A `Route` exposes a `Service` to allow ingress traffic access via a hostname.
In the case of ARA this allows us to view the web interface of the application.
A `Service` provides a consistent load balanced endpoint that permits pods to access each other. 


```
oc get svc
oc describe svc ara
oc get route
oc describe route ara
```

You can use the url `http://ara-myproject.app.student<number>.cnvlab.gce.sysdeseng.com` to access ara web interface.

This concludes this section of the lab.

[Next Lab](../lab5/lab5.md)\
[Previous Lab](../lab3/lab3.md)\
[Home](../../README.md)
