let
    CSVConvertToTable = (workspaceId,lakehouseId) =>
let
  // CSVの定義
  readCsvfiles = (x) => let
    result = Table.TransformColumnTypes(Table.PromoteHeaders(Csv.Document(x, [Delimiter = ",", Columns = 13, Encoding = 65001, QuoteStyle = QuoteStyle.None]),[PromoteAllScalars = true]),  {{"受注コード", Int64.Type}, {"得意先コード", Int64.Type}, {"社員コード", Int64.Type}, {"出荷先名", type text}, {"出荷先郵便番号", Int64.Type}, {"出荷先都道府県", type text}, {"出荷先住所1", type text}, {"出荷先住所2", type text}, {"運送区分", Int64.Type}, {"受注日", type datetime}, {"締切日", type datetime}, {"出荷日", type datetime}, {"運送料", Int64.Type}}, "ja")
  in
    result,
  Source = Lakehouse.Contents(null){[workspaceId = workspaceId]}[Data]{[lakehouseId = workspaceId]}[Data],
  filter = Source{[Id = "Files", ItemKind = "Folder"]}[Data],
  csvFilter = filter{[Name = "csv"]}[Content],
  onlyOrderDetails = csvFilter{[Name = "受注"]}[Content],
  tableCombine = Table.Combine(List.Transform(onlyOrderDetails[Content], readCsvfiles))
in
  tableCombine
in 
  CSVConvertToTable