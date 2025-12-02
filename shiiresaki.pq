let
  workspaceIdParam = "",
  lakehouseIdParam = "",
  
  CSVConvertToTable = (workspaceIdParam,lakehouseIdParam) =>
let
  // CSVの定義
  readCsvfiles = (x) => let
    result = Table.TransformColumnTypes(Table.PromoteHeaders(Csv.Document(x, [Delimiter = ",", Columns = 13, Encoding = 65001, QuoteStyle = QuoteStyle.None]),[PromoteAllScalars = true]),  {{"仕入先コード", Int64.Type}, {"フリガナ", type text}, {"仕入先名", type text}, {"担当者名", type text}, {"部署", type text},{"郵便番号", Int64.Type},{"ホームページ", type text}, {"トドウフケン", type text},{"都道府県", type text},{"住所1", type text},{"住所2", type text},{"電話番号", type text},{"ファクシミリ", type text}},"ja")
  in
    result,
  Source = Lakehouse.Contents(null){[workspaceId = workspaceIdParam]}[Data]{[lakehouseId = lakehouseIdParam]}[Data],
  filter = Source{[Id = "Files", ItemKind = "Folder"]}[Data],
  csvFilter = filter{[Name = "csv"]}[Content],
  onlyOrderDetails = csvFilter{[Name = "仕入先"]}[Content],
  tableCombine = Table.Combine(List.Transform(onlyOrderDetails[Content], readCsvfiles))
in
  tableCombine
in 
  CSVConvertToTable