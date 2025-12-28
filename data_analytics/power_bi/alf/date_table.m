let
    StartDate = #date(2020, 1, 1),
    // Define your start date here
    EndDate = #date(2023, 12, 31),
    // Define your end date here
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
    AddDayOfWeekNumber = Table.AddColumn(
        AddDayOfWeekName, "Day Of Week Number", each Date.DayOfWeek([Date]) + 1, Int64.Type
    )
    // +1 to make Monday=1, Sunday=7
in
    AddDayOfWeekNumber
