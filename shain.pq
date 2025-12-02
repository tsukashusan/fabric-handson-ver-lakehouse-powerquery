
let
  workspaceIdParam = "",
  lakehouseIdParam = "",
  
  CSVConvertToTable = (workspaceIdParam,lakehouseIdParam) =>
let
  // CSVの定義
  readCsvfiles = (x) => let
    result = Table.TransformColumnTypes(Table.PromoteHeaders(Csv.Document(x, [Delimiter = ",", Columns = 15, Encoding = 65001, QuoteStyle = QuoteStyle.None]),[PromoteAllScalars = true]),  {{"社員コード", Int64.Type}, {"フリガナ", type text}, {"氏名", type text}, {"在籍支社", type text}, {"部署名", type text},{"誕生日", type datetime},{"内線", Int64.Type}, {"写真", type text},{"プロフィール", type text},{"入社日", type datetime},{"自宅郵便番号", Int64.Type},{"自宅都道府県", type text},{"自宅住所1", type text},{"自宅住所2", type text},{"自宅電話番号", type text}},"ja")
  in
    result,
  Source = Lakehouse.Contents(null){[workspaceId = workspaceIdParam]}[Data]{[lakehouseId = lakehouseIdParam]}[Data],
  filter = Source{[Id = "Files", ItemKind = "Folder"]}[Data],
  csvFilter = filter{[Name = "csv"]}[Content],
  onlyOrderDetails = csvFilter{[Name = "社員"]}[Content],
  tableCombine = Table.Combine(List.Transform(onlyOrderDetails[Content], readCsvfiles))
in
  tableCombine
in 
  CSVConvertToTable