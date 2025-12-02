
let
  workspaceIdParam = "",
  lakehouseIdParam = "",
  
  CSVConvertToTable = (workspaceIdParam,lakehouseIdParam) =>
let
  // CSVの定義
  readCsvfiles = (x) => let
    result = Table.TransformColumnTypes(Table.PromoteHeaders(Csv.Document(x, [Delimiter = ",", Columns = 3, Encoding = 65001, QuoteStyle = QuoteStyle.None]),[PromoteAllScalars = true]),  {{"運送コード", Int64.Type}, {"運送会社", type text}, {"電話番号", type text}}, "ja")
  in
    result,
  Source = Lakehouse.Contents(null){[workspaceId = workspaceIdParam]}[Data]{[lakehouseId = lakehouseIdParam]}[Data],
  filter = Source{[Id = "Files", ItemKind = "Folder"]}[Data],
  csvFilter = filter{[Name = "csv"]}[Content],
  onlyOrderDetails = csvFilter{[Name = "運送会社"]}[Content],
  tableCombine = Table.Combine(List.Transform(onlyOrderDetails[Content], readCsvfiles))
in
  tableCombine
in 
  CSVConvertToTable