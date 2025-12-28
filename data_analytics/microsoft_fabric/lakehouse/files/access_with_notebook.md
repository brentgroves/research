# **[How to Access Files in Microsoft Fabric Lakehouse Using Notebooks](<https://snorreglemmestad.com/2025/06/07/how-to-access-files-in-microsoft-fabric-lakehouse-using-notebooks/>)**

June 7, 2025

## Introduction

Microsoft Fabric’s lakehouse architecture provides a powerful foundation for storing and processing data at scale. One of the key capabilities is accessing files stored in the lakehouse directly from Fabric notebooks using both pandas and PySpark. This approach allows data professionals to seamlessly work with various file formats while leveraging the distributed computing power of Spark when needed.

In this guide, we’ll walk through the process of accessing Excel files stored in a Fabric lakehouse using a notebook, demonstrating how to read the data with pandas and convert it to a Spark DataFrame for further processing.

## Prerequisites

- Access to Microsoft Fabric workspace
- A lakehouse with files stored in the Files section
- Basic knowledge of Python and pandas
- Understanding of Spark DataFrames

abfss://fad2d397-2419-4518-aa81-b0d383e4f42d@onelake.dfs.fabric.microsoft.com/fd2ba9a3-abca-409b-8b9b-7ae15489deae/Files/ShoppingMartBronze/FactBudget.csv

```python
import pandas as pd
from pyspark.sql import SparkSession

# Define lakehouse path and file location
# lakehouse_abfss = "abfss://[workspace-id]@onelake.dfs.fabric.microsoft.com/[lakehouse-id]"
# file_location = "Files/your_file.xlsx"

lakehouse_abfss = "abfss://fad2d397-2419-4518-aa81-b0d383e4f42d@onelake.dfs.fabric.microsoft.com/fd2ba9a3-abca-409b-8b9b-7ae15489deae"
file_location = "Files/ShoppingMartBronze/FactBudget.csv"

# Combine to create full path
# excel_path = f"{lakehouse_abfss}/{file_location}"
csv_path = f"{lakehouse_abfss}/{file_location}"
```

Step 4: Read the File with Pandas
Use pandas to read the Excel file directly from the lakehouse:

## Read Excel file with pandas

```python
# pandas_df = pd.read_excel(excel_path)
pandas_df = pd.read_excel(csv_path)

```

This approach is particularly useful for smaller files or when you need pandas-specific functionality for data manipulation.

Step 5: Convert to Spark DataFrame
For larger datasets or when you need distributed processing capabilities, convert the pandas DataFrame to a Spark DataFrame:

```python
# Convert to Spark DataFrame
spark_df = spark.createDataFrame(pandas_df)

# Display the result
spark_df.show()
```
