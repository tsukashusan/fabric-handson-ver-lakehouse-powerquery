
let
  workspaceIdParam = "",
  lakehouseIdParam = "",

  CSVConvertToTable = (workspaceIdParam,lakehouseIdParam) =>
let
  // CSVの定義
  readCsvfiles = (x) => let
    result = Table.TransformColumnTypes(Table.PromoteHeaders(Csv.Document(x, [Delimiter = ",", Columns = 5, Encoding = 65001, QuoteStyle = QuoteStyle.None]),[PromoteAllScalars = true]),  {{"トドウフケン", type text}, {"都道府県", type text}, {"ローマ字", type text}, {"地域名ローマ字", type text}, {"地域", type text}}, "ja")
  in
    result,
  Source = Lakehouse.Contents(null){[workspaceId = workspaceIdParam]}[Data]{[lakehouseId = lakehouseIdParam]}[Data],
  filter = Source{[Id = "Files", ItemKind = "Folder"]}[Data],
  csvFilter = filter{[Name = "csv"]}[Content],
  onlyOrderDetails = csvFilter{[Name = "都道府県"]}[Content],
  tableCombine = Table.Combine(List.Transform(onlyOrderDetails[Content], readCsvfiles))
in
  tableCombine
in 
  CSVConvertToTable