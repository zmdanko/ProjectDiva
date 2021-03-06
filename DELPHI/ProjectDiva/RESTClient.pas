unit RESTClient;

interface

uses
  RESTForm, FMX.Platform, System.Messaging,
  System.Generics.Defaults, FMX.ActnList,
  System.Generics.Collections,
  System.JSON, System.SysUtils,
  System.Types,
  System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, REST.Types,
  System.Rtti, FMX.Grid.Style, FMX.Bind.Grid, System.Bindings.Outputs,
  FMX.Bind.Editors, Data.Bind.EngExt, FMX.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.Grid, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid,
  REST.Response.Adapter, REST.Client, Data.Bind.ObjectScope, FMX.Menus,
  System.Actions, FMX.StdCtrls, Data.DB;

type
  TRESTProperty = record
    PrimaryKey, SelectAllPath, CreatePath, UpdatePath, DeletePath: String;
  end;

  TRESTClientForm = class(TRESTForm)
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    AddBtn: TButton;
    UpdateBtn: TButton;
    RemoveBtn: TButton;
    ExportBtn: TButton;
    BtnAddFilter: TButton;
    FiltersBar: TToolBar;
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1HeaderClick(Column: TColumn);
    procedure AddBtnClick(Sender: TObject);
    procedure UpdateBtnClick(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAddFilterClick(Sender: TObject);
  private
    FilteredData: TList<String>;
    RESTProperty: TRESTProperty;
    ItemsList: TList<TJSONValue>;
    // To traverse the data
    KeysList: TList<String>;
    // To sort,<column,[1 ascend|-1 descend]>
    KeysDictionary: TDictionary<String, Integer>;
    procedure GetAllKeys(JSONValue: TJSONValue);
    procedure CreateColumn();
    procedure TraverseData();
    procedure SaveItems(JSONArray: TJSONArray);
    procedure HandleSaveSuccessMessage(const Sender: TObject;
      const M: TMessage);
    procedure HandleDeleteSuccessMessage(const Sender: TObject;
      const M: TMessage);
    procedure HandleFilterMessage(const Sender: TObject; const M: TMessage);
    procedure FilterButtonClick(Sender: TObject);
    procedure HandleFilter();

  public
    Filters: TDictionary<String, TList<String>>;
    constructor Create(AOwner: TComponent;
      const RESTProperty: TRESTProperty); overload;
    property PKeysList: TList<String> read KeysList;
    property PRESTProperty: TRESTProperty read RESTProperty;
    property PItemsList: TList<TJSONValue> read ItemsList;
  end;

implementation

uses FormPost, DeleteForm, FilterForm;

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}
{$R *.LgXhdpiPh.fmx ANDROID}

// parse JSONString
function ParseJSON(JSONString: String): TJSONValue;
begin
  result := TJSONObject.ParseJSONValue(JSONString);
end;

// parse keys,save in the KeysList and the KeysDictionary
procedure TRESTClientForm.GetAllKeys(JSONValue: TJSONValue);
var
  I: Integer;
  JSONString: TJSONString;
  key: String;
begin
  self.KeysList := TList<String>.Create;
  self.KeysDictionary := TDictionary<String, Integer>.Create;
  for I := 0 to TJSONObject(JSONValue).Count - 1 do
  begin
    // get key in every pair
    JSONString := TJSONObject(JSONValue).Pairs[I].JSONString;
    // dispose of ""
    key := JSONString.ToString.Replace('"', '');
    KeysList.Add(key);
    KeysDictionary.Add(key, 1);
  end;
end;

// change the sort order when click the label of column
procedure TRESTClientForm.StringGrid1HeaderClick(Column: TColumn);
begin
  begin
    ItemsList.Sort(TComparer<TJSONValue>.Construct(
      function(const Left, Right: TJSONValue): Integer
      begin
        result := TComparer<String>.
          Default.Compare(Left.GetValue<String>(Column.Header),
          Right.GetValue<String>(Column.Header)) *
          (KeysDictionary.Items[Column.Header]);
      end));
    KeysDictionary.Items[Column.Header] := -KeysDictionary.Items[Column.Header];
  end;

  TraverseData();
