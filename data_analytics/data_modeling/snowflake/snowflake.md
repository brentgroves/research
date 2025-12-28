# **[Snowflake Schema in Data Warehouse Model](https://www.geeksforgeeks.org/dbms/snowflake-schema-in-data-warehouse-model/)**

A snowflake schema is a type of data model where the fact table links to normalized dimension tables split into multiple related tables. It’s a more detailed version of the star schema and is used to handle complex data structures. The snowflake effect applies only to dimension tables, not the fact table.

![i1](https://media.geeksforgeeks.org/wp-content/uploads/20250212185011691000/Snowflake-Schema.webp)

- The dimension tables are normalized into multiple related tables, creating a hierarchical or "snowflake" structure.
- The fact table is still located at the center of the schema, surrounded by the dimension tables. However, each dimension table is further broken down into multiple related tables, creating a hierarchical structure that resembles a snowflake.

## Example of Snowflake Schema

The Employee dimension includes attributes like EmployeeID, Name, DepartmentID, Region, and Territory. DepartmentID links to the Department table, which holds department details like Name and Location.

The Customer dimension includes CustomerID, Name, Address, and CityID. CityID links to the City table, which stores City Name, Zipcode, State, and Country.

## What is Snowflaking

A snowflake design occurs when a dimension table is further normalized by splitting low-cardinality attributes into separate related tables. These are linked using foreign keys.

However, snowflaking is usually not recommended because it makes the model harder to understand and can slow down queries due to more table joins.

## Difference Between Snowflake and Star Schema

The star schema uses denormalized dimensions for faster queries, while the snowflake schema normalizes dimensions to reduce redundancy and save space. However, snowflake schemas require more joins, making them slower and more complex. The choice depends on the balance between performance, maintenance, and data integrity.

Read more about **[Difference Between Snowflake and Star Schema](https://www.geeksforgeeks.org/dbms/difference-between-star-schema-and-snowflake-schema/)**

## Characteristics of Snowflake Schema

- The snowflake schema uses small disk space.
- It is easy to implement the dimension that is added to the schema.
- There are multiple tables, so performance is reduced.
- The dimension table consists of two or more sets of attributes that define information at different grains.
- The sets of attributes of the same dimension table are populated by different source systems.
