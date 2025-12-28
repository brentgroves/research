# **[Ceph: Step by step guide to deploy Ceph clusters](https://medium.com/@arslankhanali/ceph-step-by-step-guide-to-deploy-ceph-clusters-c62e4167a298)**

If you are just interested in deployment of Ceph. Jump to “Simple bash to deploy Ceph” section. If you are interested in how I set up everything according to my lab env, please continue :)
Here is the **[link](https://github.com/arslankhanali/Ceph-5-Playground-CNV)** to git repo

## What is Ceph ?

Ceph is an opensource project which is renowned for its distributed architecture, which comprises of several key components working together to provide a unified storage solution. At the heart of Ceph lies the RADOS (Reliable Autonomic Distributed Object Store) distributed storage system, which forms the foundation for its scalability and resilience. RADOS utilizes a cluster of storage nodes, each running Ceph OSD (Object Storage Daemon) software, to store data across the network in a fault-tolerant manner. This distributed approach ensures high availability and data durability by replicating data across multiple nodes and automatically recovering from failures.

We have designed and implemented RADOS, a Reliable, Autonomic Distributed Object Store that seeks to leverage device intelligence to distribute the complexity surrounding
consistent data access, redundant storage, failure detection,
and failure recovery in clusters consisting of many thousands
of storage devices. Built as part of the Ceph distributed file
system [27], RADOS facilitates an evolving, balanced distribution of data and workload across a dynamic and heterogeneous storage cluster while providing applications with
the illusion of a single logical object store with well-defined
safety semantics and strong consistency guarantees.

## Object Storage in Ceph

Object storage, facilitated through RADOS Gateway, is a fundamental component of Ceph’s storage capabilities. Object storage in Ceph adopts a RESTful interface, allowing applications to interact with storage resources via HTTP APIs. Each object is stored as a binary blob, accompanied by metadata for efficient indexing and retrieval. This architecture enables seamless scalability, as objects are distributed across the Ceph cluster and can be accessed concurrently by multiple clients.

## The Role of Object Storage in ML/AI Initiatives

In the realm of machine learning (ML) and artificial intelligence (AI), object storage plays a pivotal role in managing the vast amounts of unstructured data required for training and inference. ML/AI workflows often involve processing massive datasets comprising images, videos, sensor data, and text documents. Object storage in Ceph provides a cost-effective and scalable solution for storing these datasets, allowing organisations to efficiently manage petabytes of data without compromising performance or reliability.

From a technical standpoint, object storage in Ceph offers several advantages for ML/AI initiatives:

Scalability: Ceph’s distributed architecture allows organisations to seamlessly scale their storage infrastructure to accommodate growing datasets. As ML/AI workloads demand increasingly large volumes of data, object storage in Ceph can expand to meet these requirements without disruption.
Efficiency: The RESTful interface of Ceph’s object storage simplifies data access and manipulation, enabling developers to seamlessly integrate storage operations into ML/AI workflows. Additionally, Ceph’s support for metadata enables efficient indexing and querying of large datasets, improving overall performance.

Purpose of this article
We will look at how to deploy 2 Ceph clusters in my lab environment. This is a starting article in the Ceph series. In later articles we will:

Deploy rados gateway for object storage
Perform multi site replication
Use replication and erasure coding pools

## My setup

I have 7 VMs (RHEL 8) running on a hypervisor in my lab
One of the VMs is `Workstation machine` that will act as a jump host
CEPH-CLUSTER-1 will be setup on ceph-mon01, ceph-mon02 and ceph-mon03 VMs. Each have 20Gb of disks
CEPH-CLUSTER-2 will be setup on ceph-node01, ceph-node02 and ceph-node03 VMs. Each have 40Gb of disks
These VMs are not exposed publically so we will access Ceph dashboards and services through SSH tunnel

## Architecture

Look at the high level design below

![i1](https://miro.medium.com/v2/resize:fit:2776/format:webp/1*-bc7GvgpUAf-eyxU89UT8w.png)

Before we start
Remember you will have different environment with different IPs and hostname. So make changes accordingly.

## Pre Req

- You can ssh to workstation machine from your laptop
- root user on workstation can access ceph-mon01 and ceph-node01
- root user on ceph-mon01 can access ceph-mon02 and ceph-mon03
- ceph-mon01 will be used to bootstrap cluster 1
- root user on ceph-node01 can access ceph-node02 and ceph-node03
- ceph-node01 will be used to bootstrap cluster 2

Easiest way is to create a ssh key pair on workstation and transfer both pubic and private keys to all hosts.

Enables repositories on VMs. If you are on RHEL, you will need to subscribe.

## To enables above repos

```bash
sudo dnf config-manager --set-enabled ansible-2-for-rhel-8-x86_64-rpms
sudo dnf config-manager --set-enabled ansible-2.9-for-rhel-8-x86_64-rpms
sudo dnf config-manager --set-enabled rhceph-5-tools-for-rhel-8-x86_64-rpms
sudo dnf config-manager --set-enabled rhel-8-for-x86_64-appstream-rpms
sudo dnf config-manager --set-enabled rhel-8-for-x86_64-baseos-rpmspos
```

## Setup SSH from Laptop to workstation

Purpose of this is to make sure all we can login from our laptop to workstation without being prompted for password. Makes life easier :)

- Generate SSH key pair
- Copy the .pub key to workstation
- Login to workstation
- Open 4 SSH tunnels that will route port 8000, 8888, 9000 and 9999 traffic from workstation to our laptop.

## CEPH-CLUSTER-1

- Dashboard will be available on port 8000
- Object Storage url will be available on port 8888

## CEPH-CLUSTER-2

- Dashboard will be available on port 9000
- Object Storage url will be available on port 9999

```bash
# On your local laptop
ssh-keygen -t rsa -b 4096 -f /path/to/your/keyfile # Give your own path
ssh-copy-id -o StrictHostKeyChecking=no -i "/path/to/your/keyfile/<id_rsa>.pub" -p 22 root@workstation # Instead of workstation, give IP or hostname for your workstation(jump host)

# Login to workstation
# It also opens 4 SSH tunnels
ssh -L 8000:localhost:8000 -L 9000:localhost:9000 -L 8888:localhost:8888 -L 9999:localhost:9999 root@workstation -p 22

# On workstation
# Change prompt color to Green
# I use it for ease when I am logging in and out of various machines
# You can skip it
echo 'export PS1="\[\e[0;32m\][\u@\h \W]\$ \[\e[m\]"' >> ~/.bashrc
source ~/.bashrc
```

## Setup SSH on workstation to other VMs

Purpose of this is to make sure ceph-mon01 and ceph-node01 can reach out to other VMs. Remember, these 2 VMs will be used to bootstrap clusters.

- Generate SSH key pair
- Create entries in /etc/hosts file
- Copy local /etc/hosts file to all other VMs
- Copy the private and pubic key to ceph-mon01 and ceph-node01.

```bash
# On workstation machine
# Create a key pair at /root/.ssh/
ssh-keygen -t rsa -b 4096

# Add hosts to /etc/hosts file
cat >> /etc/hosts << EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

192.168.99.252  workstation-9xl8z.stornet.example.com
192.168.99.61   ceph-node01
192.168.99.62   ceph-node02
192.168.99.63   ceph-node03
192.168.99.64   ceph-mon01
192.168.99.65   ceph-mon02
192.168.99.66   ceph-mon03
EOF

# Defining a list of all hostnames
hosts=(
    "ceph-mon01"
    "ceph-mon02"
    "ceph-mon03"
    "ceph-node01"
    "ceph-node02"
    "ceph-node03"
)

# Copy ssh public key to all other VMs
ssh-copy-id -o StrictHostKeyChecking=no root@ceph-mon01
ssh-copy-id -o StrictHostKeyChecking=no root@ceph-mon02
ssh-copy-id -o StrictHostKeyChecking=no root@ceph-mon03

ssh-copy-id -o StrictHostKeyChecking=no root@ceph-node01
ssh-copy-id -o StrictHostKeyChecking=no root@ceph-node02
ssh-copy-id -o StrictHostKeyChecking=no root@ceph-node03

# Copy `hosts` file to all other VMs
for host in "${hosts[@]}"; do
    scp -o StrictHostKeyChecking=no /etc/hosts "root@$host:/etc/hosts"
done

# Copy the SSH private and public keys from workstation to ceph-mon01 and ceph-node01.
scp /root/.ssh/id_rsa* root@ceph-mon01:/root/.ssh
scp /root/.ssh/id_rsa* root@ceph-node01:/root/.ssh
```

## Deploy CEPH-CLUSTER-1

Login to ceph-mon01 from workstation
2. Open 2 SSH tunnels that will route 8443 and 80 port traffic from ceph-mon01 to workstation

```bash
# Login to ceph-mon01 from workstation
ssh -L 8000:localhost:8443 -L 8888:localhost:80 root@ceph-mon01

# Change prompt color to Yellow
echo 'export PS1="\[\e[0;33m\][\u@\h \W]\$ \[\e[m\]"' >> ~/.bashrc
source ~/.bashrc
```

## 3. Install git and ansible

```bash
# On ceph-mon01

dnf -y install git ansible
```

## 4. Clone repo

`git clone <https://github.com/ceph/cephadm-ansible.git>`

## 5. Create Ansible inventory file

```bash
cat > /etc/ansible/hosts << EOF
[cluster1]
ceph-mon01
ceph-mon02
ceph-mon03

[cluster2]
ceph-node01
ceph-node02
ceph-node03
EOF
```

## 6. Run preflight checks on cluster 1 nodes

<https://hackmd.io/@yujungcheng/Hyu623GKi>
<https://docs.ceph.com/projects/ceph-ansible/en/stable/installation/non-containerized.html>

```bash
cd cephadm-ansible
ansible-playbook -i /etc/ansible/hosts -l cluster1 cephadm-preflight.yml

# Two new repos will be enabled: ceph_stable_noarch & ceph_stable_x86_64
# Check with

dnf repolist
```

7. Lets bootstrap CEPH-CLUSTER-1

Use your ceph-mon01 IP

```bash
cephadm bootstrap --mon-ip 192.168.99.64 --allow-fqdn-hostname
```

You should see login details for your Ceph cluster dashboard

8. Add ceph-mon02 and ceph-mon03 as hosts

You have to add ceph.pub to hosts that you want to ingest into your ceph cluster. We will then deploy `Object Storage Daemon (OSD)` on all available disks.

```bash
ssh-copy-id -o StrictHostKeyChecking=no -f -i /etc/ceph/ceph.pub root@ceph-mon02
ssh-copy-id -o StrictHostKeyChecking=no -f -i /etc/ceph/ceph.pub root@ceph-mon03

ceph orch host add ceph-mon02 192.168.99.65
ceph orch host add ceph-mon03 192.168.99.66

# Deploy OSD on all available disks

ceph orch apply osd --all-available-devices
```

Change dashboard admin password

```bash
echo "admin@123" > dashboard_password.yml
ceph dashboard ac-user-set-password admin -i dashboard_password.yml
```

Upgrade to Ceph 7

```bash
# update

ceph orch upgrade start --image quay.io/ceph/ceph:v18.2.1

# Check version with  

ceph --version

# Check upgrade status

ceph orch upgrade status
```

11. Access dashboard

Thanks to SSH Tunnels that we created. We can access the dashboard locally on our laptop

```bash
# On ceph-mon01
<https://localhost:8443/>

# On workstation machine
<https://localhost:8000/>

# On your laptop locally
<https://localhost:8000/>

# Test dashboard access

curl -k <https://localhost:8000/>
```

12. Verify Installation

```bash
cephadm shell
ceph -s

# ceph health detail

# ceph df

# ceph osd tree
```

## Deploy CEPH-CLUSTER-2

Login to ceph-node01 from workstation

Open 2 SSH tunnels that will route port 8443 and 80 traffic from ceph-node01 to 9000 and 9999 port on workstation

```bash
# Login to ceph-node01 from workstation as root

ssh -L 9000:localhost:8443 -L 9999:localhost:80 root@ceph-node01

# Change prompt color to Blue

echo 'export PS1="\[\e[0;34m\][\u@\h \W]\$ \[\e[m\]"' >> ~/.bashrc
source ~/.bashrc
```

3. Rest of the steps are the same

Just make necessary changes to IP and hostnames

Simple bash to deploy Ceph

```bash
# Install packages

dnf -y install git ansible

# Clone repo

git clone <https://github.com/ceph/cephadm-ansible.git>
cd cephadm-ansible

# Create ansible host file

cat > /etc/ansible/hosts << EOF
[cluster1]
ceph-mon01
ceph-mon02
ceph-mon03
[cluster2]
ceph-node01
ceph-node02
ceph-node03
EOF

# Run Pre flight checks

ansible-playbook -i /etc/ansible/hosts -l cluster2 cephadm-preflight.yml

# Deploy CEPH-CLUSTER-2

cephadm bootstrap --mon-ip 192.168.99.61 --allow-fqdn-hostname

# Verify

# curl -k <https://192.168.99.61:8443>

# Add hosts

ssh-copy-id -o StrictHostKeyChecking=no -f -i /etc/ceph/ceph.pub root@ceph-node02
ssh-copy-id -o StrictHostKeyChecking=no -f -i /etc/ceph/ceph.pub root@ceph-node03

ceph orch host add ceph-node02 192.168.99.62
ceph orch host add ceph-node03 192.168.99.63

ceph orch apply osd --all-available-devices

# Change dasboard admin password

echo "admin@123" > dashboard_password.yml
ceph dashboard ac-user-set-password admin -i dashboard_password.yml

# Upgrade to Ceph 7

ceph orch upgrade start --image quay.io/ceph/ceph:v18.2.1

# ceph --version

# ceph orch upgrade status

# Verify

cephadm shell
ceph -s  

# ceph health detail

# ceph df

# ceph osd tree
```

## Access Ceph Clusters

On your laptop open dashboards in two different browsers.

Credentials are

Username: admin

Password: admin@123

CEPH-CLUSTER-1: <https://localhost:8000>

![i1](https://miro.medium.com/v2/resize:fit:1100/format:webp/1*6tdW7C8SX-IBBUrboIdW6A.png)

CEPH-CLUSTER-2: <https://localhost:9000>

![i2](https://miro.medium.com/v2/resize:fit:1100/format:webp/1*TZtzSTOHp5yQNl6UBfduQw.png)

Congratulations if you have made it this far.

Now in next article, lets setup object storage on Ceph clusters and enable multi-site replication. See you there )
