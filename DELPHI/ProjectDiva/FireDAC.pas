unit FireDAC;

interface

uses
  Adding, System.SysUtils, System.Types, System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  System.Rtti, FMX.Grid.Style, FMX.Bind.Grid, System.Bindings.Outputs,
  FMX.Bind.Editors, Data.Bind.EngExt, FMX.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.Grid, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.Bind.DBScope,
  FireDAC.Phys.IBDef, FireDAC.Phys.IBBase, FireDAC.Phys.IB, FireDAC.Comp.UI,
  Data.Bind.Controls, FMX.Layouts, FMX.Bind.Navigator, FMX.StdCtrls,
  System.Actions, FMX.ActnList, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef;

type
  TFireDACForm = class(TForm)
    FDConnection1: TFDConnection;
    BindingsList1: TBindingsList;
    ToolBar1: TToolBar;
    BtnAdding: TCornerButton;
    BtnEdit: TCornerButton;
    BtnDelete: TCornerButton;
    BtnExport: TCornerButton;
    BindSourceDB2: TBindSourceDB;
    SelectAllQuery: TFDQuery;
    SelectAll: TStringGrid;
    LinkGridToDataSourceBindSourceDB: TLinkGridToDataSource;
    procedure BtnAddingClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFireDACForm.BtnAddingClick(Sender: TObject);
begin
  TAddingForm.Create(self).ShowModal;
end;

end.
