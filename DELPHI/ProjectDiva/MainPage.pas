unit MainPage;

interface

uses
  RESTClient, System.SysUtils, System.Types, System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Menus, Editor, FMX.ImgList,
  System.Actions, FMX.ActnList, System.ImageList;

type
  TMainPageForm = class(TForm)
    BtnEditor: TButton;
    Icon: TImageList;
    BtnRESTClient: TButton;

    procedure BtnEditorClick(Sender: TObject);
    // procedure BLocalDbClick(Sender: TObject);
    procedure BtnRESTClientClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainPageForm: TMainPageForm;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TMainPageForm.BtnEditorClick(Sender: TObject);
begin
  TEditorForm.Create(self).Show;
end;

procedure TMainPageForm.BtnRESTClientClick(Sender: TObject);
var
  RESTProperty: TRESTProperty;
begin
  RESTProperty.PrimaryKey := 'id';
  RESTProperty.SelectAllPath := '';
  RESTProperty.CreatePath := '';
  RESTProperty.UpdatePath := 'update';
  RESTProperty.DeletePath := 'delete';
  TRESTClientForm.Create(self, RESTProperty).Show;
end;

end.
