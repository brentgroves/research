# **[SQL2019 Workshop](https://github.com/microsoft/sqlworkshops-sql2019workshop/blob/master/sql2019workshop/07_SQLOnKubernetes.md)**

**[Current Status](../../../../../../development/status/weekly/current_status.md)**\
**[Research List](../../../../../research_list.md)**\
**[Back Main](../../../../../../README.md)**

## references

- **[Deploy SQL Server Linux containers on Kubernetes with StatefulSets](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-kubernetes-best-practices-statefulsets?view=sql-server-ver16)**
- **[configure env variables on mssql](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-configure-environment-variables?view=sql-server-ver16)**

- **[best practices](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-kubernetes-best-practices-statefulsets?view=sql-server-ver16)**
- **[considerations](https://www.mssqltips.com/sqlservertip/6775/run-sql-server-on-kubernetes/)**
- **[workshop](https://github.com/microsoft/sqlworkshops-sql2019workshop/blob/master/sql2019workshop/07_SQLOnKubernetes.md)**

## Deploying SQL Server on Kubernetes

Since SQL Server is a stateful container application it is a perfect fit to deploy and use on a Kubernetes platform.

## Activity: Deploying SQL Server on Kubernetes

In this activity you will learn the basics of how to deploy a SQL Server container in a Kubernetes cluster. You will learn various aspects of deploying in Kubernetes including common patterns such a namespace, node, pod, service, persistent volume claim, deployment, and ReplicaSet.

This activity is designed to be used with an Azure Kubernetes Service (AKS) cluster but most of the scripts and steps can be used with any Kubernetes cluster. This activity only requires a single-node Kubernetes cluster with only 6Gb RAM. Therefore this activity could be used even on a minikube cluster. While this module could be used on a RedHat OpenShift cluster you should use the workshop specifically designed for RedHat OpenShift at <https://github.com/Microsoft/sqlworkshops/tree/master/SQLonOpenShift>.

**NOTE: If at anytime during the Activities of this Module you need to "start over" you can run the script cleanup.ps1 or cleanup.sh and go back to the first Activity in 7.0 and run through all the steps again.

## Activity Steps

All scripts for this activity can be found in the sql2019workshop\07_SQLOnKubernetes\deploy folder.

There are two subfolders for scripts to be used in different shells:

powershell - Use scripts here for kubectl on Windows
bash - Use these scripts for kubectl on Linux or MacOS

## Cleanup

```bash
scc.sh repsys11_mgdw.yaml mgdw
kubectl delete service/mssql-service -n mgdw
kubectl delete pvc mssql-data -n mgdw
kubectl delete namespace mgdw
```

## STEP 1: Connect to the cluster

```bash
scc.sh repsys11_mgdw.yaml microk8s
```

## STEP 2: Create a namespace

A Kubernetes namespace is a scope object to organize your Kubernetes deployment and objects from other deployments. Run the script step2_create_namespace.ps1 which runs the following command:

```bash
kubectl create namespace mgdw
```

When this command completes you should see a message like

```namespace/mgdw created```

## STEP 3: Set the default context

To now deploy in Kubernetes you can specify which namespace to use with parameters. But there is also a method to set the context to the new namespace.

```bash
scc.sh repsys11_mgdw.yaml mgdw
```

## STEP 4: Create a Load Balancer Service

Deploy objects in Kubernetes is done in a declarative fashion. One of the key objects to create is a LoadBalancer service which is supported by default in Azure Kubernetes Service (AKS). A LoadBalancer provides a static public IP address mapped to a public IP address in Azure. You will be able to map the LoadBalancer to a SQL Server deployment including a port to map to the SQL Server port 1433. Non-cloud Kubernetes clusters also support a similar concept called a NodePort.

Reference only **I created a nodeport service instead:**

**[definition of port/targetport/nodeport](https://www.bmc.com/blogs/kubernetes-port-targetport-nodeport/)**

- **Port** exposes the Kubernetes service on the specified port within the cluster. Other pods within the cluster can communicate with this server on the specified port.
- **TargetPort** is the port on which the service will send requests to, that your pod will be listening on. Your application in the container will need to be listening on this port also.
- **NodePort** exposes a service externally to the cluster by means of the target nodes IP address and the NodePort. NodePort is the default setting if the port field is not specified.

References Only:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mssql-service
  namespace: mssql
spec:
  selector:
    app: mssql
  ports:
    - protocol: TCP
      port: 31433
      targetPort: 1433
  type: LoadBalancer
```

This is the nodeport that created:

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: mgdw
  namespace: mgdw
spec:
  type: NodePort
  selector:
    app: mgdw
  ports:
  - protocol: TCP
    # NodePort exposes a service externally to the cluster by means of
    # the target nodes IP address and the NodePort. NodePort is the default setting if the port field is not specified.
    nodePort: 31433
    # Port exposes the Kubernetes service on the specified port within the cluster. Other pods within 
    # the cluster can communicate with this server on the specified port.
    port: 1433
    # TargetPort is the port on which the service will send requests to, that your pod will be listening on. Your application 
    # in the container will need to be listening on this port also.
    targetPort: 1433
    name: mgdw
```

```bash
pushd .
cd ~/src/repsys/k8s/sql_server/
kubectl apply -f nodeport.yaml
kubectl get svc
NAME   TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
mgdw   NodePort   10.152.183.236   <none>        1433:31433/TCP   3m34s
```

## STEP 5: **[Create a secret](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/)** to hold the sa password

**[Important](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-kubernetes-best-practices-statefulsets?view=sql-server-ver16)** The SA_PASSWORD environment variable is deprecated. Use MSSQL_SA_PASSWORD instead.

In order to use a password to connect to SQL Server, Kubernetes provides an object called a secret. Use the script step5_create_secret.ps1 to create the secret which runs the following command: (You are free to change the password but you will need to use the new password later in this Activity to connect to SQL Server)

kubectl create secret generic mssql-secret --from-literal=SA_PASSWORD="Sql2019isfast"
The name of the secret is called mssql-secret which you will need when deploying a pod later in this Activity.

When this command completes you should see the following message:

secret/mssql-secret created
You cannot retrieve the plaintext of the password from the secret later so you need to remember this password.

I created the secret by doing this:

```bash
pushd .
cd ~/src/k8s/repsys/namespaces/mgdw/
kubectl apply -f credentials.yaml 
kubectl get secret credentials -o jsonpath='{.data.password2}' | base64 --decode
```

## STEP 6: Create persistent storage for databases

SQL Server needs persistent storage for databases and files. This is a similar concept to using a volume with containers to map to directories in the SQL Server container. Disk systems are exposed in Kubernetes as a StorageClass. Azure Kubernetes Service (AKS) exposes a StorageClass called managed-premium which is mapped to Azure Premium Storage. Applications like SQL Server can use a Persistent Volume Claim (PVC) to request storage from the azure-disk StorageClass.

Use **[hostpath-storage](https://microk8s.io/docs/addon-hostpath-storage)** in Microk8s:

```bash
microk8s enable hostpath-storage
Infer repository core for addon hostpath-storage
Enabling default storage class.
WARNING: Hostpath storage is not suitable for production environments.
         A hostpath volume can grow beyond the size limit set in the volume claim manifest.

deployment.apps/hostpath-provisioner created
storageclass.storage.k8s.io/microk8s-hostpath created
serviceaccount/microk8s-hostpath created
clusterrole.rbac.authorization.k8s.io/microk8s-hostpath created
clusterrolebinding.rbac.authorization.k8s.io/microk8s-hostpath created
Storage will be available soon.
# look at directory used for storage on each node
ls -alh /var/snap/microk8s/common/default-storage
total 8.0K
drwxr-xr-x 2 root root 4.0K Jul  2 22:04 .
drwxr-xr-x 9 root root 4.0K Jul  2 22:04 ..
# list storage classes
kubectl get sc 
NAME                          PROVISIONER            RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
microk8s-hostpath (default)   microk8s.io/hostpath   Delete          WaitForFirstConsumer   false                  2m28s        

```

The storage.yaml file declare the PVC request:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mssql-data
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 80Gi
```

```bash
pushd .
cd ~/src/repsys/k8s/sql_server/
kubectl apply -f storage.yaml
persistentvolumeclaim/mssql-data created

kubectl get pvc
NAME         STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS        VOLUMEATTRIBUTESCLASS   AGE
mssql-data   Pending                                      microk8s-hostpath   <unset>                 79s
```

The name of the PVC is mssql-data which will be used to map to the SQL Server container directory for databases when deploying the pod. The rest of the declaration specifies how to access the PVC which is ReadWriteOnce. ReadWriteOnce means one node a time in the cluster can access the PVC. The size of the PVC in this case is 8Gb which for the purposes of this activity is plenty of space.

## STEP 7: Deploy a pod with a SQL Server container

I did not use the yaml from step 7 instead I used the yaml from <https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-kubernetes-best-practices-statefulsets?view=sql-server-ver16> which used the statefulset deployment type.

Now that you have deployed a LoadBalancer service, a secret, and a Persistent Volume Claim (PVC),you have all the components to deploy a pod running a SQL Server container. To deploy the pod you will use a concept called Deployment which provides the ability to declare a ReplicaSet. Run the script step7_deploy_sql2019.ps1 and after it executes you will analyze the details of the deployment. This scripts runs the command:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mssql
  namespace: mssql
  labels:
    app: mssql
spec:
  serviceName: "mssql-sales"
  replicas: 1
  selector:
    matchLabels:
      app: mssql-sales
  template:
    metadata:
      labels:
        app: mssql-sales
    spec:
      securityContext:
        fsGroup: 10001
      containers:
        - name: mssql-sales
          image: mcr.microsoft.com/mssql/server:2019-latest
          ports:
            - containerPort: 1433
              name: tcpsql
          env:
            - name: ACCEPT_EULA
              value: "Y"
            - name: MSSQL_ENABLE_HADR
              value: "1"
            - name: MSSQL_AGENT_ENABLED
              value: "1"
            - name: MSSQL_SA_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mssql
                  key: MSSQL_SA_PASSWORD
          volumeMounts:
            - name: mssql
              mountPath: "/var/opt/mssql"
  volumeClaimTemplates:
    - metadata:
        name: mssql
      spec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 8Gi

```

## references

Limits and requests for memory are measured in bytes. You can express memory as a plain integer or as a fixed-point integer using one of these suffixes: E, P, T, G, M, K. You can also use the power-of-two equivalents: Ei, Pi, Ti, Gi, Mi, Ki.

So those are the "bibyte" counterparts, like user2864740 commented.

A **[little info](https://en.wikipedia.org/wiki/Kibibyte)** on those orders of magnitude:

The kibibyte was designed to replace the kilobyte in those computer science contexts in which the term kilobyte is used to mean 1024 bytes. The interpretation of kilobyte to denote 1024 bytes, conflicting with the SI definition of the prefix kilo (1000), used to be common.

## **[Next step 6](https://github.com/microsoft/sqlworkshops-sql2019workshop/blob/master/sql2019workshop/07_SQLOnKubernetes.md)**
