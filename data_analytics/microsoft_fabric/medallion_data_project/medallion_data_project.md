# **[Design MICROSOFT FABRIC Data Project with Medallion Architecture | Lakehouse + Spark + Power BI](https://www.youtube.com/watch?v=qG65DUcSjws)**

## next

- **[medallion lakehouse](https://www.youtube.com/watch?v=bSJWR5CFwmU)**

1h00

## code

- **[](https://github.com/nextgendatahub/MedallionLakehouseFabric)**
- **[](https://github.com/nextgendatahub/MedallionLakehouseFabric/tree/main/ShoppingMart_StructuredData)**
- **[](https://github.com/nextgendatahub/MedallionLakehouseFabric/tree/main/ShoppingMart_UnstructuredData)**

## medalion

created by databricks now industry standard

- bronze - raw
  - enriched zone
  - stores source data in original format, including unstructured, semi-structured, or structured data types
- silver - validated
  - data is cleansed and standardized
  - validate and deduplicate your data
- gold - business ready
  - curated zone
  - data is refined to meet specific downstream business and analytics requirements

- ![med](https://blog.bismart.com/hs-fs/hubfs/Arquitectura_Medallion_Pasos.jpg?width=1754&height=656&name=Arquitectura_Medallion_Pasos.jpg)

## raw data

OrderID,OrderDate,CustomerID,ProductID,Quantity,TotalAmount,PaymentMethod
`https://raw.githubusercontent.com/nextgendatahub/MedallionLakehouseFabric/refs/heads/main/ShoppingMart_StructuredMetaData.json`
`refs/heads/main/ShoppingMart_StructuredMetaData.json`
`https://raw.githubusercontent.com/nextgendatahub/MedallionLakehouseFabric/refs/heads/main/ShoppingMart_StructuredData/Orders_Data.csv`
`https://raw.githubusercontent.com/nextgendatahub/MedallionLakehouseFabric/refs/heads/main/ShoppingMart_StructuredData/products.csv`

## Silver layer

- insert bronze layer raw data into parquet file

## ShoppingMartAnalytics Workspace

- select medallion task flow
Organize data in your lakehouse or warehouse while progressively improving its structure and quality in each layer from Bronze to silver to gold. resulting in quality data that is easy to analyze.

**[lakehouse](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-overview)**

abfss://fad2d397-2419-4518-aa81-b0d383e4f42d@onelake.dfs.fabric.microsoft.com/fd2ba9a3-abca-409b-8b9b-7ae15489deae/Files/ShoppingMartBronze
E055-Linamar Structures/E055_Linamar_Structures_Bronze_Lakehouse/Files/

E055-Linamar Structures/E055_Linamar_Structures_Bronze_Lakehouse/Files/ShoppingMartBronze/

Files/ShoppingMartBronze/FactBudget.csv

StagingLakehouseForDataflows_20250724193311.FolderPath

Connect to data destination

Connection
E055_Linamar_Structures_Bronze_Lakehouse

Copy data into Lakehouse
If the identity you use to access the data store only has permission to subdirectory instead of the entire account, specify the path to browse.

/E055-Linamar Structures/E055_Linamar_Structures_Bronze_Lakehouse/Files/

DelimitedText
Source
Connection name
orders bGroves
DelimitedText
Destination
Connection name
E055_Linamar_Structures_Bronze_Lakehouse
File name
test2.csv
Folder path
E055-Linamar Structures/E055_Linamar_Structures_Bronze_Lakehouse/Files

## Steps

 1. go to E055-Linamar Structures workspace
 2. new item: copy job
 3. choose data source: http
    base url: <https://raw.githubusercontent.com/nextgendatahub/MedallionLakehouseFabric/>
    path: refs/heads/main/ShoppingMart_StructuredData/Orders_Data.csv
    preview data works.
 4. data destination: E055_Linamar_Structures_Bronze_Lakehouse
copy mode: full copy
map to destination: files
Clicked the browse button for each folder path:

- blank,
- Files
- \Files
- \Files\
- /Files
- E055_Linamar_Structures_Bronze_Lakehouse
- \E055_Linamar_Structures_Bronze_Lakehouse
- /E055_Linamar_Structures_Bronze_Lakehouse
- Data Consolidation/Lakehouse/E055_Linamar_Structures_Bronze_Lakehouse/Files/
- E055-Linamar Structures/Data Consolidation/Lakehouse/E055_Linamar_Structures_Bronze_Lakehouse/Files/
- E055-Linamar Structures/
- E055-Linamar Structures/E055_Linamar_Structures_Bronze_Lakehouse/Files/
- /E055-Linamar Structures/E055_Linamar_Structures_Bronze_Lakehouse/Files/
- E055-Linamar Structures/test/Files/
10.188.50.83
nutanix/
If the identity you use to access the data store only has permission to subdirectory instead of the entire account, specify the path to browse.
**Error:**
Root folder
Failed to load
Internal error has occurred. Activity ID: 0bc325f0-2b0f-4c4e-9572-cf14570dc3aa

File name: test.csv
Copy behavior: flatten hierarchy
File format: delimitted text

SQL connection string: ldak3twx7jvuxaylacwhhfsu6a-s7j5f6qzeqmelkubwdjyhzhufu.datawarehouse.fabric.microsoft.com

Goal: Data Pipeline/Copy Data activity

Lakehouse: E055_Linamar_Structures_Bronze_Lakehouse
Root Folder: Files
File Path: E055-Linamar Structures/E055_Linamar_Structures_Bronze_Lakehouse/Files/test.csv
File Format: Delimited Text

Failed to load
Internal error has occurred. Activity ID: fff2c811-564d-41e7-8e8f-a81b575612c7
How helpful or unhelpful was this

**[error](https://community.fabric.microsoft.com/t5/Fabric-platform/Error-Opening-List-of-Files-in-Lakehouse-during-copy-Data-job/m-p/4859891)**
