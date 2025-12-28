# **[PySpark Tutorial for Beginners - Jupyter Notebooks](https://github.com/coder2j/pyspark-tutorial)**

Welcome to the PySpark Tutorial for Beginners GitHub repository! This repository contains a collection of Jupyter notebooks used in my comprehensive YouTube video: **[PySpark tutorial for beginners](https://youtu.be/EB8lfdxpirM)**. These notebooks provide hands-on examples and code snippets to help you understand and practice PySpark concepts covered in the tutorial video.

If you find this tutorial helpful, consider sharing this video with your friends and colleagues to help them unlock the power of PySpark and unlock the following bonus videos.

## set env variables

- SPARK_HOME
- PYSPARK_DRIVER_PYTHON
- PYSPARK_DRIVER_PYTHON_OPTS
- PYSPARK_PYTHON

## Import the Spark Session Class

**[](https://spark.apache.org/docs/latest/api/java/org/apache/spark/sql/SparkSession.html)**

```python
from pyspark.sql import SparkSession
spark = SparkSession.builder \
  app.name("PySpark Get Started") \
  getOrCreate()
```

public abstract class SparkSession
extends Object
implements Serializable, Closeable
The entry point to programming Spark with the Dataset and DataFrame API.
In environments that this has been created upfront (e.g. REPL, notebooks), use the builder to get an existing session:

`SparkSession.builder().getOrCreate()`

The builder can also be used to create a new session:

```python
   SparkSession.builder
     .master("local")
     .appName("Word Count")
     .config("spark.some.config.option", "some-value")
     .getOrCreate()
```
