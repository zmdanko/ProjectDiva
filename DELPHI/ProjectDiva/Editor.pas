unit Editor;

interface

uses
  System.Generics.Collections, System.SysUtils, System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Memo.Types,
  System.Actions, FMX.ActnList, FMX.StdCtrls, FMX.Menus, FMX.ScrollBox,
  FMX.Memo,
  FMX.Controls.Presentation, FMX.Edit,
  Data.DB,
  FMX.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  FireDAC.Comp.Client, FMX.TreeView, FMX.Layouts,
  FMX.ListBox;

type
  TEditorForm = class(TForm)
    Menu: TMainMenu;
    MFile: TMenuItem;
    ActionList: TActionList;
    AOpen: TAction;
    StatusBar: TStatusBar;
    FCount: TLabel;
    MOpen: TMenuItem;
    Editor: TMemo;
    ASave: TAction;
    MSave: TMenuItem;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    AUTF8: TAction;
    MFormat: TMenuItem;
    AASCII: TAction;
    MASCII: TMenuItem;
    MUTF8: TMenuItem;
    ActionList1: TActionList;

    procedure AOpenExecute(Sender: TObject);
    procedure EditorChange(Sender: TObject);
    procedure ASaveExecute(Sender: TObject);
    procedure AEncodingExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnFileClick(Sender: TObject);
    procedure TreeViewItem1Click(Sender: TObject);

  private
    FEncoding: TEncoding;
    procedure SetDefaultEncoding();
    procedure SetEncodingList();
    procedure Open;
  end;

var
  // ��ű�����-����TEncoding
  EncodingMap: TDictionary<String, TEncoding>;

implementation

{$R *.fmx}

// ״̬���ļ�����
procedure TEditorForm.EditorChange(Sender: TObject);
begin
  FCount.Text := 'count:' + Length(Editor.Text).ToString;
end;

// ����ʼ��


procedure TEditorForm.FormCreate(Sender: TObject);
begin
  // ��ʼ��Ĭ�ϱ���
  SetDefaultEncoding;

  // ��ʼ�������б�
  SetEncodingList;
end;


// ����Ĭ�ϱ���
procedure TEditorForm.SetDefaultEncoding();
begin
  self.FEncoding := TEncoding.UTF8;
end;

// ���ñ����б�
procedure TEditorForm.SetEncodingList;
begin
  EncodingMap := TDictionary<String, TEncoding>.Create;
  EncodingMap.Add('UTF8', TEncoding.UTF8);
  EncodingMap.Add('ASCII', TEncoding.ASCII);
end;

procedure TEditorForm.TreeViewItem1Click(Sender: TObject);
begin

end;

// �����ļ�
procedure TEditorForm.ASaveExecute(Sender: TObject);
var
  FileName: String;
begin
  FileName := OpenDialog.FileName;
  if (FileName = '') then
  begin
    // �Ի��������ļ���
    if not(SaveDialog.Execute) then
    begin
      exit;
    end;
    FileName := SaveDialog.FileName;
  end;
  // ����
  Editor.Lines.SaveToFile(FileName, self.FEncoding);
  ShowMessage('Save Success');
end;

procedure TEditorForm.BtnFileClick(Sender: TObject);
begin

end;

// ���ñ���
procedure TEditorForm.AEncodingExecute(Sender: TObject);
var
  EncodingType: String;
begin
  // ��ȡ������
  EncodingType := String(TAction(Sender).name).Substring(1);
  // ��ȡ����TEncoding
  self.FEncoding := EncodingMap.Items[EncodingType];

  if not(OpenDialog.FileName = '') then
  begin
    Open;
  end;

end;

// ���ļ�
procedure TEditorForm.AOpenExecute(Sender: TObject);
begin
  // ѡ����ļ�
  OpenDialog.Execute;
  // ��ȡ�ļ�
  Open;
end;

// ��ȡ�ļ�
procedure TEditorForm.Open;
begin
  Editor.Lines.LoadFromFile(OpenDialog.FileName, self.FEncoding);
end;

end.
