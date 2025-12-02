
let
  workspaceIdParam = "",
  lakehouseIdParam = "",

  CSVConvertToTable = (workspaceIdParam,lakehouseIdParam) =>
let
  // CSVの定義
  readCsvfiles = (x) => let
    result = Table.TransformColumnTypes(Table.PromoteHeaders(Csv.Document(x, [Delimiter = ",", Columns = 5, Encoding = 65001, QuoteStyle = QuoteStyle.None]),[PromoteAllScalars = true]),  {{"受注コード", Int64.Type}, {"商品コード", Int64.Type}, {"単価", Decimal.Type}, {"数量", Int64.Type}, {"割引", Decimal.Type}}, "ja")
  in
    result,
  // Source = Lakehouse.Contents(null){[workspaceId = Variable.ValueOrDefault("$(/**/hanbailibrary/workspaceid)", "111")]}[Data]{[lakehouseId = Variable.ValueOrDefault("$(/**/hanbailibrary/lakehouseid)","000")]}[Data],
  Source = Lakehouse.Contents(null){[workspaceId = workspaceIdParam]}[Data]{[lakehouseId = lakehouseIdParam]}[Data],
  filter = Source{[Id = "Files", ItemKind = "Folder"]}[Data],
  csvFilter = filter{[Name = "csv"]}[Content],
  onlyOrderDetails = csvFilter{[Name = "受注明細"]}[Content],
  tableCombine = Table.Combine(List.Transform(onlyOrderDetails[Content], readCsvfiles))
in
  tableCombine
in 
  CSVConvertToTable


