# **[PySpark Tutorial](https://www.geeksforgeeks.org/python/pyspark-tutorial/)**

Last Updated : 18 Jul, 2025
PySpark is the Python API for Apache Spark, designed for big data processing and analytics. It lets Python developers use Spark's powerful distributed computing to efficiently process large datasets across clusters. It is widely used in data analysis, machine learning and real-time processing.

![i](https://media.geeksforgeeks.org/wp-content/uploads/20250718112356343916/statistics_key_concepts.webp)

![uc](https://media.geeksforgeeks.org/wp-content/uploads/20250718112414066225/use_cases_of_pyspark.webp)

![c](https://media.geeksforgeeks.org/wp-content/uploads/20250718112553588272/PySpark-Core-Modules.webp)

## Important Facts to Know

- Distributed Computing: PySpark runs computations in parallel across a cluster, enabling fast data processing.
- Fault Tolerance: Spark recovers lost data using lineage information in resilient distributed datasets (RDDs).
- Lazy Evaluation: Transformations aren’t executed until an action is called, allowing for optimization.

## What is PySpark Used For?

PySpark lets you use Python to process and analyze huge datasets that can’t fit on one computer. It runs across many machines, making big data tasks faster and easier. You can use PySpark to:

- Perform batch and real-time processing on large datasets.
- Execute SQL queries on distributed data.
- Run scalable machine learning models.
- Stream real-time data from sources like Kafka or TCP sockets.
- Process graph data using GraphFrames.

## Why Learn PySpark?

PySpark is one of the top tools for big data. It combines Python’s simplicity with Spark’s power, making it perfect for handling huge datasets.

- Enables efficient processing of petabyte-scale datasets.
- Integrates seamlessly with the Python ecosystem (pandas, NumPy, scikit-learn).
- Offers unified APIs for batch, streaming, SQL, ML and graph processing.
- Runs on Hadoop, Kubernetes, Mesos or standalone.
- Powering companies like Walmart, Trivago and many more.

## PySpark Basics

Learn how to set up PySpark on your system and start writing distributed Python applications.

- Introduction to PySpark
- Installing PySpark in Jupyter Notebook
- Installing Pyspark in kaggle
- Checking Pyspark Version

## Working with PySpark

Start working with data using RDDs and DataFrames for distributed processing.

Creating RDDs and DataFrames: Build DataFrames in multiple ways and define custom schemas for better control.

- **[Load data from external sources (CSV, JSON, Parquet)](https://www.geeksforgeeks.org/python/pyspark-read-csv-file-into-dataframe/)**
- Convert between RDDs and DataFrames
- Create a DataFrame
- From multiple lists
- From dictionary
- Using custom row objects
- Appy custom Schema

## Basic Example: Word Count with PySpark

Here’s a simple PySpark example that reads a text file and counts the frequency of each word:

```python
from pyspark import SparkContext
sc = SparkContext("local", "WordCount")
txt = "PySpark makes big data processing fast and easy with Python"
rdd = sc.parallelize([txt])
​
counts = rdd.flatMap(lambda x: x.split()) \
            .map(lambda word: (word, 1)) \
            .reduceByKey(lambda a, b: a + b)
​
print(counts.collect())
sc.stop()
```

Output

[('PySpark', 1), ('makes', 1), ('big', 1), ('data', 1), ('processing', 1), ('fast', 1), ('and', 1), ('easy', 1), ('with', 1), ('Python', 1)]

Explanation:

sc.parallelize() creates an RDD from the text. flatMap() splits lines into words, map() creates (word, 1) pairs and reduceByKey() adds up word counts.
collect() gathers the final word count output from all Spark worker nodes to the driver.
sc.stop() stops the SparkContext to free up system resources.
