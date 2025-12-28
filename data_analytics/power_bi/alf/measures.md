# **[04-Module Topic 2-Introduction to Measures and Calculated Columns(PowerBI file included)](https://www.youtube.com/watch?v=8oK2CJJ3fDg)**

**[playlist](https://www.youtube.com/watch?v=8oK2CJJ3fDg&list=PLtCzYvIWNgJE-NsGuUXbjYyJgQMSOFp3A)**

![i1](https://res.cloudinary.com/dwwq4fbhq/image/upload/v1761677540/powerbi_workflow_qpbrid.jpg)

## measures

dynamic calculations
sales report: total sales, average sales, total quantity sold

## Calculated Columns

- add new columns to your existing table

## Data Analysis Expression (DAX)

create measures and calculated columns using Data Analysis Expression (dax)

## Measures to create

create new measure from fact table.

- total number of orders
  - distinctcount(orderid)
- total number of pizzas sold

Pizza Category = SWITCH(TRUE(),CONTAINSSTRING(dim_pizza[pizza_name_id],"pepperoni"),"Single Cheese",CONTAINSSTRING(dim_pizza[pizza_name_id],"cheese"),"Cheese","Multi-Cheese Specials","Other")

Pizza Category = SWITCH(TRUE(),CONTAINSSTRING(dim_pizza[pizza_name_id],"pepperoni"),"Single Cheese","Other")

Pizza Category = SWITCH(TRUE(),CONTAINSSTRING(dim_pizza[pizza_name_id],"pepperoni"),"Single Cheese",CONTAINSSTRING(dim_pizza[pizza_name_id],"cheese"),"Cheese","Other")
