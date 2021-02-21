# Pi k3s Cluster

K3s cluster is installed with [k3sup](https://github.com/alexellis/k3sup#create-a-multi-master-ha-setup-with-embedded-etcd) and using the embedded etcd requiring a minimum of 3x nodes.

## Network

| Hostname      | IP |
| ----------- | ----------- |
| vip      | 172.16.16.70       |
| k3s-master-1      | 172.16.16.72       |
| k3s-master-2   | 172.16.16.71        |
| k3s-master-3   | 172.16.16.73        |

```bash
NAME           STATUS   ROLES                       AGE   VERSION
k3s-master-1   Ready    control-plane,etcd,master   18m   v1.20.2+k3s1
k3s-master-2   Ready    control-plane,etcd,master   17m   v1.20.2+k3s1
k3s-master-3   Ready    control-plane,etcd,master   14m   v1.20.2+k3s1
```

## Keepalive

To operate the virtual IP address keepalive is installed on each "master" node to act as a single IP for speaking via kubectl

```bash
# /etc/keepalived/keepalived.conf
#
# apt install keepalive -y
vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass xxxxxxx
    }
    virtual_ipaddress {
        172.16.16.70
    }
}
```
