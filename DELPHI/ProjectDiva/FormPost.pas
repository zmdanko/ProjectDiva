unit FormPost;

interface

uses
  RESTClient, RESTForm, System.JSON, System.JSON.Builders, System.Messaging,
  System.Generics.Collections,
  System.SysUtils, System.Types,
  System.UITypes,
  System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo;

const
  POSITION_X_WIDTH_DIV = 8;
  POSITION_Y = 30;

type
  TSaveSuccessMessage = class
  public
    ParameterList: TJSONObject;
    Index: Integer;
    constructor Create();
  end;

  TPostForm = class(TRESTForm)
    Commit: TButton;
    procedure CommitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
//    function AdddingParameterList(): TRESTRequestParameterList;
    procedure HandlerResponse();
    procedure CreateForm(const KeysList: TList<String>;
      JSONValue: TJSONValue = nil);
    function AdddingParameterList: TJSONObject;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent; Path: string;
      JSONValue: TJSONValue = nil; Index: Integer = -1); overload;
  end;

var
  SaveSuccessMessage: TSaveSuccessMessage;
  RESTClientForm: TRESTClientForm;

implementation

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}
{$R *.LgXhdpiPh.fmx ANDROID}

/// / adding parameters to RESTRequestParameterList
// function TPostForm.AdddingParameterList(): TRESTRequestParameterList;
// var
// RESTRequestParameterList: TRESTRequestParameterList;
// ComponentEnumerator: TComponentEnumerator;
//
// begin
// RESTRequestParameterList := TRESTRequestParameterList.Create(self);
//
// // traverse the child components find those TEdit components
// ComponentEnumerator := self.GetEnumerator;
//
// while (ComponentEnumerator.MoveNext) do
// begin
// if (ComponentEnumerator.GetCurrent is TEdit) then
// begin
// RESTRequestParameterList.AddItem(ComponentEnumerator.GetCurrent.Name,
// TEdit(ComponentEnumerator.GetCurrent).Text);
//
// FormPost.SaveSuccessMessage.ParameterList.AddPair
// (ComponentEnumerator.GetCurrent.Name,
// TEdit(ComponentEnumerator.GetCurrent).Text);
// end;
// end;
//
// result := RESTRequestParameterList;
// end;

// adding parameters to RESTRequestParameterList
function TPostForm.AdddingParameterList(): TJSONObject;
var
  JSONObject: TJSONObject;
  ComponentEnumerator: TComponentEnumerator;

begin
  JSONObject := TJSONObject.Create();

  // traverse the child components find those TEdit components
  ComponentEnumerator := self.GetEnumerator;

  while (ComponentEnumerator.MoveNext) do
  begin
    if (ComponentEnumerator.GetCurrent is TEdit) then
    begin
      JSONObject.AddPair(ComponentEnumerator.GetCurrent.Name,
        TEdit(ComponentEnumerator.GetCurrent).Text);

      FormPost.SaveSuccessMessage.ParameterList.AddPair
        (ComponentEnumerator.GetCurrent.Name,
        TEdit(ComponentEnumerator.GetCurrent).Text);
    end;
  end;

  result := JSONObject;
end;

procedure TPostForm.HandlerResponse();
begin
  if (RESTClientForm.RESTResponse1.StatusCode <> 201) then
  begin
    ShowMessage(RESTClientForm.RESTResponse1.Content);
    Exit;
  end;

  if (FormPost.SaveSuccessMessage.Index = -1) then
  begin
    FormPost.SaveSuccessMessage.ParameterList.RemovePair
      (FormPost.RESTClientForm.PRESTProperty.PrimaryKey);
    FormPost.SaveSuccessMessage.ParameterList.AddPair
      (FormPost.RESTClientForm.PRESTProperty.PrimaryKey, FormPost.RESTClientForm.RESTResponse1.Content);
  end
  else
  begin
    ShowMessage(FormPost.RESTClientForm.RESTResponse1.Content);
  end;

  TMessageManager.DefaultManager.SendMessage(self,
    TMessage<TSaveSuccessMessage>.Create(FormPost.SaveSuccessMessage), True);
end;

procedure TPostForm.CommitClick(Sender: TObject);
begin
  RESTClientForm.RESTRequest1.Method := rmPOST;

  // add RequestParameterList and execute request
  RESTClientForm.RESTRequest1.AddBody(AdddingParameterList());

  RESTClientForm.RESTRequest1.Execute;

  HandlerResponse();

  self.Close();
end;

procedure TPostForm.CreateForm(const KeysList: TList<String>;
  JSONValue: TJSONValue = nil);
var
  I: Integer;
  newLabel: TLabel;
  newEdit: TEdit;
begin
  for I := 0 to KeysList.Count - 1 do
  begin
    // the id filed create in the server

    newLabel := TLabel.Create(self);
    newLabel.Text := KeysList[I];
    newLabel.Position := TPosition.Create
      (TPointF.Create(self.Width div POSITION_X_WIDTH_DIV, POSITION_Y * I));

    newEdit := TEdit.Create(self);
    newEdit.Name := KeysList[I];
    newEdit.Width := self.Width div POSITION_X_WIDTH_DIV * 5;
    newEdit.Position := TPosition.Create
      (TPointF.Create(self.Width div POSITION_X_WIDTH_DIV * 2, POSITION_Y * I));
    if (JSONValue <> nil) then
    begin
      newEdit.Text := JSONValue.GetValue<string>(KeysList[I]);
    end;

    self.AddObject(newLabel);
    self.AddObject(newEdit);

    if (KeysList[I] = RESTClientForm.PRESTProperty.PrimaryKey) then
    begin
      newLabel.Visible := false;
      newEdit.Visible := false;
    end;
  end;
  self.Commit.Position := TPosition.Create
    (TPointF.Create(self.Width div POSITION_X_WIDTH_DIV * 2, POSITION_Y * I));
end;

procedure TPostForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  (self.Owner as TRESTClientForm).StringGrid1.Enabled := True;
  Action := TCloseAction.caFree;
end;

// traverse the form fileds and show it in the form
constructor TPostForm.Create(AOwner: TComponent; Path: string;
  JSONValue: TJSONValue = nil; Index: Integer = -1);

begin
  inherited Create(AOwner);

  FormPost.RESTClientForm := (AOwner as TRESTClientForm);

  // can not action RESTForm on PostForm is opening
  FormPost.RESTClientForm.StringGrid1.Enabled := false;

  CreateForm(FormPost.RESTClientForm.PKeysList, JSONValue);

  // create SaveSuccessMessage
  FormPost.SaveSuccessMessage := TSaveSuccessMessage.Create();
  FormPost.SaveSuccessMessage.Index := Index;
end;

{ TSaveSuccessMessage }

constructor TSaveSuccessMessage.Create();
begin
  self.ParameterList := TJSONObject.Create();
end;

end.
