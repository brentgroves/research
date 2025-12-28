# IS Team Projects

The following is in markdown format it can be viewed better from <https://markdownlivepreview.com/> by copying and pasting the contents below.

![cp](https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,w_4096,h_1377/https://assets.ubuntu.com/v1/e55cc8c0-wide-server.png)

## Research

I have been researching the following:

- How to add general purpose services such as **[mTLS](https://www.cloudflare.com/learning/access-management/what-is-mutual-tls/#:~:text=Mutual%20TLS%2C%20or%20mTLS%20for,have%20the%20correct%20private%20key.)**, **[service mesh](https://aws.amazon.com/what-is/service-mesh/#:~:text=A%20service%20mesh%20is%20a,with%20multiple%20service%20management%20systems.)**, **[authentication, and authorization](https://auth0.com/docs/get-started/auth0-overview#:~:text=Auth0%20is%20a%20flexible%2C%20drop,delivered%20by%20email%20or%20SMS.)**, **[email delivery](https://mailtrap.io/)**, **[notification system](https://novu.co/)**, and **[site reliability engineering monitoring](https://sysdig.com/blog/monitor-istio/)** to our Kubernetes platforms. 
- How to setup an on-prem Kubernetes platform that meets the requirement of running within our Linamar network.
- How to create Azure resources in the Linamar tenant.

## Projects

- **[MicroStack MAAS](https://canonical.com/microstack/docs/multi-node-maas)** On-Prem Kubernetes Cluster

MicroStack MAAS is a combination of MicroStack and MAAS (Metal as a Service) that allows for network traffic isolation and cloud deployment. MicroStack is an OpenStack distribution that's designed for small-scale cloud environments. MAAS is a tool that allows users to control pools of physical servers like virtual machines in the cloud. 

  - config request
    - allow list
    - unrestricted access week of Feb 10
  - R620 setup
    - Ubuntu Server
      - Port-Forward Router to MAAS 
      - Multipass **[cloud-init](https://cloud-init.io/)** enabled hypervisor
        - MAAS VM
          - Port-Forward Router to K8s nodes
          - Nested VM
            - K8s nodes

  Users: Anyone needing live or long running reports, Excel, or Power BI dashboards. 

  Status: Recently, got approval for firewall allow list.

  Timeline:

- Automated Reporting System
  - End-user request kicks off scripts to extract data from the Plex ERP, transforms it, and then loads the result into a database table in the data warehouse.
  - Produce Excel, archive result set, and email to end user.
  - Used for reports requiring long running scripts or live data.
  - Used to enable the creation of PowerBI dashboards for Plex ERP. 

  Users: Anyone needing live or long running reports, Excel, or Power BI dashboards. 

  Status: Recently, got approval for Azure resources needed for this project.

  Timeline:

  - Setup Azure Kubernetes Platform with general purpose services such as **[mTLS](https://www.cloudflare.com/learning/access-management/what-is-mutual-tls/#:~:text=Mutual%20TLS%2C%20or%20mTLS%20for,have%20the%20correct%20private%20key.)**, **[service mesh](https://aws.amazon.com/what-is/service-mesh/#:~:text=A%20service%20mesh%20is%20a,with%20multiple%20service%20management%20systems.)**, **[authentication, and authorization](https://auth0.com/docs/get-started/auth0-overview#:~:text=Auth0%20is%20a%20flexible%2C%20drop,delivered%20by%20email%20or%20SMS.)**, **[email delivery](https://mailtrap.io/)**, **[notification system](https://novu.co/)**, and **[site reliability engineering monitoring](https://sysdig.com/blog/monitor-istio/)**.
    - Estimated completion: May
    
  - Create **[ETL scripts](https://www.sas.com/en_us/insights/data-management/what-is-etl.html#:~:text=ETL%20is%20a%20method%20of,and%20programmatic%20data%20movement%20methods.%20.)** and **[microservices](https://aws.amazon.com/microservices/#:~:text=Microservices%20are%20an%20architectural%20and,to%2Dmarket%20for%20new%20features.)** to automate report requests using the platform services discussed above. 
    - Estimated completion: Sept

- **[Tool Management](https://en.wikipedia.org/wiki/Tool_management)**

  Move away from managing CNC tooling in Excel and the Busche Tool List to a more rubust and easy to use system.
    - Users: Albion MRP and Engineering
    - Estimated completion: TBD
- **[Tool Tracker](https://en.wikipedia.org/wiki/Manufacturing_execution_system)**

  Automatically collect CNC, job, and start/end tool operation times for problematic tooling.
  - Users: Albion Engineering and MRP
  - Estimated completion: TBD
- **INC0417507 - Excel VBA to Power BI**

  I suggest we migrate this VBA Excel program to a Web App, SQL database, and Power BI. The downside to this suggestion is that it would take some time. The upside is that the Web App can perform validation on the dates and other information before being saved to the database. Using VBA it is easy to create complex programs to solve business needs quickly, but it is difficult to make these programs robust.
  - Estimated completion: TBD

- Linus **[Platform](https://platformengineering.org/blog/what-is-platform-engineering)** and **[Site Reliability Engineering (SRE)](https://aws.amazon.com/what-is/sre/#:~:text=Site%20reliability%20engineering%20(SRE)%20teams%20collect%20critical%20information%20that%20reflects,application%20responds%20to%20a%20request.)**
  
  - Research and make recommendations to improve platform reliability.
  - Use MicroK8s on-prem cluster for research and testing.
  - Show **[security](https://www.infracloud.io/blogs/request-level-authentication-authorization-istio-keycloak/)**
    and reliability of **[Azure AKS](https://learn.microsoft.com/en-us/azure/aks/what-is-aks#:~:text=Azure%20Kubernetes%20Service%20(AKS)%20is,of%20that%20responsibility%20to%20Azure.)**.
  - **[Istio Service Mesh SRE monitoring](https://sysdig.com/blog/monitor-istio/)**

    ![isre](https://sysdig.com/wp-content/uploads/image8-6.png)

    - Users: Linus recommendation.
    - Estimated completion: TBD

## Azure Resources

- **[Azure Kubernetes Service, 2nd best Kubernetes platform](https://azure.microsoft.com/en-gb/products/kubernetes-service)**
- **[Azure SQL database (fully managed cloud database)](https://azure.microsoft.com/en-us/products/azure-sql/database)**

## Managed Kubernetes Service

- **[Top 10 Managed K8s Platforms](https://technologymagazine.com/top10/top-10-managed-kubernetes-platforms)**

- **[Azure Kubernetes Service (AKS), 2nd best Kubernetes platform](https://azure.microsoft.com/en-gb/products/kubernetes-service)**

  I have been using this for a few years and what I notice most is that the applications running in it **never fail/restart**.

## Kubernetes Development/Test Platform

- **[Dell PowerEdge R620](https://www.itcreations.com/dell/dell-poweredge-r620-server#:~:text=The%20Dell%20PowerEdge%20R620%20server,need%20powerful%20processing%20and%20storage.)**
- **[Ubuntu Server 24.04](https://ubuntu.com/server)**
- **[Microk8s on Multipass VM](https://ubuntu.com/tutorials/getting-started-with-kubernetes-ha)**  

## Security

- **[Secure a database in Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/secure-database-tutorial?view=azuresql)**
- **[Istio Service Mesh](https://istio.io/latest/docs/concepts/security/)**
  - **[authentication policies](https://istio.io/latest/docs/concepts/security/#authentication-policies)**
  - **[authorization policies](https://istio.io/latest/docs/concepts/security/#authorization-policies)**
  - **[secure naming information](https://istio.io/latest/docs/concepts/security/#secure-naming)**

## Kubernetes  

|Component   |Type   |Description   |
|---|---|---|
|**[Istio Service Mesh](https://istio.io/latest/docs/overview/what-is-istio/)**  | OSS   |**[Istioctl CLI](https://istio.io/latest/docs/setup/install/istioctl/)**   |
|**[Redis Sentinel One](https://www.einfochips.com/blog/redis-cache-and-its-use-cases-for-modern-application/)**   |OSS   |**[Redis Operator](https://medium.com/@khadkakripu4/leveraging-redis-sentinel-with-bitnami-redis-helm-chart-for-high-availability-in-kubernetes-a25d79e20e69)**   |
|**[Auth0 IAM Platform](https://www.weareplanet.com/blog/what-is-auth0#:~:text=Auth0%20is%20a%20platform%20companies,security%20and%20compliance%20much%20easier.)**  |Free Tier   |**[Register App with Azure Entra](https://auth0.com/docs/authenticate/identity-providers/enterprise-identity-providers/azure-active-directory/v2)**   |
|**[MongoDB](https://www.mongodb.com/company/what-is-mongodb)**   |OSS   |**[MongoDB Community Operator](https://www.mongodb.com/try/download/community-kubernetes-operator)**   |
|**[Minio Object Store](https://min.io/)**   |OSS   |**[Minio Operator](https://min.io/docs/minio/kubernetes/aks/operations/installation.html)**   |
|**[Mailtrap Email service](https://mailtrap.io/email-sending/)**  | Free Tier  |**[gRPC Microservice](https://grpc.io/docs/what-is-grpc/introduction/)**   |
|**[End-User Notification Platform](https://novu.co/)**  | Free Tier |**[Email, SMS, Push, Inbox, and Chat Notification Service](https://novu.co/)**  |

## Azure resources

- **[Azure AKS Entra ID managed cluster](https://learn.microsoft.com/en-us/azure/aks/enable-authentication-microsoft-entra-id)**
  - ~ $350/month
  - Our current cluster uses one **[Standard_D8_v3](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/general-purpose/dv3-series?tabs=sizebasic)** VM which has 8 vCPU and 32 GB ram.
  - Second resource group. When you create a new cluster, AKS automatically creates a second resource group to store the AKS resources. For more information, see **[Why are two resource groups created with AKS?](https://learn.microsoft.com/en-us/azure/aks/faq#why-are-two-resource-groups-created-with-aks)**

- **[Fully Mangaged Azure SQL Database](https://learn.microsoft.com/en-us/sql/sql-server/sql-docs-navigation-guide?view=sql-server-ver16#applies-to)**
  - ~ $50/month
  - Standard S1 service tier and 20 **[DTU](https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-dtu?view=azuresql#database-transaction-units-dtus)** capacity.
