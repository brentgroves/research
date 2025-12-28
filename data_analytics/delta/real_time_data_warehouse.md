# **[Real-time data warehousing with Apache Spark and Delta Lake](https://www.sigmoid.com/blogs/near-real-time-finance-data-warehousing-using-apache-spark-and-delta-lake/)**

![i1](https://www.sigmoid.com/wp-content/uploads/2020/08/Real-Time-Data-Warehousing-with-Apache-Spark-and-Delta-Lake-banner-opt-1.jpg)

Financial institutions globally deal with massive data volumes that call for large-scale data warehouses and effective processing of **[real-time](https://www.sigmoid.com/blogs/automate-data-ingestion/)** transactions. In this blog, we shall discuss the current challenges in these areas and also understand how **[Delta lakes](https://www.sigmoid.com/blogs/near-real-time-finance-data-warehousing-using-apache-spark-and-delta-lake/)** go a long way in overcoming some common hurdles. We would be exploring **[Apache Spark](https://www.sigmoid.com/blogs/optimize-nested-queries-using-apache-spark/)** architecture for **[data warehouse](https://www.sigmoid.com/etl-and-data-pipeline/)** which comes under the purview of data engineering.

## Problem Statement

Let us begin with the exploration of a use case: A Real-time transaction monitoring service for an online financial firm that deals with products such as “Pay Later and Personal Loan”. This firm needs:

1, An alert mechanism to flag off fraud transactions – If a customer finds a small loophole in the underwriting rules then he can exploit the system by taking multiple PLs and online purchases through the Pay Later option which is very difficult and sometimes impossible to recover.
2. Speeding up of troubleshooting and research in case of system failure or slowdown
3. Tracking and evaluation of responses to Marketing campaigns, instantaneously

To achieve the above they want to build a near-real-time (NRT) data lake:

- To store ~400TB – last 2 years of historical transaction data
- Handle ~10k transaction records every 5 minutes results of various campaigns.

## Note

A typical transaction goes through multiple steps,

- Capturing the transaction details
- Encryption of the transaction information
- Routing to the payment processor
- Return of either an approval or a decline notice.

And the **[data lake](https://www.sigmoid.com/case-studies/data-lake-creation/)** should have a single record for each transaction and it should be the latest state.

## Solution Choices: Using Data Lake Architecture

Approach 1: Create a Data Pipeline using **[Apache Spark – Structured Streaming (with data deduped)](https://www.sigmoid.com/blogs/spark-streaming-production/%22)**

A three steps process can be:

1. Read the transaction data from Kafka every 5 minutes as micro-batches and store them as small parquet files
2. Merge all the new files and the historical data to come up with the new dataset at a regular interval, maybe once every 3 hrs and the same can be consumed downstream through any of the querying systems like Presto, AWS Athena, **[Google BigQuery](https://www.sigmoid.com/blogs/apache-spark-on-dataproc-vs-google-bigquery/)**, etc.
3. Create a Presto or Athena table to make this data available for querying.

![i1](https://www.sigmoid.com/wp-content/uploads/2025/03/Data-Lake-Architecture-approach-1-opt.jpg)

## Challenges

1. Preparing the consolidated data every 3 hours becomes challenging when the dataset size increases dramatically.
2. If we increase the batch execution interval from 3 hours to more, say 6 or 12 hours then this isn’t NRT data lake,

- Any bug in the system if identified by the opportunists, can be exploited and can’t be tracked by IT teams immediately. By the time they see this on the dashboard (after 6 or 12 hours), the business would have already lost a significant amount of money.
- It’s also not very useful for monitoring specific event based campaign, e.g. 5% cashback on food delivery, on the day of “World Cup – Semi-final match”.

## Approach 2: Create a Data Pipeline using Apache Spark – Structured Streaming (with duplicate data)

A two steps process can be

1. Read the transaction data from Kafka every 5 minutes as micro-batches and store them as small parquet files without any data deduplication,
2. Create an AWS Athena table on top of it and query the data properly,

![i2](https://www.sigmoid.com/wp-content/uploads/2025/03/Data-Lacke-Architecture-approach-2-opt.jpg)

## Challenges 1

Adding this additional “where” condition adds extra latency to each of the queries and it would soon become an extra overhead when the data reaches petabytes scale.

## Summary

- In the 1st approach, there are 2 copies of the same data, one is the raw data and the other is the transaction data with the latest state. The raw copy of the data isn’t of any use and is also maintained in the Kafka topic.
- In the 2nd approach, we’re maintaining a single copy of the transaction base but it has duplicates. And we always have to add the filter condition of removing the stale transactions in our query.

Is there any way we can maintain only one copy of the transaction base with the latest transaction state and can provide an easy means to traverse through different snapshots?

Can we add the ACID properties to that single copy of the transaction base parquet table?

Delta Lake by Databricks addresses the above issues when used along with Apache Spark for not just Structured Streaming, but also for use with DataFrame (batch based application).

## A Quick Introduction to Delta Lake

Enterprises have been spending millions of dollars getting data into data lakes with Apache Spark. The aspiration is to do Machine Learning on all that data – Recommendation Engines, Forecasting, Fraud/Risk Detection, IoT & Predictive Maintenance, Genomics, DNA Sequencing, and more. But the majority of the projects fail to see fruition due to unreliable data and data that is not ready for ML.

~60% of big data projects fail each year according to Gartner.

These include data reliability challenges with data lakes, such as:

- Failed production jobs that leave data in a corrupt state requiring tedious recovery
- Lack of schema enforcement creating inconsistent and low-quality data
- Lack of consistency making it almost impossible to mix appends and reads, batch and streaming

That’s where Delta Lake comes in. Some salient features are:

- Open format based on parquet
- Provides ACID transactions
- Apache Spark’s API
- Apache Spark’s API

![i2](https://www.sigmoid.com/wp-content/uploads/2025/03/delta-lacke-img-1-opt.jpg)

Project Architecture

![i3](https://www.sigmoid.com/wp-content/uploads/2025/03/delta-lacke-project-architecture-img-opt.jpg)

A three steps process for our use case

1. Create a delta table by reading historical transaction data,
2. Read the transaction data from Kafka every 5 minutes as micro-batches,
3. Then merge them with the existing delta table

## Conclusion

The table below indicates how solutions with Data Lakes & Delta lake architecture compare with each other on different parameters and highlights the advantages that Delta Lakes have to offer.
