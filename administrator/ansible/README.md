# GCE and Ansible 2.8

Prior Ansible 2.8 version we consume the gce.py and gce.ini file in order to execute GCE Dynamic Inventory, this has changed on 2.8 version of ansible. Now works in a different way and this document tries to help you there.

## Pre-reqs

- You at least need the JSON file to access to your GCE instances (as usual)

Pip3 libraries:

- requests >= 2.18.4
- google-auth >= 1.3.0

```
pip3 freeze | egrep "(^requests=|^google-auth)"
```

Must give you something like:

```
google-auth==1.1.1
requests==2.21.0
```

## Hands on

From 2.8 version you need to use an built in plugin called `gce_compute` in order to do that just add in you `ansible.cfg` (usually from `/etc/ansible/ansible.cfg`) file:

```
[inventory]
enable_plugins = gcp_compute
```

Now you need to fill the `gcp_compute.yml` file, it's easy, you just need to ensure that the required fields are there, use this as an example for the labs:

```
plugin: gcp_compute
zones: # populate inventory with instances in these regions
  - europe-west4-a
projects:
  - cnvlab-209908 
service_account_file: /home/PUT YOUR USER HERE/.ansible/inventory/gce.json 
auth_kind: serviceaccount
scopes:
 - 'https://www.googleapis.com/auth/cloud-platform'
 - 'https://www.googleapis.com/auth/compute.readonly'
hostnames:
  # List host by name instead of the default public ip
  - name
compose:
  # Set an inventory parameter to use the Public IP address to connect to the host
  # For Private ip use "networkInterfaces[0].networkIP"
  ansible_host: networkInterfaces[0].accessConfigs[0].natIP

```

**NOTES:**
- Filters does not work properly, if you just select one MachineType and copy/paste the same as you know that exists gives you an empty inv
- Use the _zones_ to filter just in one zone in order to avoid wait several time (you also could add more than 1 zone)


## Execution

Ensure that you're pointing to the correct JSON auth file and has those

```
λ ansible git:(master) ✗ ansible -i gcp_compute.yml all -u jparrill -m command -a "ping 127.0.0.1 -c4"
kubevirt-prow-0 | CHANGED | rc=0 >>
PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.084 ms
64 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=0.113 ms
64 bytes from 127.0.0.1: icmp_seq=3 ttl=64 time=0.069 ms
64 bytes from 127.0.0.1: icmp_seq=4 ttl=64 time=0.069 ms

--- 127.0.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 2999ms
rtt min/avg/max/mdev = 0.069/0.083/0.113/0.021 ms

λ ansible git:(master) ✗ ansible -i gcp_compute.yml all -u kubevirt -m command -a "kubectl get pods"  
kubevirt-prow-0 | CHANGED | rc=0 >>
NAME                                READY   STATUS    RESTARTS   AGE
deck-f958755bc-skq64                1/1     Running   1          5d
deck-f958755bc-v5568                1/1     Running   1          5d
hook-57d5467cbc-6ndvg               1/1     Running   1          13d
hook-57d5467cbc-k22fm               1/1     Running   1          13d
horologium-79965ffb5-c29nt          1/1     Running   1          13d
plank-79646b78fb-mn796              1/1     Running   1          13d
sinker-796f7df8cb-tdj5b             1/1     Running   1          13d
statusreconciler-56b668448f-bm7f9   1/1     Running   1          13d
tide-6d66ddcb4c-gms2t               1/1     Running   1          13d
```

## References

- [Ansible GCE Guide](https://docs.ansible.com/ansible/latest/plugins/inventory/gcp_compute.html)

Enjoy ;)
