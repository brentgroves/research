# **[](https://www.geeksforgeeks.org/python/pyspark-read-csv-file-into-dataframe/)**

PySpark - Read CSV file into DataFrame
Last Updated : 25 Oct, 2021
In this article, we are going to see how to read CSV files into Dataframe. For this, we will use Pyspark and Python.

Files Used:

authors
book_author
books

## Read CSV File into DataFrame

Here we are going to read a single CSV into dataframe using spark.read.csv and then create dataframe with this data using .toPandas().

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.appName(
    'Read CSV File into DataFrame').getOrCreate()

authors = spark.read.csv('/content/authors.csv', sep=',',
                         inferSchema=True, header=True)

df = authors.toPandas()
df.head()
```
