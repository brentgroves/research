# **[Spark DataFrame](https://www.baeldung.com/spark-dataframes)**

PySpark is the library we use to access the Apache Spark tungsten-based distributed processing engine.

1. Overview

    Apache Spark is an open-source and distributed analytics and processing system that enables data engineering and data science at scale. It simplifies the development of analytics-oriented applications by offering a unified API for data transfer, massive transformations, and distribution.

    The DataFrame is an important and essential component of Spark API. In this tutorial, we’ll look into some of the Spark DataFrame APIs using a simple customer data example.

2. DataFrame in Spark
    Logically, a DataFrame is an immutable set of records organized into named columns. It shares similarities with a table in RDBMS or a ResultSet in Java.

    As an API, the DataFrame provides unified access to multiple Spark libraries including **[Spark SQL, Spark Streaming, MLib, and GraphX](https://www.baeldung.com/apache-spark)**.

    In Java, we use Dataset<Row> to represent a DataFrame.

    Essentially, a Row uses efficient storage called Tungsten, which highly optimizes Spark operations in comparison with its predecessors.

3. Maven Dependencies
    Let’s start by adding the spark-core and spark-sql dependencies to our pom.xml:

    <dependency>
        <groupId>org.apache.spark</groupId>
        <artifactId>spark-core_2.11</artifactId>
        <version>2.4.8</version>
    </dependency>

    <dependency>
        <groupId>org.apache.spark</groupId>
        <artifactId>spark-sql_2.11</artifactId>
        <version>2.4.8</version>
    </dependency>