end;

// show a form when the Add Button been click
procedure TRESTClientForm.AddBtnClick(Sender: TObject);
begin
  self.SetBaseURL(self.RESTProperty.CreatePath);
  TPostForm.Create(self, self.RESTProperty.CreatePath).Show;
end;

procedure TRESTClientForm.BtnAddFilterClick(Sender: TObject);
begin
  TFilterForm.Create(self).Show;
end;

constructor TRESTClientForm.Create(AOwner: TComponent;
const RESTProperty: TRESTProperty);
begin
  self.RESTProperty := RESTProperty;
  inherited Create(AOwner, RESTProperty.SelectAllPath);
end;

// adding column's label according to the KeysList
procedure TRESTClientForm.CreateColumn();
var
  I: Integer;
  newColumn: TStringColumn;
begin
  for I := 0 to KeysList.Count - 1 do
  begin
    newColumn := TStringColumn.Create(self);
    newColumn.Header := KeysList[I];
    StringGrid1.AddObject(newColumn);
  end;
end;

procedure TRESTClientForm.HandleFilter();
var
  Temp: TList<String>;
  FilterValues: TArray<TList<String>>;
  I: Integer;
begin
  if (Filters.Count <> 0) then
  begin
    FilteredData := TList<String>.Create();
    Temp := TList<String>.Create();
    FilterValues := Filters.Values.ToArray;

    //setting base filter
    for var PrimaryKey in FilterValues[0] do
    begin
      FilteredData.Add(PrimaryKey);
    end;

    // filter data through all the filters
    I := 1;
    while (I < Filters.Count) do
    begin
      Temp.Clear();
      for var PrimaryKey in FilteredData do
      begin
        if (FilterValues[I].Contains(PrimaryKey)) then
        begin
          Temp.Add(PrimaryKey);
        end;
      end;

      //store the filtered data in the FilteredData filed
      FilteredData.Clear();
      for var PrimaryKey in Temp do
      begin
        FilteredData.Add(PrimaryKey);
      end;

      Inc(I);
    end;
  end;
end;

// traverse data
procedure TRESTClientForm.TraverseData();
var
  I, J: Integer;
begin

  HandleFilter();

  StringGrid1.RowCount := 0;

  I := 0;
  while (I < ItemsList.Count) do
  begin
    if (ItemsList[I].GetValue<String>(RESTProperty.PrimaryKey) = '0') then
    begin
      ItemsList.Delete(I);
      Continue;
    end;
    if ((Filters.Count = 0) or
      (FilteredData.Contains(ItemsList[I].GetValue<String>
      (RESTProperty.PrimaryKey)))) then
    begin
      StringGrid1.RowCount := StringGrid1.RowCount + 1;
      for J := 0 to KeysList.Count - 1 do
      begin
        StringGrid1.Cells[J, StringGrid1.RowCount - 1] :=
          self.ItemsList[I].GetValue<String>(KeysList[J]);
      end;
    end;

    Inc(I);
  end;

end;

procedure TRESTClientForm.UpdateBtnClick(Sender: TObject);
begin
  TPostForm.Create(self, self.RESTProperty.UpdatePath,
    self.ItemsList[StringGrid1.Selected], StringGrid1.Selected).Show;
end;

// save data in the ItemsList
procedure TRESTClientForm.SaveItems(JSONArray: TJSONArray);
var
  I: Integer;
begin
  self.ItemsList := TList<TJSONValue>.Create;
  for I := 0 to JSONArray.Count - 1 do
  begin
    self.ItemsList.Add(JSONArray.Items[I]);
  end;

end;

