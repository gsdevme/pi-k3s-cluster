#!/bin/bash

which /usr/local/bin/k3sup

if [ $? -eq 1 ]; then
    echo "k3sup not installed"
    echo "run 'curl -sLS https://get.k3sup.dev | sh'"
    exit 1
fi

# keepalive VIP
KUBE_VIP="172.16.16.70"

VERSION="v1.20.2+k3s1"

SSH_USER="pi"

PI_MASTER_ONE="172.16.16.72"
PI_MASTERS=("172.16.16.71" "172.16.16.73")

EXTRA_ARGS="--write-kubeconfig-mode 0664 --no-deploy traefik --tls-san $KUBE_VIP"

k3sup install \
  --ip $PI_MASTER_ONE \
  --user $SSH_USER \
  --cluster \
  --k3s-extra-args "$EXTRA_ARGS"  \
  --k3s-version $VERSION

# give the pi a two seconds to get to grips with its new world
sleep 2

for ip in "${PI_MASTERS[@]}"
do
   :
  k3sup join \
    --ip $ip \
    --user $SSH_USER \
    --server-user $SSH_USER \
    --server-ip $PI_MASTER_ONE \
    --server \
    --k3s-extra-args "$EXTRA_ARGS" \
    --k3s-version $VERSION
done
