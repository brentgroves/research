# **[Deploy SQL Server Linux containers on Kubernetes with StatefulSets](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-kubernetes-best-practices-statefulsets?view=sql-server-ver16)**

**[Current Status](../../../../../../development/status/weekly/current_status.md)**\
**[Research List](../../../../../research_list.md)**\
**[Back Main](../../../../../../README.md)**

## references

- **[statefulset tutorial](../../../../../a_l/k8s/concepts/statefulsets.md)**
- **[configure env variables on mssql](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-configure-environment-variables?view=sql-server-ver16)**
- **[best practices](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-kubernetes-best-practices-statefulsets?view=sql-server-ver16)**
- **[considerations](https://www.mssqltips.com/sqlservertip/6775/run-sql-server-on-kubernetes/)**
- **[workshop](https://github.com/microsoft/sqlworkshops-sql2019workshop/blob/master/sql2019workshop/07_SQLOnKubernetes.md)**

## **[sql server ubuntu images](https://mcr.microsoft.com/en-us/product/mssql/server/tags)**

Decide which image you want to use.

## **[create a debug pod](https://medium.com/@shambhand2020/create-the-various-debug-or-test-pod-inside-kubernetes-cluster-e4862c767b96)**

```bash
kubectl run -it --tty --rm debug --image=alpine --restart=Never -- sh
If you don't see a command prompt, try pressing enter.
/ # exit
pod "debug" deleted
```

## Kubernetes with StatefulSets

This article contains best practices and guidance for running SQL Server containers on Kubernetes with StatefulSets. We recommend deploying one SQL Server container (instance) per pod in Kubernetes. Thus, you have one SQL Server instance deployed per pod in the Kubernetes cluster.

Similarly, the deployment script recommendation is to deploy one SQL Server instance by setting the replicas value to 1. If you enter a number greater than 1 as the replicas value, you get that many SQL Server instances with corelated names. For example, in the below script, if you assigned the number 2 as the value for replicas, you would deploy two SQL Server pods, with the names mssql-0 and mssql-1 respectively.

Another reason we recommend one SQL Server per deployment script is to allow changes to configuration values, edition, trace flags, and other settings to be made independently for each SQL Server instance deployed.

## Cleanup

```bash
scc.sh repsys11_mgdw.yaml mgdw
kubectl delete statefulset/mgdw -n mgdw
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

This is the yaml for nodeport:

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

## STEP 5: **[Create a secret](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/)** to hold the sa password

**[Important](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-kubernetes-best-practices-statefulsets?view=sql-server-ver16)** The SA_PASSWORD environment variable is deprecated. Use MSSQL_SA_PASSWORD instead.

In order to use a password to connect to SQL Server, Kubernetes provides an object called a secret. Use the script step5_create_secret.ps1 to create the secret which runs the following command: (You are free to change the password but you will need to use the new password later in this Activity to connect to SQL Server)

references only:\
```kubectl create secret generic mssql-secret --from-literal=SA_PASSWORD="test"```
The name of the secret is called mssql-secret which you will need when deploying a pod later in this Activity.

When this command completes you should see the following message:

secret/mssql-secret created

I created the secret by doing this:

```bash
pushd .
cd ~/src/k8s/repsys/namespaces/mgdw/
kubectl apply -f credentials.yaml 
kubectl get secret credentials -o jsonpath='{.data.password2}' | base64 --decode
```

## STEP 6: Create persistent storage for databases

reference only:\
SQL Server needs persistent storage for databases and files. This is a similar concept to using a volume with containers to map to directories in the SQL Server container. Disk systems are exposed in Kubernetes as a StorageClass. Azure Kubernetes Service (AKS) exposes a StorageClass called managed-premium which is mapped to Azure Premium Storage. Applications like SQL Server can use a Persistent Volume Claim (PVC) to request storage from the azure-disk StorageClass.

I used hostpath-storage instead:\
Review how PVC/PV are automatically created in **[statefulsets](../../../../../a_l/k8s/concepts/statefulsets.md)**

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

## STEP 7: Deploy SQL Server as a **[statefulset](../../../../../a_l/k8s/concepts/statefulsets.md)**

In the following example, the StatefulSet workload name should match the .spec.template.metadata.labels value, which in this case is mssql. For more information, see StatefulSets.

## Important

**[configure env variables on mssql](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-configure-environment-variables?view=sql-server-ver16)**

The SA_PASSWORD environment variable is deprecated. Use MSSQL_SA_PASSWORD instead.

### **[security context reference](../../../../../a_l/k8s/concepts/security_context/fsgroup_gid.md)**

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mgdw # name of the StatefulSet workload, the SQL Server instance name is derived from this. We suggest to keep this name same as the .spec.template.metadata.labels, .spec.selector.matchLabels and .spec.serviceName to avoid confusion.
  namespace: mgdw
  labels:
    app: mgdw
spec:
  serviceName: "mgdw" # serviceName is the name of the service that governs this StatefulSet. This service must exist before the StatefulSet, and is responsible for the network identity of the set.
  replicas: 1
  selector:
    matchLabels:
      app: mgdw
  template:
    metadata:
      labels:
        app: mgdw # this has to be the same as .spec.selector.matchLabels, as documented [here](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
    spec:
      securityContext:
        fsGroup: 10001 
      containers:
        - name: mgdw # container name within the pod.
          image: mcr.microsoft.com/mssql/server:2019-latest
          ports:
            - containerPort: 1433
              name: mgdw
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
                  name: credentials
                  key: password2
          volumeMounts:
            - name: mgdw
              mountPath: "/var/opt/mssql"
  volumeClaimTemplates:
    - metadata:
        name: mgdw
      spec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 20Gi
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

## Deploy sql server

```bash
pushd .
cd ~/src/repsys/k8s/sql_server/
kubectl apply -f complete_mgdw.yaml 
```

## look at directory used for storage

```bash
sudo ls -alh /var/snap/microk8s/common/default-storage
total 12K
drwxr-xr-x 3 root root 4.0K Jul  5 20:25 .
drwxr-xr-x 9 root root 4.0K Jul  2 22:04 ..
drwxrwxrwx 6 root root 4.0K Jul  5 20:27 mgdw-mgdw-mgdw-0-pvc-893b559e-0644-4001-a1c7-96402e829318

```

To see the resources, you can run the kubectl get all command with the namespace specified to see these resources:

```bash
kubectl get all -n mgdw
NAME         READY   STATUS    RESTARTS   AGE
pod/mgdw-0   1/1     Running   0          3d1h

NAME           TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
service/mgdw   NodePort   10.152.183.236   <none>        1433:31433/TCP   5d

NAME                    READY   AGE
statefulset.apps/mgdw   1/1     3d1h
```

## **[Connect to SQL Server](https://spacelift.io/blog/kubectl-exec)**

Connect to Your Container
To get a bash shell into the running container:

```bash
kubectl exec --stdin --tty mgdw-0 -- /bin/bash
groups: cannot find name for group ID 10001
```

The following steps use the SQL Server command-line tool, sqlcmd utility, inside the container to connect to SQL Server.

Use the docker exec -it command to start an interactive bash shell inside your running container. In the following example, sql1 is name specified by the --name parameter when you created the container.

```Bash
# Once inside the container, connect locally with sqlcmd, using its full path.
sudo /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "~/src/secrets/namespaces/default/credentials.yaml"

# Create a new database
# The following steps create a new database named TestDB.
# From the sqlcmd command prompt, paste the following Transact-SQL command to create a test database:
CREATE DATABASE TestDB;
1> CREATE TABLE CUSTOMERS(    ID   INT              NOT NULL,    NAME VARCHAR (20)     NOT NULL,    AGE  INT              NOT NULL,    ADDRESS  CHAR (25) ,    SALARY   DECIMAL (18, 2),           PRIMARY KEY (ID));
2> go
1> INSERT INTO CUSTOMERS (ID,NAME,AGE,ADDRESS,SALARY) VALUES (1, 'Ramesh', 32, 'Ahmedabad', 2000.00 );
2> select * from customers;
3> go

(1 rows affected)
ID          NAME                 AGE         ADDRESS                   SALARY              
----------- -------------------- ----------- ------------------------- --------------------
          1 Ramesh                        32 Ahmedabad                              2000.00

# On the next line, write a query to return the name of all of the databases on your server:
1> select name from sys.databases;
2> go
name                                                                                                                          
--------------------------------------------------------------------------------------------------------------------------------
master                                                                                 tempdb                                                                                 model                                                                                  msdb                                                                                   TestDB  

(5 rows affected)
CREATE TABLE Inventory (id INT, name NVARCHAR(50), quantity INT);
INSERT INTO Inventory VALUES (1, 'banana', 150); INSERT INTO Inventory VALUES (2, 'orange', 154);
exit
```

<!-- https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver16&preserve-view=true&tabs=cli&pivots=cs1-bash -->

## Deployment workloads

You can use the deployment type for SQL Server, in scenarios where you want to deploy SQL Server containers as stateless database applications, for example when data persistence isn't critical. Some such examples are for test/QA or CI/CD purposes.

## Isolation through namespaces

Namespaces provide a mechanism for isolating groups of resources within a single Kubernetes cluster. For more about namespaces and when to use them, see Namespaces.

From the SQL Server perspective, if you plan to run SQL Server pods on a Kubernetes cluster that is also hosting other resources, you should run the SQL Server pods in their own namespace, for ease of management and administration. For example, consider you have multiple departments sharing the same Kubernetes cluster, and you want to deploy a SQL Server instance for the Sales team and another one for the Marketing team. You'll create two namespaces called sales and marketing, as shown in the following example:

```bash
kubectl create namespace sales
kubectl create namespace marketing
```

To check that the namespaces are created, run kubectl get namespaces, and you'll see a list similar to the following output.

Output

```bash
NAME              STATUS   AGE
default           Active   39d
kube-node-lease   Active   39d
kube-public       Active   39d
kube-system       Active   39d
marketing         Active   7s
sales             Active   26m
```

Now you can deploy SQL Server containers in each of these namespaces using the sample YAML shown in the following example. Notice the namespace metadata added to the deployment YAML, so all the containers and services of this deployment are deployed in the sales namespace.

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: azure-disk
provisioner: kubernetes.io/azure-disk
parameters:
  storageAccountType: Standard_LRS
  kind: Managed
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mssql-sales
  namespace: sales
  labels:
    app: mssql-sales
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
---
apiVersion: v1
kind: Service
metadata:
  name: mssql-sales-0
  namespace: sales
spec:
  type: LoadBalancer
  selector:
    statefulset.kubernetes.io/pod-name: mssql-sales-0
  ports:
    - protocol: TCP
      port: 1433
      targetPort: 1433
      name: tcpsql
```

**question**\
Shouldn't we change the name of the volume from mssql to mssql-sales?

<https://kubernetes.io/docs/tasks/configure-pod-container/security-context/>