procedure TRESTClientForm.HandleDeleteSuccessMessage(const Sender: TObject;
const M: TMessage);
begin
  self.ItemsList.Delete((M as TMessage<TDeleteSuccessMessage>).Value.Index);

  TraverseData();
end;

procedure TRESTClientForm.HandleFilterMessage(const Sender: TObject;
const M: TMessage);
var
  FilterMessage: TFilterMessage;
  FilterButton: TButton;
begin

  FilterMessage := (M as TMessage<TFilterMessage>).Value;

  FilterButton := TButton.Create(self);
  FilterButton.Align := TAlignLayout.Left;
  FilterButton.name := FilterMessage.ButtonName;
  FilterButton.Text := FilterMessage.ButtonText;

  FilterButton.OnClick := FilterButtonClick;

  self.FiltersBar.AddObject(FilterButton);

  TraverseData();
end;

procedure TRESTClientForm.FilterButtonClick(Sender: TObject);
begin
  Filters.Remove((Sender as TButton).name);

  TraverseData();
  Sender.Free;
end;

procedure TRESTClientForm.HandleSaveSuccessMessage(const Sender: TObject;
const M: TMessage);
var
  SaveSuccessMessage: TSaveSuccessMessage;
begin
  SaveSuccessMessage := (M as TMessage<TSaveSuccessMessage>).Value;

  if (SaveSuccessMessage.Index = -1) then
  begin
    // adding new data
    self.StringGrid1.RowCount := self.ItemsList.Count + 1;
    self.StringGrid1.ScrollTo(0, self.StringGrid1.VScrollBar.Max);

    self.ItemsList.Add(SaveSuccessMessage.ParameterList);

    // creating new adding form
    self.AddBtnClick(self);
  end
  else
  begin
    self.ItemsList[SaveSuccessMessage.Index] :=
      SaveSuccessMessage.ParameterList;
  end;

  TraverseData();

end;

procedure TRESTClientForm.RemoveBtnClick(Sender: TObject);
begin
  TDeleteForm.Create(self, self.RESTProperty.DeletePath,
    self.RESTProperty.PrimaryKey, self.ItemsList[self.StringGrid1.Selected]
    .GetValue<string>(self.RESTProperty.PrimaryKey),
    self.StringGrid1.Selected).Show();
end;

procedure TRESTClientForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // unsubscribe messages
  TMessageManager.DefaultManager.Unsubscribe(TMessage<TSaveSuccessMessage>,
    HandleSaveSuccessMessage, true);
  TMessageManager.DefaultManager.Unsubscribe(TMessage<TDeleteSuccessMessage>,
    HandleDeleteSuccessMessage, true);
  TMessageManager.DefaultManager.Unsubscribe(TMessage<TFilterMessage>,
    HandleFilterMessage, true);

  Action := TCloseAction.caFree;
end;

procedure TRESTClientForm.FormCreate(Sender: TObject);
var
  JSONArray: TJSONArray;
begin
  // Fetch data and parse it as TJSONArray
  self.RESTRequest1.Execute;
  JSONArray := TJSONArray(ParseJSON(RESTResponse1.Content));

  if (JSONArray = nil) then
  begin
    ShowMessage('??????????');
    exit;
  end;

  SaveItems(JSONArray);

  GetAllKeys(JSONArray.Items[0]);

  CreateColumn();

  Filters := TDictionary < String, TList < String >>.Create();

  TraverseData();

  // binding the child form's messages
  TMessageManager.DefaultManager.SubscribeToMessage
    (TMessage<TSaveSuccessMessage>, HandleSaveSuccessMessage);
  TMessageManager.DefaultManager.SubscribeToMessage
    (TMessage<TDeleteSuccessMessage>, HandleDeleteSuccessMessage);
  TMessageManager.DefaultManager.SubscribeToMessage(TMessage<TFilterMessage>,
    HandleFilterMessage);
end;

end.
