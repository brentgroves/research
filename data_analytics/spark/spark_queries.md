# **[How to optimize Nested Queries using Apache Spark](<https://www.sigmoid.com/blogs/optimize-nested-queries-using-apache-spark/>)**

Spark has a great query optimization capability that can significantly improve the execution time of queries and ensure cost reduction. However, when it comes to nested queries, there is a need to further advanced spark optimization techniques. Nested queries typically include multiple dimensions and metrics such as “OR” and “AND” operations along with millions of values that need to be filtered out.

 For instance, when Spark is executed with a query of, say 100 filters, with nested operations between them, the execution process slows down. Since there are multiple dimensions involved, it takes a huge amount of time for the optimization process. Depending upon the cluster size, it may take hours to process Apache Spark DataFrames with those filters.
