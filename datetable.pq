let
    CreateDateTable = (StartDate,EndDate) =>
let
    StartDate=#date(2021,01,01),
    EndDate=#date(2023,12,31),
    //Create lists of month and day names for use later on
    //Find the number of days between the end date and the start date
    NumberOfDates = (Duration.Days(EndDate-StartDate)+ 1),
    //StartDatetime = DateTime.From(StartDate),
    //Generate a continuous list of dates from the start date to the end date
    //DateList = List.DateTimes(StartDatetime, NumberOfDates, #duration(1, 0, 0, 0)),
    DateList = List.Dates(StartDate, NumberOfDates, #duration(1, 0, 0, 0)),
    //Turn this list into a table
    //ableFromList = Table.FromList(DateList, Splitter.SplitByNothing(), {"Datetime"}, null, ExtraValues.Error),
    TableFromList = Table.TransformColumnTypes(Table.FromList(DateList, Splitter.SplitByNothing(), {"Date"}, null, ExtraValues.Error),{"Date", type date}),
    //Caste the single column in the table to type date
    //ChangedType = Table.TransformColumnTypes(TableFromList,{{"Datetime", type datetime}}),
    //TimeKey = Table.AddColumn(ChangedType, "TimeKey", each Number.FromText(DateTime.ToText([Datetime],  [Format="yyyyMMddHHmmss", Culture="ja-JP"])),  type number),
    TimeKey = Table.AddColumn(TableFromList, "TimeKey", each Int64.From(Date.ToText([Date], [Format="yyyyMMdd", Culture="ja-JP"])), Int64.Type),
	Quarter = Table.AddColumn(TimeKey, "Quarter", each Int64.From(Date.QuarterOfYear([Date])), Int64.Type),
    Month = Table.AddColumn(Quarter, "Month", each Int64.From(Date.Month([Date])), Int64.Type),
    Year = Table.AddColumn(Month, "Year", each Int64.From(Date.Year([Date])), Int64.Type)
    //Date = Table.AddColumn(TimeKey, "Date", each Date.Date([D]),  type date)
	//Time = Table.AddColumn(Date, "Time", each DateTime.Time([Datetime]),  type time),
    //Add a column that returns true if the date on rows is the current date
    //IsToday = Table.AddColumn(Time, "IsToday", each Date.IsInCurrentDay([Datetime]))

in
    Year
in
    CreateDateTable