let
  workspaceIdParam = "",
  lakehouseIdParam = "",
  
  CSVConvertToTable = (workspaceIdParam,lakehouseIdParam) =>
let
  // CSVの定義
  readCsvfiles = (x) => let
    result = Table.TransformColumnTypes(Table.PromoteHeaders(Csv.Document(x, [Delimiter = ",", Columns = 11, Encoding = 65001, QuoteStyle = QuoteStyle.None]),[PromoteAllScalars = true]),  {{"商品コード", Int64.Type}, {"フリガナ", type text}, {"商品名", type text}, {"仕入先コード", Int64.Type}, {"区分コード", Int64.Type},{"梱包単位", type text},{"単価", Decimal.Type}, {"在庫", Int64.Type},{"発注済", Int64.Type},{"発注点", Int64.Type},{"生産中止", Int64.Type}},"ja")
  in
    result,
  Source = Lakehouse.Contents(null){[workspaceId = workspaceIdParam]}[Data]{[lakehouseId = lakehouseIdParam]}[Data],
  filter = Source{[Id = "Files", ItemKind = "Folder"]}[Data],
  csvFilter = filter{[Name = "csv"]}[Content],
  onlyOrderDetails = csvFilter{[Name = "商品"]}[Content],
  tableCombine = Table.Combine(List.Transform(onlyOrderDetails[Content], readCsvfiles))
in
  tableCombine
in 
  CSVConvertToTable