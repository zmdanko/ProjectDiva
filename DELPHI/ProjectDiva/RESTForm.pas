unit RESTForm;

interface

uses FMX.Dialogs, System.SysUtils, REST.Client, FMX.Forms, System.Classes;

const
  LOCAL_BASE_URL = '192.168.58.167/service/';
  // LOCAL_BASE_URL = 'http://127.0.0.1:10001/';
  // BASE_URL = 'http://192.168.58.1:10001/';

type
  TRESTForm = class(TForm)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
  public
    constructor Create(AOwner: TComponent; const Path: String); overload;
    procedure SetBaseURL(Path: string);
  end;

implementation

constructor TRESTForm.Create(AOwner: TComponent; const Path: String);
begin
  inherited Create(AOwner);

  self.RESTClient1 := TRESTClient.Create(self);
  self.RESTRequest1 := TRESTRequest.Create(self);
  self.RESTResponse1 := TRESTResponse.Create(self);

  self.SetBaseURL(Path);

  self.RESTRequest1.Client := self.RESTClient1;
  self.RESTRequest1.Response := self.RESTResponse1;
end;

procedure TRESTForm.SetBaseURL(Path: string);

begin
  self.RESTClient1.BaseURL := LOCAL_BASE_URL + Path;
  // {$IFDEF ANDROID}
  // self.RESTClient1.BaseURL := BASE_URL + Path;
  // {$ENDIF}
end;

end.
