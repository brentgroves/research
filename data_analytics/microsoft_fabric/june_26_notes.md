# goal

- move data to onelake

move data to cloud

## team

Oscar Zamora, <oszamora@microsoft.com>

## artifacts

5 links to docs

Data Migration Journey

Green field

Brown field

Siloed data across divisions

Siloed data refers to information that is isolated within a specific department or system, making it inaccessible or difficult to share with other parts of an organization. This isolation can hinder collaboration, lead to inefficiencies, and prevent informed decision-making.

Wholistic view of business

Advanced analytics and AI

decentralized data ownership

Migration (Brownfield)
Old stuff migration

Greenfield
New stuff
Medallian Architect

- Bronze to Silver to Gold
No existing data warehouse
uses excel

## questions

If we are brownfield. Should I recreate the Azure SQL db

## Points

business unit has its own workspace.
All data is reflected into OneLake.
shortcuts to shared workspace items.
OneLake workspace items can have controlled access to other business units.
Cross workspace data sharing.

- Not to duplicate data.

Azure AD groups and row-level security (RLS) security.
query data from the warehouse or onelake.

Microsoft Perview - Security, data governance and management, compliance.

How workspaces

Data Factory
Azure Databases
Spark
Data Warehouse - Column stored index (lookup)
Azure SQL databases
Fabric notebooks - Data analysis and machine learning
libraries for everything.

Lakehouse - raw data hub, reorganized in parquet format. I don't want to directly deal with excel, or some

Azure SQL database: transactionsl

Event Stream: Real-time data processing,

SSIS: data factory pipelines

direct lake: fast live reporting on large tables, high performance

power automate: workflow auto

kql database: Any large dataset, efficient, querying, big data analysis.

tsql data factory pipelines

power bi import mode - shared datasets, direct lake for large tables

sql server - fabric data warehouse

no semantic model - power bi dataset

Excel Power bi dataset
oracle, jde, files, apis fabric lakehouse (raw data hub for all sources)

Power BI via DirectQuery to SSAS - Power BI

3rd party land in Fabric Lakehouse to data warehouse
