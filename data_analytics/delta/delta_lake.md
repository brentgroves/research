# **[What is a Delta Lake?](https://www.chaosgenius.io/blog/databricks-delta-lake/#what-is-data-lake)**

Data Lake is a centralized storage repository that allows for the storage of vast amounts of structured and unstructured data at any scale. It addresses the limitations of traditional data warehouses, which can only handle structured data.

In a data lake, raw data from varied sources like databases, applications, and the web is collected and made available for analysis. This avoids costly ETL jobs to curate and structure the data upfront.

However, data lakes have some drawbacks:

- **Lack of structure:** Data lakes store data as-is without enforcing any schema or quality checks.
- **Data spiraling out of control:** Data lakes can grow rapidly and uncontrollably as more and more data is ingested without proper governance and management. This can result in data duplication, inconsistency, and inefficiency.
- **Data reliability:** Data lakes do not provide any guarantees on the consistency, durability, and isolation of the data, which are essential for ensuring data integrity and preventing data corruption. Data lakes also do not support features such as versioning, auditing, and time travel, which are useful for tracking data changes and recovering from errors.

Here is where Delta Lake comes into play by addressing the above challenges and bringing reliability to data lakes at scale.

TL;DR: Here's a meme illustrating what Data Lake truly is. XD

![i1](https://www.chaosgenius.io/blog/content/images/2024/01/Databricks-Delta-Lake-15.png)

Jokes aside, let's jump into the next section, where we'll dive into understanding what Databricks Delta Lake is.

What is Databricks Delta Lake?
Databricks Delta Lake is an open source storage layer that brings ACID transactions, data versioning, schema enforcement, and efficient handling of batch and streaming data to data lakes. Developed by Databricks, Delta tables provide a reliable and performant foundation for working with large-scale data stored in Apache Spark-based data lakes.

Some key features of **[Databricks Delta Lake](https://delta.io/?ref=chaosgenius.io)** are:

**[Databricks Delta Lake](https://delta.io/?ref=chaosgenius.io)** is an **[open source](https://github.com/delta-io/delta?ref=chaosgenius.io)** storage layer that brings ACID transactions, data versioning, schema enforcement, and efficient handling of batch and streaming data to data lakes. Developed by Databricks, Delta tables provide a reliable and performant foundation for working with large-scale data stored in Apache Spark-based data lakes.
