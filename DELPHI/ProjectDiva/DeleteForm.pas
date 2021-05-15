unit DeleteForm;

interface

uses
  REST.Types,System.Messaging, REST.Client, RESTForm, System.SysUtils, System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TDeleteSuccessMessage = record
    Index: Integer;
  end;

  TDeleteForm = class(TRESTForm)
    NoBtn: TButton;
    YesBtn: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure NoBtnClick(Sender: TObject);
    procedure YesBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function AdddingParameterList(PrimaryKey, PrimaryKeyValue: string)
      : TRESTRequestParameterList;
    procedure HandlerResponse;
    procedure SendMessage;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent;
      Path, PrimaryKey, PrimaryKeyValue: string; Index: Integer); overload;
  end;

var
  DeleteSuccessMessage: TDeleteSuccessMessage;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses RESTClient;

constructor TDeleteForm.Create(AOwner: TComponent;
  Path, PrimaryKey, PrimaryKeyValue: string; Index: Integer);
begin
  (AOwner as TRESTClientForm).StringGrid1.Enabled := false;

  inherited Create(AOwner, Path);

  DeleteForm.DeleteSuccessMessage.Index := Index;

  self.Label1.Text := 'Sure delete ' + PrimaryKeyValue;

  self.RESTRequest1.Params := AdddingParameterList(PrimaryKey, PrimaryKeyValue);
end;

// adding parameters to RESTRequestParameterList
function TDeleteForm.AdddingParameterList(PrimaryKey, PrimaryKeyValue: string)
  : TRESTRequestParameterList;
var
  RESTRequestParameterList: TRESTRequestParameterList;
begin
  RESTRequestParameterList := TRESTRequestParameterList.Create(self);
  RESTRequestParameterList.AddItem(PrimaryKey, PrimaryKeyValue);
  result := RESTRequestParameterList;
end;

procedure TDeleteForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  (self.Owner as TRESTClientForm).StringGrid1.Enabled := True;
  Action := TCloseAction.caFree;
end;

procedure TDeleteForm.FormCreate(Sender: TObject);
begin
  self.Label1.Position := TPosition.Create(TPointF.Create(self.Width div 4,
    self.Height div 5));
  self.YesBtn.Position := TPosition.Create(TPointF.Create(self.Width div 4,
    self.Height div 5 * 3));
  self.NoBtn.Position := TPosition.Create(TPointF.Create(self.Width div 4 * 2,
    self.Height div 5 * 3));
end;

procedure TDeleteForm.NoBtnClick(Sender: TObject);
begin
  self.Close();
end;

procedure TDeleteForm.SendMessage();
begin
  TMessageManager.DefaultManager.SendMessage(self,
    TMessage<TDeleteSuccessMessage>.Create(DeleteSuccessMessage), True);
end;

procedure TDeleteForm.HandlerResponse();
begin
  ShowMessage(RESTResponse1.Content);
  if (RESTResponse1.StatusCode <> 201) then
  begin
    Exit;
  end;

  SendMessage();

  self.Close();
end;

procedure TDeleteForm.YesBtnClick(Sender: TObject);
begin
  self.RESTRequest1.Method := rmPOST;

  self.RESTRequest1.Execute();

  HandlerResponse();

end;

end.
