program ProjectDiva;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainPage in 'MainPage.pas' {MainPageForm},
  Editor in 'Editor.pas' {EditorForm},
  FormPost in 'FormPost.pas' {PostForm},
  RESTForm in 'RESTForm.pas',
  RESTClient in 'RESTClient.pas' {RESTClientForm},
  DeleteForm in 'DeleteForm.pas' {DeleteForm},
  FilterForm in 'FilterForm.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TMainPageForm, MainPageForm);
  Application.Run;

end.