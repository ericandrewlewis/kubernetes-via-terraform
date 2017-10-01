# This setup is rather old and may not work.

This will boot up a Kubernetes cluster in AWS.

## Things of note when deploying

### Creating and uploading TLS assets

TLS assets will be manually created and uploaded to the utility server. [Read more about creating Kubernetes cluster TLS assets](https://coreos.com/kubernetes/docs/latest/openssl.html).

Create TLS assets for the cluster CA.

rm -rf /etc/kubernetes/ssl/
```bash
./tls-configuration/create-tls-assets-for-root-ca.sh
```

Create TLS assets for the API servers.

```bash
./tls-configuration/create-tls-assets-for-apiserver.sh [ K8S_API_SERVER_HOSTNAME ]
```

Create TLS assets for the worker nodes.

```bash
./tls-configuration/create-tls-assets-for-worker.sh [ WORKER_ID ] [ WORKER_IP ]
```

Create TLS assets for admin (i.e. kubectl usage)

```bash
./tls-configuration/create-tls-assets-for-admin.sh
```
Upload all the assets to the utility server. Assuming you have a private key to access the utility server at `~/.ssh/kubernetes.pem`.

```bash
scp -r -i ~/.ssh/kubernetes.pem /etc/kubernetes/ssl/ core@[ UTILITY PUBLIC IP ]:/home/core/kubernetes-ssl/
```

SSH into the Utility server. Copy the files to each master and worker node. Assuming you have ssh connectivity to the servers.

```bash
scp -r -i ~/.ssh/kubernetes.pem /home/core/kubernetes-ssl core@[PRIVATE_IP]:/home/core/kubernetes-ssl
```

Log into each server and move the right assets to the right folder.

For master nodes

```bash
sudo rm -rf /etc/kubernetes/ssl/;
sudo mkdir -p /etc/kubernetes/ssl/;
sudo cp /home/core/kubernetes-ssl/apiserver/apiserver-key.pem /etc/kubernetes/ssl/apiserver-key.pem;
sudo cp /home/core/kubernetes-ssl/apiserver/apiserver.pem /etc/kubernetes/ssl/apiserver.pem;
sudo cp /home/core/kubernetes-ssl/ca/ca.pem /etc/kubernetes/ssl/ca.pem;
sudo chown root:root /etc/kubernetes/ssl/ca.pem;
sudo chmod 600 /etc/kubernetes/ssl/ca.pem;
sudo chmod 644 /etc/kubernetes/ssl/apiserver-key.pem;
sudo chmod 644 /etc/kubernetes/ssl/apiserver.pem;
rm -rf /home/core/kubernetes-ssl;
```

For worker nodes

```bash
sudo rm -rf /etc/kubernetes/ssl/;
sudo mkdir -p /etc/kubernetes/ssl/;
sudo cp /home/core/kubernetes-ssl/worker${WORKER_ID}/worker.pem /etc/kubernetes/ssl/worker.pem;
sudo cp /home/core/kubernetes-ssl/worker${WORKER_ID}/worker-key.pem /etc/kubernetes/ssl/worker-key.pem;
sudo cp /home/core/kubernetes-ssl/ca/ca.pem /etc/kubernetes/ssl/ca.pem;
sudo chown root:root /etc/kubernetes/ssl/ca.pem;
sudo chmod 600 /etc/kubernetes/ssl/ca.pem;
sudo chmod 644 /etc/kubernetes/ssl/worker-key.pem;
sudo chmod 644 /etc/kubernetes/ssl/worker.pem;
rm -rf /home/core/kubernetes-ssl;
```

Configure kubectl

```
kubectl config set-cluster default-cluster --server=https://${MASTER_HOST} --certificate-authority=/etc/kubernetes/ssl/ca/ca.pem;
kubectl config set-credentials default-admin --certificate-authority=/etc/kubernetes/ssl/ca/ca.pem; --client-key=/etc/kubernetes/ssl/admin/admin-key.pem --client-certificate=/etc/kubernetes/ssl/admin/admin.pem
kubectl config set-context default-system --cluster=default-cluster --user=default-admin;
kubectl config use-context default-system;
```

* Whenever recreating the etcd cluster (e.g. if changing security groups), change the discovery URL in cloud config.
* Set the [flannel network config in etcd](https://coreos.com/kubernetes/docs/latest/deploy-master.html#configure-flannel-network).
* When bringing up for the first time (e.g. when etcd and kube are available) [create the `kube-system` namespace](https://coreos.com/kubernetes/docs/latest/deploy-master.html#create-kube-system-namespace).
* Sometimes `kubelet-install` or `kubelet` service fails on either the master or the worker.
