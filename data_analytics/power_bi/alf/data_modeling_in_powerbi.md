# **[data modeling in power bi](https://www.youtube.com/watch?v=eMszXHHhAfE&list=PLtCzYvIWNgJE-NsGuUXbjYyJgQMSOFp3A&index=2)**

**[Getting Started with Power BI - playlist](https://www.youtube.com/watch?v=8oK2CJJ3fDg&list=PLtCzYvIWNgJE-NsGuUXbjYyJgQMSOFp3A)**

## Star Schema

Every semantic model will have a date.

## fact tables

Will be updated regularly based on our sales events.

- Quantitative data: total cost, number of pizza
- Frequent updates: items added to this file all the time.

## pizza fact table

- total cost
- number of pizza

## dimension tables

Gives context or meaning to the fact table

- what was sold
- when was it sold
- where was it sold
- how was it sold

## pizza dim table

### what was sold

- pizza id
- pizza size
- pizza category
- pizza ingrediants
- pizza name

### when was it sold

- order date optional order time

## transform data

- fix all errors such as date locals, data types, etc.

## categorize queries

- first create a new group called source
- put big table into source
- create another group called model
- leave the source as is but create a reference to the source.
data updated in our source file will automatically be updated in our reference file. A duplicate would create a separate copy of the data. Name the reference fact_pizza_sales.
- move the fact table down to the model group
- extract our pizza quantitative info from the fact table to the dimension table.
  - create another reference from the source, move it to the model group, and call it dim pizza.
  - remove columns not related to pizza or about info we are not interested in: order_id,quantity,order_date,order_time, unit_price, total_price. Now we have in this dimension table all the information related to pizza. Identify what column will uniquely identify the pizza, ie. pizza_id. This column will be used to create a relationship back to the pizza fact table.
  - last thing you have to do is remove the duplicates. We must have only 1 record per pizza to describe it.
  - Pizza dimension table is done.
- Go back to our fact table.
- delete all the pizza information in the fact table except the id to relate it to the pizza dimension table.
- so now the fact table contains only the information related to the sale of a pizza.
- create a relationship from the fact table to the dimension table.

## date dimension table

Create a blank Query and copy and past the m code to create a date table.

```m
let
    StartDate = #date(2020, 1, 1), // Define your start date here
    EndDate = #date(2023, 12, 31), // Define your end date here
    DateList = List.Dates(StartDate, Duration.Days(EndDate - StartDate) + 1, #duration(1, 0, 0, 0)),
    ConvertToDateTable = Table.FromList(DateList, Splitter.SplitByNothing(), {"Date"}, null, ExtraValues.Error),
    ChangeType = Table.TransformColumnTypes(ConvertToDateTable, {"Date", type date}),
    AddYear = Table.AddColumn(ChangeType, "Year", each Date.Year([Date]), Int64.Type),
    AddQuarter = Table.AddColumn(AddYear, "Quarter", each "Q" & Text.From(Date.QuarterOfYear([Date])), type text),
    AddMonthNumber = Table.AddColumn(AddQuarter, "Month Number", each Date.Month([Date]), Int64.Type),
    AddMonthName = Table.AddColumn(AddMonthNumber, "Month Name", each Date.MonthName([Date]), type text),
    AddMonthShortName = Table.AddColumn(AddMonthName, "Month Short Name", each Date.ToText([Date], "MMM"), type text),
    AddWeekOfYear = Table.AddColumn(AddMonthShortName, "Week Of Year", each Date.WeekOfYear([Date]), Int64.Type),
    AddDayOfMonth = Table.AddColumn(AddWeekOfYear, "Day Of Month", each Date.Day([Date]), Int64.Type),
    AddDayOfWeekName = Table.AddColumn(AddDayOfMonth, "Day Of Week Name", each Date.DayOfWeekName([Date]), type text),
    AddDayOfWeekNumber = Table.AddColumn(AddDayOfWeekName, "Day Of Week Number", each Date.DayOfWeek([Date]) + 1, Int64.Type) // +1 to make Monday=1, Sunday=7
in
    AddDayOfWeekNumber
```

## remove source table

- disable source table so that it will not load or be available in the Power BI canvas.

## go to model view

- close and apply
- click on model view
- create a one-to-many relationship from the dimension table to the fact table. many side is the fact table and the one side is always the dimension table. The cross filter dimension will be single

## Power BI semantic model

Contains both the star schema containing the fact and dimension tables and contains the DAX

- base model using the star schema
- and our DAX measures
