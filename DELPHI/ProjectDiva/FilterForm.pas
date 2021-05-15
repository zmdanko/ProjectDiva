unit FilterForm;

interface

uses
  System.Messaging, System.Generics.Collections, System.JSON, RESTClient,
  System.SysUtils,
  System.Types, System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListBox,
  FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls;

const
  POSITION_X_WIDTH_DIV = 8;
  POSITION_Y = 30;

type
  TFilterMessage = record
    ButtonName: String;
    ButtonText: String;
  end;

  TFilterForm = class(TForm)
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Commit: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CommitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure CreateForm;
    procedure SettingComboBox;
    procedure AddingFilterButton(FilterKey: string);
    procedure AddingFilter(FilterKey: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RESTClientForm: TRESTClientForm;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TFilterForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RESTClientForm.StringGrid1.Enabled := True;
  Action := TCloseAction.caFree;
end;

procedure TFilterForm.FormCreate(Sender: TObject);
begin
  CreateForm();
  SettingComboBox();
end;

procedure TFilterForm.CommitClick(Sender: TObject);
var
  FilterKey: string;
begin
  FilterKey := 'b' + TimeToStr(Now).Replace(':', '');

  AddingFilter(FilterKey);

  AddingFilterButton(FilterKey);

  self.Close();
end;

procedure TFilterForm.AddingFilter(FilterKey: string);
var
  JSONValue: TJSONValue;
  IDList: TList<String>;
begin
  IDList := TList<String>.Create();
  for JSONValue in RESTClientForm.PItemsList do
  begin
    if (JSONValue.GetValue<String>(self.ComboBox1.Selected.Text)
      .Contains(self.Edit1.Text)) then
    begin
      IDList.Add(JSONValue.GetValue<String>
        (RESTClientForm.PRESTProperty.PrimaryKey));
    end;
  end;
  RESTClientForm.Filters.Add(FilterKey, IDList);

end;

procedure TFilterForm.AddingFilterButton(FilterKey: string);
var
  FilterMessage: TFilterMessage;
begin
  FilterMessage.ButtonName := FilterKey;
  FilterMessage.ButtonText := self.ComboBox1.Selected.Text + ':' +
    self.Edit1.Text;

  TMessageManager.DefaultManager.SendMessage(self,
    TMessage<TFilterMessage>.Create(FilterMessage), True);
end;

procedure TFilterForm.CreateForm();
begin
  FilterForm.RESTClientForm := (self.Owner as TRESTClientForm);

  FilterForm.RESTClientForm.StringGrid1.Enabled := False;

  self.ComboBox1.Position := TPosition.Create
    (TPointF.Create(self.Width div POSITION_X_WIDTH_DIV, POSITION_Y));
  self.Edit1.Width := self.Width div POSITION_X_WIDTH_DIV * 5;
  self.Edit1.Position := TPosition.Create
    (TPointF.Create(self.Width div POSITION_X_WIDTH_DIV * 2.5, POSITION_Y));
  self.Commit.Position := TPosition.Create
    (TPointF.Create(self.Width div POSITION_X_WIDTH_DIV * 2.5, POSITION_Y * 2));
end;

procedure TFilterForm.SettingComboBox();
var
  Key: string;
  ListBoxItem: TListBoxItem;
begin
  for Key in (self.Owner as TRESTClientForm).PKeysList do
  begin
    ListBoxItem := TListBoxItem.Create(self.ComboBox1);
    ListBoxItem.Text := Key;
    self.ComboBox1.AddObject(ListBoxItem);
    self.ComboBox1.ItemIndex := 0;
  end;
end;

end.
