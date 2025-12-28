# **[Data Modeling Tutorial: Star Schema (aka Kimball Approach)](https://www.youtube.com/watch?v=gRE3E7VUzRU)**

- **[kimball group](https://kimballgroup.com)**

Identify a fact
Determine dimensions attributes around the fact

need a snowflake account

order table or another option is order transaction table. you can aggregate transactions upto orders. you have a lower granularity so more flexibility.

## get data

- from raw source such as data lake or warehouse
- use sql to get this data

## step 1 determine fact table

## order fact table in warehouse

```yaml
id:
product_id:
quantity:
userid:
customerid:
datetime:
```

## order transaction table in warehouse

alot more information here

```yaml
amount:
cost per:
date:
order id:
product_id:
quantity:
tax:
total charged:
```

## create a fact table for transactions

## warehouse

- fact tables
  - keys, foriegn keys to dimensions
  - aggregate and numeric information
  - no descriptions or attributes
- dimension tables
  - descriptions or attributes
  - joined using the keys to the dimensions

## marts

- user facing tables to use

## step 2 determine dimensions

- add context to that fact such as descriptions and attributes
- dates, text based values, could be numeric descriptive value such as price
- can have a slowly changing dimension such as office location of an employee
