program BAM;

{$mode objfpc}{$H+}
{$DEFINE UseCThreads}

uses

  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads, cmem,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, unitDisco, uos_flat, UnitParam, UnitSON, unitSearch
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFrmDisco, FrmDisco);
  Application.CreateForm(TFrmParam, FrmParam);
  Application.CreateForm(TFrmSearch, FrmSearch);
  Application.Run;
end.

