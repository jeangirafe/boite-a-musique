unit unitDisco;

{$mode objfpc}{$H+}

interface

uses
  uos_flat, Classes, SysUtils, sqlite3conn, sqldb, FileUtil, Forms, Controls, Graphics,
  Dialogs, DbCtrls, Grids, ExtCtrls, StdCtrls, ComCtrls, ActnList, Buttons,
  Menus, EditBtn, Arrow, Spin, StrUtils, inifiles;


type

  { TFrmDisco }

  TFrmDisco = class(TForm)
    ChkFade: TToggleBox;
    ChkEntame: TCheckBox;
    ChkTop: TCheckBox;
    CmdEntame: TBitBtn;
    CmdStop: TBitBtn;
    CmdModifArtiste: TBitBtn;
    ChkPays: TCheckBox;
    ChkTempo2: TCheckBox;
    CmdHoraire: TBitBtn;
    CmdPlayEN: TBitBtn;
    CmdJoue: TBitBtn;
    CmdRechInit: TBitBtn;
    CmdSuppHoraire: TBitBtn;
    Image1: TImage;
    LabelEntame: TStaticText;
    MenuItem1: TMenuItem;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    RadioGroup2: TRadioGroup;
    TextPays: TLabeledEdit;
    TextHoraire: TEdit;
    ListHoraires: TListBox;
    ChkCat: TCheckBox;
    ChkGenre: TCheckBox;
    ChkIntro: TCheckBox;
    ChkArtiste: TCheckBox;
    ChkTitre: TCheckBox;
    ChkTempo1: TCheckBox;
    ChkAnnee: TCheckBox;
    ChkPS: TCheckBox;
    ChkSI: TCheckBox;
    CmdMMoinsSI: TBitBtn;
    CmdPlaySI: TBitBtn;
    CmdSIReset: TBitBtn;
    CmdSuppArtiste: TBitBtn;
    CmdPlay: TBitBtn;
    CmdPlayPS: TBitBtn;
    CmdModif: TBitBtn;
    CmdEffacer: TBitBtn;
    CmdPPlusSI: TBitBtn;
    CmdSI: TBitBtn;
    CmdNouvArtiste: TBitBtn;
    FrmDisco: TButton;
    CmdMMoins: TBitBtn;
    CmdPPlus: TBitBtn;
    CmdIntro: TBitBtn;
    CmdPS: TBitBtn;
    CmdMoins: TBitBtn;
    CmdPlus: TBitBtn;
    ComboCat: TComboBox;
    CboCat: TComboBox;
    ComboGenre: TComboBox;
    ComboFiltre: TComboBox;
    CboGenre: TComboBox;
    ImageList1: TImageList;
    LabelPOS: TStaticText;
    LabelTOT: TStaticText;
    cboArtiste: TListBox;
    RadioGroup1: TRadioGroup;
    SpeedButton1: TSpeedButton;
    LabelIntro: TStaticText;
    LabelPS: TStaticText;
    LabelSI: TStaticText;
    ListViewDisco: TStringGrid;
    SQLQuery1: TSQLQuery;
    TextArtiste: TLabeledEdit;
    TextAnnee: TLabeledEdit;
    TextModifPays: TLabeledEdit;
    TextModifTitre: TLabeledEdit;
    TextModifAnnee: TLabeledEdit;
    TextModifArtiste: TLabeledEdit;
    TextTitre: TLabeledEdit;
    ChkActif: TToggleBox;
    Timer1: TTimer;
    procedure ChkFadeChange(Sender: TObject);
    procedure ChkFadeClick(Sender: TObject);
    procedure ChkTopChange(Sender: TObject);
    procedure CmdEntameClick(Sender: TObject);
    procedure CmdJoueClick(Sender: TObject);
    procedure CmdModifArtisteClick(Sender: TObject);
    procedure cboArtisteClick(Sender: TObject);
    procedure CboCatChange(Sender: TObject);
    procedure CboGenreChange(Sender: TObject);
    procedure ChkActifChange(Sender: TObject);
    procedure ChkActifClick(Sender: TObject);
    procedure ChkPaysChange(Sender: TObject);
    procedure ChkTempo1Change(Sender: TObject);
    procedure CmdEffacerClick(Sender: TObject);
    procedure CmdHoraireClick(Sender: TObject);
    procedure CmdIntroClick(Sender: TObject);
    procedure CmdMMoinsClick(Sender: TObject);
    procedure CmdMMoinsSIClick(Sender: TObject);
    procedure CmdModifClick(Sender: TObject);
    procedure CmdMoinsClick(Sender: TObject);
    procedure CmdNouvArtisteClick(Sender: TObject);
    procedure CmdPlayENClick(Sender: TObject);
    procedure CmdPlaySIClick(Sender: TObject);
    procedure CmdPlusClick(Sender: TObject);
    procedure CmdPlayClick(Sender: TObject);
    procedure CmdPlayPSClick(Sender: TObject);
    procedure CmdPPlusClick(Sender: TObject);
    procedure CmdPPlusSIClick(Sender: TObject);
    procedure CmdPSClick(Sender: TObject);
    procedure CmdRechInitClick(Sender: TObject);
    procedure CmdSIClick(Sender: TObject);
    procedure CmdSIResetClick(Sender: TObject);
    procedure CmdStopClick(Sender: TObject);
    procedure CmdSuppArtisteClick(Sender: TObject);
    procedure CmdSuppHoraireClick(Sender: TObject);
    procedure ComboCatChange(Sender: TObject);
    procedure ComboCatClick(Sender: TObject);
    procedure ComboFiltreChange(Sender: TObject);
    procedure ComboGenreChange(Sender: TObject);
    procedure ComboGenreClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure ListViewDiscoHeaderClick(Sender: TObject; IsColumn: Boolean;
      Index: Integer);
    procedure ListViewDiscoSelection(Sender: TObject; aCol, aRow: Integer);
    procedure MenuItem1Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure TextAnneeChange(Sender: TObject);
    procedure TextArtisteChange(Sender: TObject);
    procedure TextModifAnneeChange(Sender: TObject);
    procedure TextModifArtisteChange(Sender: TObject);
    procedure TextModifPaysChange(Sender: TObject);
    procedure TextModifTitreChange(Sender: TObject);
    procedure TextPaysChange(Sender: TObject);
    procedure TextTitreChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    //procedure LoopProcPlayer1;
    procedure ShowPosition;
  private
    { private declarations }

  public
    { public declarations }

  end;



  var
    //BufferBMP: TBitmap;
    //nPlayer : integer;
    {OutputIndex1, InputIndex1, DSPIndex1, DSPIndex2, PluginIndex1, PluginIndex2: integer;
    plugsoundtouch : boolean = false;
    plugbs2b : boolean = false;}
    FrmDisco: TFrmDisco;

implementation

uses
  unit1, UnitParam, unitson;
{$R *.lfm}

{ TFrmDisco }


Procedure ClearList;

  var
    i: integer;
  begin
    //for i:= 0 to FrmDisco.ListViewDisco.rowcount-1 do FrmDisco.ListViewDisco.rows[i].clear;
    FrmDisco.ListViewDisco.rowcount:=0;


    FrmDisco.ListViewDisco.ColWidths[1]:= 50; // 'NumSon
    FrmDisco.ListViewDisco.ColWidths[2]:= 150; //'Artiste
    FrmDisco.ListViewDisco.ColWidths[3]:= 150; // 'titre
    FrmDisco.ListViewDisco.ColWidths[4]:= 40; // 'Genre
    FrmDisco.ListViewDisco.ColWidths[5]:= 40; // 'Durée
    FrmDisco.ListViewDisco.ColWidths[6]:= 0; // 'Categorie
    FrmDisco.ListViewDisco.ColWidths[7]:= 0; // 'NumArtiste
    FrmDisco.ListViewDisco.ColWidths[8]:= 0; // 'Durée sec
    FrmDisco.ListViewDisco.ColWidths[9]:= 0; // 'Num
  end;

function InstrRev(Src:string; s: Char): integer;
  var B:integer;
begin
result := -1;
if length(src) = 0 then exit;
if length(s) = 0 then exit;

for B:= length(src) downto 0 do
  if src[B] = s then
    break;
    result := B;
end;

Procedure refreshHoraire(n: integer);
begin
  FrmDisco.ListHoraires.Clear;
  FrmDisco.SQLQuery1.SQL.Text := 'SELECT Num, Numtop, Horaire FROM Tops WHERE NumTop = ' + inttostr(n) + ' ORDER BY Horaire;' ;
  FrmDisco.SQLQuery1.Open;
  While Not FrmDisco.SQLQuery1.EOF do
     begin
        FrmDisco.ListHoraires.AddItem(FormatDateTime('hh:nn:ss', FrmDisco.SQLQuery1.FieldByName('Horaire').AsDateTime), TObject(PtrInt(FrmDisco.SQLQuery1.FieldByName('Num').AsInteger)));
        FrmDisco.SQLQuery1.Next
     end;

FrmDisco.SQLQuery1.close;
End;


Procedure refreshGenre;
var
  i:PtrInt;
  sGenre:string;
  //s1: Tstringlist;
begin

  FrmDisco.cboGenre.Clear;
  FrmDisco.comboGenre.Clear;
  FrmDisco.combogenre.AddItem('[TOUS]', TObject(-1));

  FrmDisco.SQLQuery1.SQL.Text := 'SELECT NumDossier, NomGenre FROM Dossiers ORDER BY NomGenre;' ;
  FrmDisco.SQLQuery1.Open;
  While Not FrmDisco.SQLQuery1.EOF do
     begin
        sGenre:=FrmDisco.SQLQuery1.FieldByName('NomGenre').AsString;
        i:=FrmDisco.SQLQuery1.FieldByName('NumDossier').AsInteger;
        FrmDisco.cbogenre.AddItem(sGenre, TObject(i));
        FrmDisco.combogenre.AddItem(sGenre, TObject(i));
        FrmDisco.SQLQuery1.Next
     end;

     FrmDisco.SQLQuery1.close;


  {For i:=0 to 150 do
      begin
       FrmDisco.cbogenre.AddItem(stringGenre(i), TObject(i));
       FrmDisco.combogenre.AddItem(stringGenre(i), TObject(i));
      end;}
  FrmDisco.combogenre.ItemIndex:=0;

  {try
    s1 := TStringList.Create;
    s1.Assign(FrmDisco.cboGenre.Items);
    s1.sort;
    FrmDisco.cboGenre.Items.Assign(s1);
  finally
    s1.Free
  end;}
end;

Procedure refreshArtiste;
begin
FrmDisco.CboArtiste.Clear;
FrmDisco.SQLQuery1.SQL.Text := 'SELECT NumArtiste, NomArtiste FROM Artistes ORDER BY NomArtiste;' ;
FrmDisco.SQLQuery1.Open;

While Not FrmDisco.SQLQuery1.EOF do
     begin
        FrmDisco.CboArtiste.AddItem(FrmDisco.SQLQuery1.Fields[1].AsString, TObject(PtrInt(FrmDisco.SQLQuery1.Fields[0].AsInteger))); //NomArtiste
        FrmDisco.SQLQuery1.Next
     end;

FrmDisco.cboArtiste.TopIndex:=5;
FrmDisco.SQLQuery1.close;
End;



Procedure PlayFile(n : integer; nPos : single);
begin
     //uos_Stop(n);
     uos_SeekSeconds(n, InputIndex1 ,nPos);
     uos_Play(n);

end;

Procedure CmdPaint(i: integer);
var
  ActiveBitmap : TBitMap;
begin
FrmDisco.CmdMoins.Glyph := Nil;
FrmDisco.CmdMMoins.Glyph := Nil;
FrmDisco.CmdPlus.Glyph := Nil;
FrmDisco.CmdPPlus.Glyph := Nil;


Case i of
  0:begin
         FrmDisco.Imagelist1.GetBitmap(1, FrmDisco.CmdMMoins.Glyph);
         FrmDisco.Imagelist1.GetBitmap(3, FrmDisco.CmdMoins.Glyph);
         FrmDisco.Imagelist1.GetBitmap(5, FrmDisco.CmdPlus.Glyph);
         FrmDisco.Imagelist1.GetBitmap(7, FrmDisco.CmdPPlus.Glyph);
    end;
  1:begin
      FrmDisco.Imagelist1.GetBitmap(0, FrmDisco.CmdMMoins.Glyph);
      FrmDisco.Imagelist1.GetBitmap(2, FrmDisco.CmdMoins.Glyph);
      FrmDisco.Imagelist1.GetBitmap(4, FrmDisco.CmdPlus.Glyph);
      FrmDisco.Imagelist1.GetBitmap(6, FrmDisco.CmdPPlus.Glyph);
   end;
  2:begin
      FrmDisco.Imagelist1.GetBitmap(10, FrmDisco.CmdMMoins.Glyph);
      FrmDisco.Imagelist1.GetBitmap(12, FrmDisco.CmdMoins.Glyph);
      FrmDisco.Imagelist1.GetBitmap(13, FrmDisco.CmdPlus.Glyph);
      FrmDisco.Imagelist1.GetBitmap(11, FrmDisco.CmdPPlus.Glyph);
   end;
  end;
end;

Procedure AfficheRow(aRow : integer);
  var
     i : integer;
     nPS : integer;
     nArtiste, nGenre : integer;
     nIntro, nDuree, nEntame : integer;
     t1, t2 : integer;
     LePath : string;
     sFile: string;
     p: integer;
     inifile: Tinifile;

  begin

  inifile:= TIniFile.Create('JBox.ini');
  sFile:= inifile.ReadString('Pochettes', 'chemin', '\home') + '/' + FrmDisco.ListViewDisco.Cells[0,aRow] + '.jpg';
  If fileexists(sFile) then Frmdisco.Image1.Picture.LoadFromFile(sFile) else frmdisco.Image1.Picture.Clear;

  FrmDisco.textmodiftitre.Text:=FrmDisco.ListViewDisco.Cells[1,aRow];       //titre

  FrmDisco.textmodifArtiste.Text:='';
  nArtiste:= strtoint(FrmDisco.ListViewDisco.Cells[2,aRow]);        //numArt
  for i:=0 to FrmDisco.cboArtiste.items.count -1 do
    begin
       If nArtiste = PtrInt(FrmDisco.cboArtiste.Items.Objects[i]) then FrmDisco.cboArtiste.ItemIndex:=i;
    end;

  nGenre:= strtoint(FrmDisco.ListViewDisco.Cells[6,aRow]);              //numgenre
  for i:=0 to FrmDisco.cbogenre.items.count -1 do
    begin
       If nGenre = PtrInt(FrmDisco.cbogenre.Items.Objects[i]) then FrmDisco.cbogenre.ItemIndex:=i;
    end;

  FrmDisco.Labelsi.Tag:=strtoint(FrmDisco.ListViewDisco.Cells[12,aRow]);        //surImp
  FrmDisco.LabelSI.Caption:=floattostr(FrmDisco.LabelSI.tag/1000);

  nPS:=strtoint(FrmDisco.ListViewDisco.Cells[15,aRow]);          //PS
  If nPS = 0 Then nPS:= 5000; //LitDansFichierIni("Parametres", "timingfin" & j + 1, "JBox.ini", 5000)
  FrmDisco.LabelPS.tag:=nPS;
  FrmDisco.LabelPS.Caption:= floattostr(nPS/1000);

  //ENTAME
  nEntame:=strtoint(FrmDisco.ListViewDisco.Cells[21,aRow]);
  FrmDisco.LabelEntame.tag:=nEntame;
  FrmDisco.LabelEntame.Caption:= floattostr(nEntame/1000);


  FrmDisco.cboCat.ItemIndex:=strtoint(FrmDisco.ListViewDisco.Cells[4,aRow]) - 1;       //NumCat

  //NUMGENRE : FrmDisco.ListViewDisco.Cells[6,aRow];
  nDuree:=strtoint(FrmDisco.ListViewDisco.Cells[18,aRow]);      //Duree
  FrmDisco.Labeltot.tag:=nDuree;
  FrmDisco.Labeltot.Caption:= ConvHMSMilli(nDuree);
  FrmDisco.Labelpos.tag:=0;
  frmDisco.Labelpos.caption:= '00:00:00.000';

  FrmDisco.TextModifAnnee.Text:=FrmDisco.ListViewDisco.Cells[8,aRow]; //Annee
  FrmDisco.TextModifPays.Text:=FrmDisco.ListViewDisco.Cells[19,aRow];      //PAys

  t1:=strtoint(FrmDisco.ListViewDisco.Cells[13,aRow]);  //tempo1
  t2:=strtoint(FrmDisco.ListViewDisco.Cells[14,aRow]);   //tempo2
  FrmDisco.RadioGroup1.ItemIndex:=t1;
  FrmDisco.RadioGroup2.ItemIndex:=t2;

  Case strtoint(FrmDisco.ListViewDisco.Cells[16,aRow]) of       //actif
       1:begin
          FrmDisco.ChkActif.Font.Color:= $004FE6BE; //'BEE64F;
          FrmDisco.ChkActif.Caption:= 'ACTIF';
          FrmDisco.chkactif.State:= cbchecked; //.Checked:=true;
        end;
        0:begin
           FrmDisco.ChkActif.Font.Color:= $002700D8; //5564EB; //#EB6455;
           FrmDisco.ChkActif.Caption:= 'INACTIF';
           FrmDisco.chkactif.State:=cbunchecked; //.Checked:=false;
        end;

    end;

  Case strtoint(FrmDisco.ListViewDisco.Cells[22,aRow]) of       //fade ?
       1:begin
          FrmDisco.ChkFade.Font.Color:= $004FE6BE; //'BEE64F;
          FrmDisco.ChkFade.Caption:= 'Forcer le FADE';
          FrmDisco.chkFade.State:= cbchecked; //.Checked:=true;
        end;
        0:begin
           FrmDisco.ChkFade.Font.Color:= $002700D8; //5564EB; //#EB6455;
           FrmDisco.ChkFade.Caption:= 'Pas de FADE';
           FrmDisco.chkFade.State:=cbunchecked; //.Checked:=false;
        end;

    end;

  //jingle ?
  If strtoint(FrmDisco.ListViewDisco.Cells[4,aRow]) = 3 then Frmdisco.ChkTop.Visible:=true
     else  Frmdisco.ChkTop.Visible:=false;

  //top horaire ?
  If FrmDisco.ListViewDisco.Cells[20,aRow] = '1' then
     begin
        Frmdisco.ChkTop.Checked:=True;
        Frmdisco.TextHoraire.Visible:=true;
        Frmdisco.ListHoraires.Visible:=true;
        Frmdisco.CmdHoraire.Visible:=true;
        Frmdisco.CmdSuppHoraire.Visible:=true;
        RefreshHoraire(strtoint(FrmDisco.ListViewDisco.Cells[0,aRow]));
        Frmdisco.Image1.Top:=404;
        Frmdisco.Image1.Left:=1000;
        Frmdisco.Image1.Height:=128;
        Frmdisco.Image1.Width:=128;
        //Frmdisco.Image1.Top:=470;
        //Frmdisco.Image1.Left:=864;
        //Frmdisco.Image1.Height:=66;
        //Frmdisco.Image1.Width:=66;
     end
  else
      begin
           Frmdisco.ChkTop.Checked:=False;
        Frmdisco.TextHoraire.Visible:=false;
        Frmdisco.ListHoraires.Visible:=false;
        Frmdisco.CmdHoraire.Visible:=false;
        Frmdisco.CmdSuppHoraire.Visible:=false;
        Frmdisco.Image1.Top:=404;
        Frmdisco.Image1.Left:=1000;
        Frmdisco.Image1.Height:=128;
        Frmdisco.Image1.Width:=128;
     end;

  nIntro:=strtoint(FrmDisco.ListViewDisco.Cells[17,aRow]);         //intro
  FrmDisco.LabelIntro.tag:=nIntro;
  FrmDisco.LabelIntro.Caption:= floattostr(nIntro/1000);

  FrmDisco.cmdModif.enabled:=false;
  Lepath:=FrmDisco.ListViewDisco.Cells[11,aRow];//filename
  FrmDisco.ListViewDisco.Hint:=Lepath;

  FrmDisco.Imagelist1.GetBitmap(8, FrmDisco.CmdPlay.Glyph);
   If Fileexists(LePath) then
      begin
           FrmDisco.cmdPlay.enabled:=true;
           FrmDisco.cmdPlayPS.enabled:=true;
           FrmDisco.CmdPlayPS.Tag:= 1;
           FrmDisco.cmdPlayEN.enabled:=true;
           FrmDisco.cmdJoue.enabled:=true;
           CmdPaint(1);
      end
   else
       begin
          FrmDisco.cmdPlay.enabled:=false;
          FrmDisco.cmdPlayPS.enabled:=false;
          FrmDisco.cmdPlayEN.enabled:=false;
          FrmDisco.cmdJoue.enabled:=false;
       end;


       if uos_getstatus(0) = 1 then uos_stop(0);




       {p:=ChargePlayer(Lepath);
  if p <>-1 then
     begin
          FrmDisco.cmdPlay.enabled:=true;
          FrmDisco.cmdPlayPS.enabled:=true;
          FrmDisco.CmdPlay.tag:= p;
          FrmDisco.cmdplay.Caption:=inttostr(p);  //
     end
  else
      begin
         FrmDisco.CmdPlay.tag:= -1;
         FrmDisco.cmdPlay.enabled:=false;
         FrmDisco.cmdPlayPS.enabled:=false;
      end;}

  FrmDisco.Timer1.Enabled:=true;

end;


Procedure DiscoRefresh(sCol: string);
Var
  i: integer;
  j: integer;
  sAnnee: string;
  sql: string;
  nTot: integer;
  nPos: integer;
  NomColonne: string;
  //nDefaut: integer;
  sTime : TDateTime;
  //ini: Tinifile;


begin
//ini:=TiniFile.Create('ProgMix.ini');
//nDefaut:= strtoint(Ini.ReadString('Artistes', 'Defaut', '0'));
//sDate:= strtodatetime(sD);



screen.cursor:= crHourGlass;

application.ProcessMessages;
//Frmdisco.listbox1.Items.add('ref ' + scol);
//FrmDisco.ListViewDisco.Redraw = False

If sCol = '' then sCol:='numfich';
If UpperCase(sCol) = 'ARTISTE' then sCol:='Artistes.nomartiste';
If UpperCase(sCol) = 'GENRE' then sCol:='Morceaux.numGenre';
If UpperCase(sCol) = 'CATEGORIE' then sCol:='Morceaux.numCat';
NomColonne:=sCol ;
sql:= 'SELECT Morceaux.Numfich, Artistes.NumArtiste, Artistes.NomArtiste, Morceaux.Titre, Morceaux.PS, Morceaux.Numcat, Dossiers.Numdossier, Morceaux.Duree, Morceaux.Intro, Morceaux.SurImpression, Morceaux.Annee, Morceaux.DerniereDiffusion, Morceaux.Filename, Morceaux.Tempo1, Morceaux.Tempo2, Morceaux.actif, Morceaux.top, Morceaux.Entame, Morceaux.Fade, Dossiers.chemin, Dossiers.NomGenre, Artistes.Pays FROM Artistes, Morceaux, Dossiers WHERE (Artistes.NumArtiste = Morceaux.NumArtiste) AND (Morceaux.Numdossier=Dossiers.Numdossier) ';

If length(FrmDisco.TextAnnee.text)=4 then sql:= sql + ' And Morceaux.Annee = ''' + FrmDisco.TextAnnee.Text + ''' ';
If FrmDisco.textartiste.Text <> '' Then sql:= sql + ' And UPPER(Artistes.NomArtiste) LIKE ''%' + SpecialStr(UpperCase(FrmDisco.textartiste.Text)) + '%'' ';
If FrmDisco.TextTitre.Text <> '' Then sql:= sql + ' And UPPER(Morceaux.Titre) LIKE ''%' + SpecialStr(UpperCase(FrmDisco.TextTitre.Text)) + '%'' ';
If FrmDisco.TextPays.Text <> '' Then sql:= sql + ' And UPPER(Artistes.Pays) LIKE ''%' + SpecialStr(UpperCase(FrmDisco.TextPays.Text)) + '%'' ';
If FrmDisco.ComboCat.ItemIndex > 0 Then sql:= sql + ' And Morceaux.NumCat = ' + inttostr(FrmDisco.ComboCat.itemindex);
If FrmDisco.Combogenre.ItemIndex > 0 Then sql:= sql + ' And Dossiers.Numdossier = ' + inttostr(PtrInt(FrmDisco.comboGenre.Items.Objects[FrmDisco.comboGenre.ItemIndex]));
If FrmDisco.ComboFiltre.itemIndex > 0 Then
    Case FrmDisco.ComboFiltre.ItemIndex of
         1:sql:= sql + ' And Morceaux.actif = 1';
         2:sql:= sql + ' And Morceaux.actif = 0';
         3:sql:= sql + ' AND Morceaux.DerniereDiffusion = ''1900-01-01 12:00:00''';
    End;


sql:= sql + ' ORDER BY ' + sCol + ';';


FrmDisco.SQLQuery1.SQL.Text := sql;
FrmDisco.SQLQuery1.Open;

FrmDisco.ListViewDisco.rowcount:=1;
i:=1;
nPos:=1;



While Not FrmDisco.SQLQuery1.EOF do
  begin
    NPos:= NPos + 1;
    FrmDisco.ListViewDisco.rowcount:=NPos;

    FrmDisco.ListViewDisco.Cells[0,i]:=FrmDisco.SQLQuery1.FieldByName('Numfich').AsString; //NumFich
    FrmDisco.ListViewDisco.Cells[1,i]:=FrmDisco.SQLQuery1.FieldByName('Titre').AsString; //titre
    FrmDisco.ListViewDisco.Cells[2,i]:=FrmDisco.SQLQuery1.FieldByName('NumArtiste').AsString; //NumArtiste
    FrmDisco.ListViewDisco.Cells[3,i]:=FrmDisco.SQLQuery1.FieldByName('NomArtiste').AsString; //NomArtiste
    FrmDisco.ListViewDisco.Cells[4,i]:=FrmDisco.SQLQuery1.FieldByName('Numcat').AsString; //NumCat
     Case strtoint(FrmDisco.SQLQuery1.FieldByName('Numcat').AsString) of        //NomCat
          1:FrmDisco.ListViewDisco.Cells[5,i]:='MUSIQUE';
          2:FrmDisco.ListViewDisco.Cells[5,i]:='CAPSULE';
          3:FrmDisco.ListViewDisco.Cells[5,i]:='JINGLE';
          4:FrmDisco.ListViewDisco.Cells[5,i]:='INSTRU';
     end;
    FrmDisco.ListViewDisco.Cells[6,i]:=FrmDisco.SQLQuery1.FieldByName('NumDossier').AsString; //NumDossier
    FrmDisco.ListViewDisco.Cells[7,i]:=FrmDisco.SQLQuery1.FieldByName('Nomgenre').Asstring; //NomGenre //stringGenre(FrmDisco.SQLQuery1.Fields[6].Asinteger); //NomGenre  5
    FrmDisco.ListViewDisco.Cells[8,i]:=FrmDisco.SQLQuery1.FieldByName('Annee').AsString; //Année

    sTime:=strtodatetime(FrmDisco.SQLQuery1.FieldByName('DerniereDiffusion').AsString);
    FrmDisco.ListViewDisco.Cells[9,i]:=ConvHMS(FrmDisco.SQLQuery1.FieldByName('Duree').asinteger); //Duree  HMS
    FrmDisco.ListViewDisco.Cells[10,i]:=string(FormatDateTime('dd/mm/yyyy hh:nn:ss',sTime)); //Derniere Diff
    FrmDisco.ListViewDisco.Cells[11,i]:=FrmDisco.SQLQuery1.FieldByName('chemin').AsString +'/'+FrmDisco.SQLQuery1.FieldByName('filename').AsString; //chemin
    FrmDisco.ListViewDisco.Cells[12,i]:=FrmDisco.SQLQuery1.FieldByName('SurImpression').AsString; //SurImpression
    FrmDisco.ListViewDisco.Cells[13,i]:=FrmDisco.SQLQuery1.FieldByName('Tempo1').AsString; //Tempo1
    FrmDisco.ListViewDisco.Cells[14,i]:=FrmDisco.SQLQuery1.FieldByName('Tempo2').AsString; //Tempo2
    FrmDisco.ListViewDisco.Cells[15,i]:=FrmDisco.SQLQuery1.FieldByName('PS').AsString; //PS

    FrmDisco.ListViewDisco.Cells[16,i]:=FrmDisco.SQLQuery1.FieldByName('Actif').AsString; //Actif
    FrmDisco.ListViewDisco.Cells[17,i]:=FrmDisco.SQLQuery1.FieldByName('Intro').AsString; //Intro
    FrmDisco.ListViewDisco.Cells[18,i]:=FrmDisco.SQLQuery1.FieldByName('Duree').Asstring; //Duree MS
    FrmDisco.ListViewDisco.Cells[19,i]:=FrmDisco.SQLQuery1.FieldByName('Pays').Asstring; //Pays
    FrmDisco.ListViewDisco.Cells[20,i]:=FrmDisco.SQLQuery1.FieldByName('Top').Asstring; //Pays
    FrmDisco.ListViewDisco.Cells[21,i]:=FrmDisco.SQLQuery1.FieldByName('Entame').Asstring; //Entame
    FrmDisco.ListViewDisco.Cells[22,i]:=FrmDisco.SQLQuery1.FieldByName('Fade').Asstring; //fade (oui/non 1/0)
    //
    //If Minute(sTime) = 0 And Second(sTime) = 0 Then sTime:= FormatDateTime('hh:nn:ss',sTime);



    FrmDisco.SQLQuery1.Next;
    i:=i+1;
  end;

nTot:= FrmDisco.SQLQuery1.RecordCount;

FrmDisco.SQLQuery1.close;

case nTot of
     0:FrmDisco.Caption:='Aucun élément trouvé dans la discothèque.';
     1:FrmDisco.Caption:='1 seul élément trouvé dans la discothèque.';
     else FrmDisco.Caption:=inttostr(nTot) + ' éléments trouvés dans la discothèque.';
end;

screen.cursor:= crDefault;
//ListProg.Redraw = True

End;



procedure TFrmDisco.FormCreate(Sender: TObject);
var
  i:integer;
begin

ComboCat.itemindex:=0;
ComboFiltre.itemindex:=0;
RefreshGenre;

//SQLite3Connection1.DatabaseName:='/home/jeremie/MusicBase';
//SQLite3Connection1.Connected:=true;

//SQLTransaction1.DataBase:=SQLite3Connection1;
SQLQuery1.DataBase := Form1.SQLite3Connection1;
SQLQuery1.UsePrimaryKeyAsKey := False;


end;

procedure TFrmDisco.Image1Click(Sender: TObject);
var
  filename:string;
  chemindefaut:string;
  inifile: Tinifile;
  n:integer;
begin

  inifile:= TIniFile.Create('JBox.ini');
  try


If OpenDialog1.Execute then
     begin
          chemindefaut:=inifile.ReadString('Pochettes','chemin','/home/');
          filename:= OpenDialog1.Filename;
          n:=strtoint(listviewDisco.Cells[0, listviewdisco.Row]);
          If copyfile(filename, chemindefaut + '/' + inttostr(n) + '.jpg') then
               Image1.Picture.LoadFromFile(filename);

     end

  finally
    inifile.Free;

  end;
end;



procedure TFrmDisco.ListViewDiscoHeaderClick(Sender: TObject;
  IsColumn: Boolean; Index: Integer);
var
   scolumn: string;
begin
    If IsColumn then
       begin
          scolumn:=ListViewDisco.Columns[Index].Title.Caption;
          If scolumn = 'Durée' then scolumn:= 'Duree';
          If scolumn = 'Dernière Diffusion' then scolumn:= 'DerniereDiffusion';
          DiscoRefresh (scolumn);

       end;
end;

procedure TFrmDisco.ListViewDiscoSelection(Sender: TObject; aCol, aRow: Integer
  );
begin
   AfficheRow(listviewdisco.Row);
end;

procedure TFrmDisco.MenuItem1Click(Sender: TObject);
var
  PathNew:string;
  PathOld:string;
  DirSon:string;
  NewFile:string;
  OldFile:string;
  n:integer;
  aRow:integer;
  r:word;
begin

If OpenDialog1.Execute then
     begin
          aRow:=ListviewDisco.Row;
          PathOld:=ListViewDisco.Cells[11,aRow];
          n:=Pos('/',Reversestring(PathOld));
          OldFile:=RightStr(PathOld,n - 1);
          DirSon:=LeftStr(PathOld, Length(PathOld)- n);

          PathNew:= OpenDialog1.Filename;
          n:=Pos('/',Reversestring(PathNew));
          NewFile:=RightStr(PathNew,n - 1);

               begin
                  r:= MessageDlg('Vous allez affecter le son ' + NewFile + '. Voulez-vous supprimer le son courant : ' + OldFile + ' du répertoire ?', mtWarning, [mbYes, mbNo, mbAbort],0);
                  If r = mrYes Then Deletefile(PathOld);
                  If copyfile(PathNew, DirSon + '/' + NewFile) then
                     begin
                        SQLQuery1.SQL.Clear;
                        SQLQuery1.SQL.Text := 'SELECT NumFich, Filename FROM Morceaux WHERE Morceaux.NumFich = ' + listviewDisco.Cells[0, aRow] + ';';
                        SQLQuery1.Open;
                        If not SQLQuery1.EOF then
                           begin
                                SQLQuery1.Edit;
                                SQLQuery1.FieldByName('Filename').AsString:=NewFile;
                                SQLQuery1.Post;
                                SQLQuery1.ApplyUpdates;
                                SQLQuery1.Close;
                           end;
                        ListViewDisco.Cells[11,aRow]:=DirSon + '/' + NewFile;
                        ListViewDisco.Hint:=DirSon + '/' + NewFile;
                     end;
               end;

     end;





end;




procedure TFrmDisco.RadioGroup1Click(Sender: TObject);
begin
  CmdModif.Enabled:=true;
end;

procedure TFrmDisco.RadioGroup2Click(Sender: TObject);
begin
  CmdModif.Enabled:=true;
end;

procedure TFrmDisco.TextAnneeChange(Sender: TObject);
begin
   If length(TextAnnee.Text)=4 Then DiscoRefresh ('Morceaux.Annee');
end;


procedure TFrmDisco.TextArtisteChange(Sender: TObject);
begin
  If length(TextArtiste.Text)>2 Then DiscoRefresh ('Artistes.nomArtiste');
end;

procedure TFrmDisco.TextModifAnneeChange(Sender: TObject);
begin
  CmdModif.Enabled:=true;
end;

procedure TFrmDisco.TextModifArtisteChange(Sender: TObject);
var
   i : integer;
begin
  If TextModifArtiste.Text <>'' then
     For i:=0 to cboArtiste.Count - 1 do
         If uppercase(textmodifartiste.Text) = uppercase(leftstr(cboArtiste.Items[i], length(textmodifartiste.Text))) then
              begin
                   cboArtiste.TopIndex:=i;
                   break;
              end;
end;

procedure TFrmDisco.TextModifPaysChange(Sender: TObject);
begin
  CmdModif.Enabled:=true;
end;

procedure TFrmDisco.TextModifTitreChange(Sender: TObject);
begin
  CmdModif.Enabled:=true;
end;

procedure TFrmDisco.TextPaysChange(Sender: TObject);
begin
  If length(TextPays.Text)>2 Then DiscoRefresh ('Artistes.Pays');
end;

procedure TFrmDisco.TextTitreChange(Sender: TObject);
begin
  If length(TextTitre.Text)>2 Then DiscoRefresh ('Morceaux.titre');
end;

procedure TFrmDisco.Timer1Timer(Sender: TObject);
var
   nSec: single;
   p: integer;
   temptime: ttime;
   ho, mi, se, ms: word;
begin
    //p:=cmdPlay.tag;
    //If p<>-1 then
       If uos_GetStatus(0)=1 then
          begin
               nSec:= uos_InputPositionSeconds(0, InputIndex1);
               //frmdisco.Caption:=floattostr(nsec);
               LabelPos.Tag:= trunc(nSec * 1000);
               //LabelPos.Caption:= ConvHMS(labelPos.tag);

               temptime := uos_InputPositionTime(0, InputIndex1);
               DecodeTime(temptime, ho, mi, se, ms);
               LabelPos.Caption := format('%.2d:%.2d:%.2d.%.3d', [ho, mi, se, ms]);

          end;
end;



procedure TFrmDisco.ComboCatChange(Sender: TObject);
begin
   DiscoRefresh ('Morceaux.numcat');
end;


procedure TFrmDisco.CmdPlayClick(Sender: TObject);
var
  nIntro : single;
  //p: integer;
  n : integer;
  LePath : string;
  samformat: shortint;
  temptime: ttime;
  ho, mi, se, ms: word;
begin
     CmdPlayPS.Tag:= 1;
     CmdPaint(1);
     n:=ListViewDisco.Row;
     Lepath:=ListViewDisco.Cells[11,n];

     //chargement du son dans le player 0
     {If uos_GetStatus(0) = 1 then

      begin
           uos_stop(0);
           Imagelist1.GetBitmap(8, CmdPlay.Glyph);
      end
     else
         begin}
              uos_stop(0);
           //Imagelist1.GetBitmap(9, CmdPlay.Glyph);
           uos_CreatePlayer(0); /// you may create how many players you want, from 0 to to what you computer can do...
           uos_AddIntoDevOut(0);   //// Add Output with default parameter


           InputIndex1 := uos_AddFromFile(0, PChar(LePath));
           uos_InputSetPositionEnable(0, InputIndex1, 1) ;
           uos_AddDSPVolumeIn(0, inputIndex1, 1, 1);
           uos_InputSetLevelEnable(0, InputIndex1, 3) ;

           temptime:= uos_InputLengthTime(0, inputIndex1 );
           DecodeTime(temptime, ho, mi, se, ms);
           labeltot.tag:= integer(mi + 1000*se + 60000*mi + 3600000*ho);
           LabelTOT.caption:= format('%.2d:%.2d:%.2d.%.3d', [ho, mi, se, ms]);
         //end;
      //end;
     nIntro:= (LabelIntro.tag) / 1000;
     Playfile (0, nIntro);
end;



procedure TFrmDisco.CmdPPlusSIClick(Sender: TObject);

begin
     If LabelSI.Tag <> 0 Then
        begin
             If LabelSI.Tag - 1000 < 0 Then LabelSI.Tag:= 0
                    Else LabelSI.Tag:= LabelSI.Tag - 1000;
           LabelSI.Caption:= Floattostr(LabelSI.Tag/1000);

        end;

CmdModif.Enabled:= true;

end;


procedure TFrmDisco.CmdPlusClick(Sender: TObject);
begin
Case CmdPlayPS.Tag of
  1:begin
      LabelIntro.Tag:= LabelIntro.Tag + 100;
      LabelIntro.Caption:= Floattostr(LabelIntro.Tag/1000);
      end;
  2:begin
      LabelEntame.Tag:= LabelEntame.Tag + 100;
      LabelEntame.Caption:= Floattostr(LabelEntame.Tag/1000);
      end;
  0:begin
         If LabelPS.Tag <> 0 Then
             begin
                  If LabelPS.Tag - 100 < 0 Then LabelPS.Tag:= 0
                  Else LabelPS.Tag:= LabelPS.Tag - 100;
             end;
         LabelPS.Caption:= Floattostr(LabelPS.Tag/1000);

      end;
  End;

CmdModif.Enabled:= true;

end;

procedure TFrmDisco.CmdMoinsClick(Sender: TObject);
begin
    Case CmdPlayPS.Tag of
    0:begin
        LabelPS.Tag:= LabelPS.Tag + 100;
        LabelPS.Caption:= Floattostr(LabelPS.Tag/1000);
        end;
    1:begin
           If LabelIntro.Tag <> 0 Then
               begin
                    If LabelIntro.Tag - 100 < 0 Then LabelIntro.Tag:= 0
                    Else LabelIntro.Tag:= LabelIntro.Tag - 100;
               end;
           LabelIntro.Caption:= Floattostr(LabelIntro.Tag/1000);

        end;
    2:begin
           If LabelEntame.Tag <> 0 Then
               begin
                    If LabelEntame.Tag - 100 < 0 Then LabelEntame.Tag:= 0
                    Else LabelEntame.Tag:= LabelEntame.Tag - 100;
               end;
           LabelEntame.Caption:= Floattostr(LabelEntame.Tag/1000);

        end;
    End;

CmdModif.Enabled:= true;
end;

procedure TFrmDisco.CmdNouvArtisteClick(Sender: TObject);
var
  sNouvArtiste : String;
  i : integer;
begin
  repeat
     sNouvArtiste:= InputBox('Nouvel artiste', 'Veuillez entrer le nom de l''artiste à ajouter', '');
  until sNouvArtiste <> '';
  If sNouvArtiste = '' Then Exit;
  If Length(sNouvArtiste) > 50 Then
     begin
          Showmessage('Vous avez dépassé le nombre de caractères autorisé');
          Exit;
     End;

  SQLQuery1.SQL.text:= 'SELECT * FROM Artistes WHERE Upper(NomArtiste) = ''' + Uppercase(sNouvArtiste) + ''';';
  SQLQuery1.open;
  If not SQLQuery1.eof Then
    begin
       Showmessage('L''artiste que vous voulez créer existe déjà');
       SQLQuery1.close;
       Exit;
    end;
  SQLQuery1.close;
  SQLQuery1.SQL.text:= 'INSERT INTO Artistes (NumArtiste, NomArtiste) VALUES ((SELECT MAX(NumArtiste) FROM Artistes) + 1, ''' + sNouvArtiste + ''');';
  SQLQuery1.ExecSQL;
  Form1.SQLTransaction1.CommitRetaining;
  SQLQuery1.close;

  RefreshArtiste;
  TextModifArtiste.Text:=sNouvArtiste;
  Application.ProcessMessages;

  i:=cboArtiste.TopIndex;
  cboArtiste.ItemIndex:=i;

  cmdmodif.Enabled:=true;

end;

procedure TFrmDisco.CmdPlayENClick(Sender: TObject);
var
   nEN : single;
   n : integer;
   LePath : string;
   samformat: shortint;
   temptime: ttime;
   ho, mi, se, ms: word;
begin
     CmdPlayPS.Tag:= 2;
     CmdPaint (2);
     n:=ListViewDisco.Row;
     Lepath:=ListViewDisco.Cells[11,n];

     uos_stop(0);
     uos_CreatePlayer(0); /// you may create how many players you want, from 0 to to what you computer can do...
     uos_AddIntoDevOut(0);   //// Add Output with default parameter
     InputIndex1 := uos_AddFromFile(0, PChar(LePath));
     uos_InputSetPositionEnable(0, InputIndex1, 1) ;
     uos_AddDSPVolumeIn(0, inputIndex1, 1, 1);
     uos_InputSetLevelEnable(0, InputIndex1, 3) ;

     temptime:= uos_InputLengthTime(0, inputIndex1 );
     DecodeTime(temptime, ho, mi, se, ms);
     labeltot.tag:= integer(mi + 1000*se + 60000*mi + 3600000*ho);
     LabelTOT.caption:= format('%.2d:%.2d:%.2d.%.3d', [ho, mi, se, ms]);

     nEN:= (Labelentame.Tag) / 1000;
     Playfile (0, nEN);
end;

procedure TFrmDisco.CmdPlaySIClick(Sender: TObject);
var
   nSI : single;
   n : integer;
   LePath : string;
begin
     if uos_Getstatus(0)=-1 then
         begin
              n:=ListViewDisco.Row;
              Lepath:=ListViewDisco.Cells[11,n];
              InputIndex1 := uos_AddFromFile(0, PChar(LePath));
              uos_InputSetPositionEnable(0, InputIndex1, 1) ;
              uos_AddDSPVolumeIn(0, inputIndex1, 1, 1);
              uos_InputSetLevelEnable(0, InputIndex1, 3) ;
         end;
    nSI:= (labeltot.tag - LabelSI.Tag) / 1000;
    Playfile (0, nSI);

end;

procedure TFrmDisco.CmdMMoinsClick(Sender: TObject);
begin
      Case CmdPlayPS.Tag of
    0:begin
        LabelPS.Tag:= LabelPS.Tag + 1000;
        LabelPS.Caption:= Floattostr(LabelPS.Tag/1000);
        end;
    1:begin
           If LabelIntro.Tag <> 0 Then
               begin
                    If LabelIntro.Tag - 1000 < 0 Then LabelIntro.Tag:= 0
                    Else LabelIntro.Tag:= LabelIntro.Tag - 1000;
               end;
           LabelIntro.Caption:= Floattostr(LabelIntro.Tag/1000);

        end;
    2:begin
           If LabelEntame.Tag <> 0 Then
               begin
                    If LabelEntame.Tag - 1000 < 0 Then LabelEntame.Tag:= 0
                    Else LabelEntame.Tag:= LabelEntame.Tag - 1000;
               end;
           LabelEntame.Caption:= Floattostr(LabelEntame.Tag/1000);

        end;
    End;

CmdModif.Enabled:= true;
end;

procedure TFrmDisco.CmdMMoinsSIClick(Sender: TObject);

begin
     If LabelSI.Tag <> labeltot.tag Then
        begin
             If LabelSI.Tag + 1000 > labeltot.tag Then LabelSI.Tag:= labeltot.tag
                    Else LabelSI.Tag:= LabelSI.Tag + 1000;
        end;
           LabelSI.Caption:= Floattostr(LabelSI.Tag/1000);

CmdModif.Enabled:= true;
end;

procedure TFrmDisco.CmdModifClick(Sender: TObject);
var
  n : integer;
  nA: integer;
  nActif, nFade:integer;
  nDuree: integer;
  bDeplace:boolean;
  sql, st: string;
  bStart: boolean;
  sChemin:string;
  sFilename:string;
begin
  Screen.Cursor:= crHourglass;
  n:=listviewDisco.row;
  nA:=PtrInt(cboArtiste.Items.Objects[cboArtiste.ItemIndex]);
  bDeplace:=False;

  SQLQuery1.SQL.Clear;
  sql:='UPDATE Morceaux SET';
  bStart:= false;

  If (ChkArtiste.Checked) And (CboArtiste.ItemIndex <> -1) Then
     begin
          sql:=sql + ' NumArtiste = ' + inttostr(nA);
          ListViewDisco.Cells[2,n]:= inttostr(nA);
          ListViewDisco.Cells[3,n]:= cboArtiste.Items[cboArtiste.ItemIndex];
          bStart:=true;
     end;

  If ChkTitre.Checked then
     begin
          if bStart then sql:= sql+ ',' else bStart:=true;
          sql:= sql + ' Titre = ''' + specialstr(TextModifTitre.text) + '''';
          ListViewDisco.Cells[1,n]:=TextModifTitre.text;
     end;

  If (ChkCat.Checked) And (CboCat.itemindex<>-1) then
     begin
          if bStart then sql:= sql+ ',' else bStart:=true;
          sql:= sql + ' NumCat = ' + inttostr(cboCat.ItemIndex + 1);
          ListViewDisco.Cells[4,n]:=inttostr(cboCat.ItemIndex + 1);
          Case cboCat.ItemIndex of
               0:ListViewDisco.Cells[5,n]:='MUSIQUE';
               1:ListViewDisco.Cells[5,n]:='CAPSULE';
               2:ListViewDisco.Cells[5,n]:='JINGLE';
               3:ListViewDisco.Cells[5,n]:='INSTRU';
          end;
     end;

  If ChkAnnee.Checked then
     begin
          if bStart then sql:= sql+ ',' else bStart:=true;
          sql:= sql + ' Annee = ''' + specialstr(TextModifAnnee.Text) + '''';
          ListViewDisco.Cells[8,n]:=TextModifAnnee.Text;
     end;

  If ChkPS.Checked then
     begin
          if bStart then sql:= sql+ ',' else bStart:=true;
          sql:= sql + ' PS = ' + inttostr(LabelPS.Tag);
          ListViewDisco.Cells[15,n]:=inttostr(LabelPS.Tag);
     end;

  If ChkIntro.Checked then
     begin
          if bStart then sql:= sql+ ',' else bStart:=true;
          sql:= sql + ' Intro = ' + inttostr(LabelIntro.Tag);
          ListViewDisco.Cells[17,n]:=inttostr(LabelIntro.Tag);
     end;

  If ChkSI.Checked then
     begin
          if bStart then sql:= sql+ ',' else bStart:=true;
          sql:= sql + ' SurImpression = ' + inttostr(LabelSI.Tag);
          ListViewDisco.Cells[12,n]:=inttostr(LabelSI.Tag);
     end;

  If ChkTempo1.Checked then
     begin
          if bStart then sql:= sql+ ',' else bStart:=true;
          sql:= sql + ' Tempo1 = ' + inttostr(RadioGroup1.ItemIndex);
          ListViewDisco.Cells[13,n]:=inttostr(RadioGroup1.ItemIndex);
     end;

  If ChkTempo2.Checked then
     begin
          if bStart then sql:= sql+ ',' else bStart:=true;
          sql:= sql + ' Tempo2 = ' + inttostr(RadioGroup2.ItemIndex);
          ListViewDisco.Cells[14,n]:=inttostr(RadioGroup2.ItemIndex);
     end;

  If ChkTop.Checked then
     begin
          if bStart then sql:= sql+ ',' else bStart:=true;
          sql:= sql + ' Top = 1';
          ListViewDisco.Cells[20,n]:='1';
     end
     else
     begin
          if bStart then sql:= sql+ ',' else bStart:=true;
          sql:= sql + ' Top = 0';
          ListViewDisco.Cells[20,n]:='0';
     end;

  If ChkEntame.Checked then
     begin
          if bStart then sql:= sql+ ',' else bStart:=true;
          sql:= sql + ' Entame = ' + inttostr(LabelEntame.Tag);
          ListViewDisco.Cells[21,n]:=inttostr(LabelEntame.Tag);
     end;

  If ChkGenre.Checked and (strtoint(ListViewDisco.Cells[6,n]) <> PtrInt(cboGenre.Items.Objects[cboGenre.ItemIndex])) then
     begin
          if bStart then sql:= sql+ ',' else bStart:=true;
          sql:= sql + ' NumDossier = ' + inttostr(PtrInt(cboGenre.Items.Objects[cboGenre.ItemIndex]));
          ListViewDisco.Cells[6,n]:=inttostr(PtrInt(cboGenre.Items.Objects[cboGenre.ItemIndex]));
          ListViewDisco.Cells[7,n]:=cboGenre.Items[cboGenre.ItemIndex];
          st:=ListViewDisco.Cells[11,n];
          sFilename:=Rightstr(st, (length(st) - InstrRev(st, '/')));
          bDeplace:=true;
     end;

  Case ChkFade.Checked of
       True:nFade:=1;
       False:nFade:=0;
  end;
  if bStart then sql:= sql+ ',' else bStart:=true;
  sql:= sql + ' Fade = ' + inttostr(nFade);
  ListViewDisco.Cells[22,n]:=inttostr(nFade);

  Case ChkActif.Checked of
                 True:nActif:=1;
                 False:nActif:=0;
  end;
  if bStart then sql:= sql+ ',' else bStart:=true;
  sql:= sql + ' Actif = ' + inttostr(nActif);
  ListViewDisco.Cells[16,n]:=inttostr(nActif);

  nDuree:=Labeltot.tag;
  if bStart then sql:= sql+ ',' else bStart:=true;
  sql:= sql + ' Duree = ' + inttostr(nDuree);
  ListViewDisco.Cells[9,n]:=ConvHMS(nDuree);
  ListViewDisco.Cells[18,n]:=inttostr(nDuree);

  sql:= sql + ' WHERE Morceaux.NumFich = ' + listviewDisco.Cells[0, n] + ';';

  SQLQuery1.SQL.add(sql);
  SQLQuery1.ExecSQL;
  Form1.SQLTransaction1.CommitRetaining;
  SQLQuery1.close;

  CmdModif.Enabled:= False;
  Screen.Cursor:= 0;


  {SQLQuery1.SQL.Text := 'SELECT NumFich, NumArtiste, NumDossier, Titre, NumCat, Annee, PS, Intro, SurImpression, Tempo1, Tempo2, Actif, Duree, Filename, Top, Entame, Fade FROM Morceaux WHERE Morceaux.NumFich = ' + listviewDisco.Cells[0, n] + ';';
  SQLQuery1.Open;

     If not SQLQuery1.EOF then
       begin
           SQLQuery1.Edit;
           If (ChkArtiste.Checked) And (CboArtiste.ItemIndex <> -1) Then
             begin
                  SQLQuery1.FieldByName('NumArtiste').AsInteger:=nA;
                  ListViewDisco.Cells[2,n]:= inttostr(nA);
                  ListViewDisco.Cells[3,n]:= cboArtiste.Items[cboArtiste.ItemIndex];
             end;

           If ChkTitre.Checked then
             begin
                  SQLQuery1.FieldByName('Titre').AsString:=TextModifTitre.text;
                  ListViewDisco.Cells[1,n]:=TextModifTitre.text;
             end;

           If (ChkCat.Checked) And (CboCat.itemindex<>-1) then
             begin
                  SQLQuery1.FieldByName('NumCat').asInteger:=cboCat.ItemIndex + 1;
                  ListViewDisco.Cells[4,n]:=inttostr(cboCat.ItemIndex + 1);
                  Case cboCat.ItemIndex of
                       0:ListViewDisco.Cells[5,n]:='MUSIQUE';
                       1:ListViewDisco.Cells[5,n]:='CAPSULE';
                       2:ListViewDisco.Cells[5,n]:='JINGLE';
                       3:ListViewDisco.Cells[5,n]:='INSTRU';
                  end;
             end;

            //FrmDisco.ListViewDisco.Cells[6,i]:=FrmDisco.SQLQuery1.Fields[6].AsString; //NumGenre
            //FrmDisco.ListViewDisco.Cells[7,i]:='Genre'; //NomGenre  5

            If ChkAnnee.Checked then
             begin
                  SQLQuery1.FieldByName('Annee').asString:=TextModifAnnee.Text;
                  ListViewDisco.Cells[8,n]:=TextModifAnnee.Text;
             end;

            If ChkPS.Checked then
             begin
                  SQLQuery1.FieldByName('PS').asInteger:=LabelPS.Tag;
                  ListViewDisco.Cells[15,n]:=inttostr(LabelPS.Tag);
             end;

            If ChkIntro.Checked then
             begin
                  SQLQuery1.FieldByName('Intro').asInteger:=LabelIntro.Tag;
                  ListViewDisco.Cells[17,n]:=inttostr(LabelIntro.Tag);
             end;

            If ChkSI.Checked then
             begin
                  SQLQuery1.FieldByName('SurImpression').asInteger:=LabelSI.Tag;
                  ListViewDisco.Cells[12,n]:=inttostr(LabelSI.Tag);
             end;

            If ChkTempo1.Checked then
             begin
                  SQLQuery1.FieldByName('Tempo1').asInteger:=RadioGroup1.ItemIndex;
                  ListViewDisco.Cells[13,n]:=inttostr(RadioGroup1.ItemIndex);
             end;

            If ChkTempo2.Checked then
             begin
                  SQLQuery1.FieldByName('Tempo2').asInteger:=RadioGroup2.ItemIndex;
                  ListViewDisco.Cells[14,n]:=inttostr(RadioGroup2.ItemIndex);
             end;

            If ChkTop.Checked then
             begin
                  SQLQuery1.FieldByName('Top').asInteger:=1;
                  ListViewDisco.Cells[20,n]:='1';
             end
            else
                begin
                   SQLQuery1.FieldByName('Top').asInteger:=0;
                   ListViewDisco.Cells[20,n]:='0';
                end;

            If ChkEntame.Checked then
             begin
                  SQLQuery1.FieldByName('Entame').asInteger:=LabelEntame.Tag;
                  ListViewDisco.Cells[21,n]:=inttostr(LabelEntame.Tag);
             end;

            If ChkGenre.Checked and (strtoint(ListViewDisco.Cells[6,n]) <> PtrInt(cboGenre.Items.Objects[cboGenre.ItemIndex])) then
             begin
                  SQLQuery1.FieldByName('NumDossier').asInteger:=PtrInt(cboGenre.Items.Objects[cboGenre.ItemIndex]);
                  ListViewDisco.Cells[6,n]:=inttostr(PtrInt(cboGenre.Items.Objects[cboGenre.ItemIndex]));
                  ListViewDisco.Cells[7,n]:=cboGenre.Items[cboGenre.ItemIndex];
                  sFilename:=SQLQuery1.FieldByName('Filename').AsString;
                  bDeplace:=true;
             end;

            Case ChkFade.Checked of
                 True:nFade:=1;
                 False:nFade:=0;
            end;
            SQLQuery1.FieldByName('Fade').asInteger:=nFade;
            ListViewDisco.Cells[22,n]:=inttostr(nFade);

            Case ChkActif.Checked of
                 True:nActif:=1;
                 False:nActif:=0;
            end;
            SQLQuery1.FieldByName('Actif').asInteger:=nActif;
            ListViewDisco.Cells[16,n]:=inttostr(nActif);
            showmessage('Actif = ' + inttostr(nActif));

            nDuree:=Labeltot.tag;
            SQLQuery1.FieldByName('Duree').asInteger:=nDuree;
            ListViewDisco.Cells[9,n]:=ConvHMS(nDuree);
            ListViewDisco.Cells[18,n]:=inttostr(nDuree);



           SQLQuery1.Post;
           SQLQuery1.ApplyUpdates;
           SQLQuery1.Close;

           CmdModif.Enabled:= False;
           Screen.Cursor:= 0;
       end;  }


  If bDeplace then
   begin
      SQLQuery1.SQL.Text := 'SELECT chemin FROM Dossiers WHERE NumDossier = ' + inttostr(PtrInt(cboGenre.Items.Objects[cboGenre.ItemIndex])) + ';';
      SQLQuery1.Open;
      If not SQLQuery1.EOF then sChemin:=SQLQuery1.FieldByName('chemin').AsString;
      If RenameFile(ListViewDisco.Cells[11,n],sChemin + '/' + sFilename) then ListViewDisco.Cells[11,n]:=sChemin+'/'+ sFilename;
      SQLQuery1.Close;
   end;

  If ChkPays.Checked and (TextModifPays.Caption<>ListViewDisco.Cells[19,n]) then
     begin
        SQLQuery1.SQL.Text := 'SELECT * FROM Artistes WHERE NumArtiste = ' + inttostr(nA) + ';';
        SQLQuery1.Open;
        If not SQLQuery1.EOF then
           begin
              SQLQuery1.Edit;
              SQLQuery1.FieldByName('Pays').asString:=TextModifPays.Caption;
           end;
        SQLQuery1.Post;
        SQLQuery1.ApplyUpdates;
        SQLQuery1.Close;
        for n:= 1 to ListViewDisco.RowCount - 1 do
            if ListViewDisco.Cells[2,n]=inttostr(nA) then ListViewDisco.Cells[19,n]:=TextModifPays.Caption;
     end;

  Form1.SQLTransaction1.CommitRetaining;
  screen.Cursor:=crDefault;

end;

procedure TFrmDisco.CmdIntroClick(Sender: TObject);
var
  nIntro: single;
  p: integer;
begin
     //p:=CmdPlay.tag;
     //If p<>-1 then
     CmdPlayPS.Tag:= 1;
     CmdPaint(1);
        If uos_Getstatus(0)<>-1 Then
           begin

                nIntro:= uos_InputPositionSeconds(0, InputIndex1);
                LabelIntro.Tag:= trunc(nIntro * 1000);
                LabelIntro.Caption:= floattostr(labelIntro.tag/1000);
                CmdModif.Enabled:= True;
           end;


end;

procedure TFrmDisco.ChkActifChange(Sender: TObject);
begin
Case ChkActif.State Of
   cbChecked:
     begin
        ChkActif.Font.Color:= $004FE6BE; //'BEE64F;
        ChkActif.Caption:= 'ACTIF';
     end;
   cbunchecked:
     begin
          ChkActif.Font.Color:= $002700D8; //5564EB; //#EB6455;
          ChkActif.Caption:= 'INACTIF';
     end;
   cbGrayed:showmessage('gray');
end;
CmdModif.Enabled:= True;
end;

procedure TFrmDisco.ChkActifClick(Sender: TObject);
begin

end;

procedure TFrmDisco.ChkPaysChange(Sender: TObject);
begin
  CmdModif.Enabled:=true;
end;

procedure TFrmDisco.ChkTempo1Change(Sender: TObject);
begin

end;





procedure TFrmDisco.CmdEffacerClick(Sender: TObject);
var
 i, n : integer;
 r: Word;
 sTitre: string;
 sChemin: string;
 st, sFilename: string;
 inifile: Tinifile;
begin
n:=ListViewDisco.row;
sTitre:=ListViewDisco.Cells[1, n];
i:= strtoint(ListViewDisco.Cells[0, n]);
r:= MessageDlg('Êtes-vous sûr de vouloir supprimer ' + sTitre + ' de la base ?', mtWarning, [mbYes, mbNo, mbAbort],0);

inifile:= TIniFile.Create('JBox.ini');
sChemin:=inifile.ReadString('Corbeille','chemin','');
st:=ListViewDisco.Cells[11,n];
sFilename:=Rightstr(st, (length(st) - InstrRev(st, '/')));
If r = mrYes Then
   begin
   If sChemin <> '' then
      If RenameFile(ListViewDisco.Cells[11,n],sChemin + '/' + sFilename) then
         begin
              SQLQuery1.SQL.Clear;
              SQLQuery1.SQL.add('DELETE FROM Morceaux WHERE NumFich = ' + inttostr(i) + ';');
              SQLQuery1.ExecSQL;
              Form1.SQLTransaction1.CommitRetaining;
              SQLQuery1.close;
              //DiscoRefresh('Morceaux.NumFich');
              ListViewDisco.DeleteRow(n);
              //Listviewdisco.Row:=i-1;

         end
      else Showmessage('Impossible. Un dossier pour la corbeille n''a pas encore été défini !');
   end;

end;

procedure TFrmDisco.CmdHoraireClick(Sender: TObject);
var
  sNouvHoraire : String;
  n, nOffset: integer;
  i : integer;
begin
  sNouvHoraire:= TextHoraire.text;
  n:=strtoint(listviewDisco.Cells[0, listviewdisco.Row]);
     SQLQuery1.close;
  SQLQuery1.SQL.text:= 'INSERT INTO Tops (Num, Numtop, Horaire) VALUES ((SELECT MAX(Num) FROM Tops) + 1, ' + inttostr(n) + ', ''' + sNouvHoraire + ''');';
  SQLQuery1.ExecSQL;
  Form1.SQLTransaction1.CommitRetaining;
  SQLQuery1.close;

  RefreshHoraire(n);
  TextHoraire.Text:='';
  Application.ProcessMessages;

end;



procedure TFrmDisco.CmdModifArtisteClick(Sender: TObject);
var
  sArtiste : String;
  nArtiste: integer;
  i : integer;
  r: word;
  sql: string;
begin
     sArtiste:= cboArtiste.Items[cboartiste.ItemIndex];
     nArtiste:= PtrInt(cboArtiste.Items.Objects[cboArtiste.ItemIndex]);
     sql:='SELECT NomArtiste FROM Artistes WHERE Numartiste = ' + inttostr(nArtiste) + ';';
     SQLQuery1.SQL.text:= sql;
     SQLQuery1.open;
     sArtiste:=InputBox('ARTISTE','Veuillez modifier l''intitulé du nom de l''artiste :', sArtiste);
     SQLQuery1.Edit;
     SQLQuery1.FieldByName('NomArtiste').AsString:=Trim(sArtiste);
     SQLQuery1.Post;
     SQLQuery1.ApplyUpdates;
     SQLQuery1.close;
     cboArtiste.Items[cboartiste.ItemIndex]:=Trim(sArtiste);

  For i:=1 to ListViewdisco.RowCount -1 do
        If Listviewdisco.Cells[2,i]=inttostr(nArtiste) then Listviewdisco.Cells[3,i]:=Trim(sArtiste);

end;

procedure TFrmDisco.ChkTopChange(Sender: TObject);
begin
  CmdModif.Enabled:= true;

  If chkTop.Checked = true then
     begin
        TextHoraire.Visible:=true;
        ListHoraires.Visible:=true;
        CmdHoraire.Visible:=true;
        CmdSuppHoraire.Visible:=true;
        //Image1.Top:=470;
        //Image1.Left:=864;
        //Image1.Height:=66;
        //Image1.Width:=66;
        Image1.Top:=404;
        Image1.Left:=1000;
        Image1.Height:=128;
        Image1.Width:=128;
     end
  else
      begin
        TextHoraire.Visible:=false;
        ListHoraires.Visible:=false;
        CmdHoraire.Visible:=false;
        CmdSuppHoraire.Visible:=false;
        Image1.Top:=404;
        Image1.Left:=1000;
        Image1.Height:=128;
        Image1.Width:=128;
     end;
end;

procedure TFrmDisco.ChkFadeChange(Sender: TObject);
begin

end;

procedure TFrmDisco.ChkFadeClick(Sender: TObject);
begin
  Case ChkFade.State Of
   cbChecked:
     begin
        ChkFade.Font.Color:= $004FE6BE; //'BEE64F;
        ChkFade.Caption:= 'Forcer le FADE';
     end;
   cbunchecked:
     begin
          ChkFade.Font.Color:= $002700D8; //5564EB; //#EB6455;
          ChkFade.Caption:= 'Pas de FADE';
     end;
   cbGrayed:showmessage('gray');
end;
CmdModif.Enabled:= True;
end;

procedure TFrmDisco.CmdEntameClick(Sender: TObject);
var
  nEntame: single;
  p: integer;
begin
     //p:=CmdPlay.tag;
     //If p<>-1 then
     CmdPlayPS.Tag:= 2;
     CmdPaint(2);

        If uos_Getstatus(0)<>-1 Then
           begin

                nEntame:= uos_InputPositionSeconds(0, InputIndex1);
                LabelEntame.Tag:= trunc(nEntame * 1000);
                LabelEntame.Caption:= floattostr(labelEntame.tag/1000);
                CmdModif.Enabled:= True;
           end;


end;

procedure TFrmDisco.CmdJoueClick(Sender: TObject);
var
   n : integer;
   LePath : string;
   samformat: shortint;
   temptime: ttime;
   ho, mi, se, ms: word;
begin
     n:=ListViewDisco.Row;
     Lepath:=ListViewDisco.Cells[11,n];

     uos_stop(0);
     uos_CreatePlayer(0); /// you may create how many players you want, from 0 to to what you computer can do...
     uos_AddIntoDevOut(0);   //// Add Output with default parameter
     InputIndex1 := uos_AddFromFile(0, PChar(LePath));
     uos_InputSetPositionEnable(0, InputIndex1, 1) ;
     uos_AddDSPVolumeIn(0, inputIndex1, 1, 1);
     uos_InputSetLevelEnable(0, InputIndex1, 3) ;

     temptime:= uos_InputLengthTime(0, inputIndex1 );
     DecodeTime(temptime, ho, mi, se, ms);
     labeltot.tag:= integer(mi + 1000*se + 60000*mi + 3600000*ho);
     LabelTOT.caption:= format('%.2d:%.2d:%.2d.%.3d', [ho, mi, se, ms]);

     Playfile (0, 0);
end;

procedure TFrmDisco.cboArtisteClick(Sender: TObject);
var
  na: integer;
begin
    CmdModif.Enabled:=true;

    nA:=PtrInt(cboArtiste.Items.Objects[cboArtiste.ItemIndex]);
    SQLQuery1.SQL.Text := 'SELECT * FROM Artistes WHERE NumArtiste = ' + inttostr(nA) + ';';
    SQLQuery1.Open;
    If not SQLQuery1.EOF then TextModifPays.Text:= SQLQuery1.FieldByName('Pays').asString;
    SQLQuery1.Close;
end;




procedure TFrmDisco.CboCatChange(Sender: TObject);
begin
  CmdModif.Enabled:=true;
end;

procedure TFrmDisco.CboGenreChange(Sender: TObject);
begin
     CmdModif.Enabled:=true;
end;

procedure TFrmDisco.CmdPlayPSClick(Sender: TObject);
var
   nPS : single;
   n : integer;
   LePath : string;
   //p:integer;
begin
     if uos_Getstatus(0)=-1 then
         begin
              n:=ListViewDisco.Row;
              Lepath:=ListViewDisco.Cells[11,n];
              //p:=ChargePlayer(Lepath);
              InputIndex1 := uos_AddFromFile(0, PChar(LePath));
              uos_InputSetPositionEnable(0, InputIndex1, 1) ;
              uos_AddDSPVolumeIn(0, inputIndex1, 1, 1);
              uos_InputSetLevelEnable(0, InputIndex1, 3) ;
         end;
    nPS:= (labeltot.tag - LabelPS.Tag) / 1000;
    CmdPlayPS.Tag:= 0;
    CmdPaint (0);


    Playfile (0, nPS);
end;

procedure TFrmDisco.CmdPPlusClick(Sender: TObject);
begin
    Case CmdPlayPS.Tag of
  1:begin
      LabelIntro.Tag:= LabelIntro.Tag + 1000;
      LabelIntro.Caption:= Floattostr(LabelIntro.Tag/1000);
      end;
  2:begin
      LabelEntame.Tag:= LabelEntame.Tag + 1000;
      LabelEntame.Caption:= Floattostr(LabelEntame.Tag/1000);
      end;
  0:begin
         If LabelPS.Tag <> 0 Then
             begin
                  If LabelPS.Tag - 1000 < 0 Then LabelPS.Tag:= 0
                  Else LabelPS.Tag:= LabelPS.Tag - 1000;
             end;
         LabelPS.Caption:= Floattostr(LabelPS.Tag/1000);

      end;
  End;

CmdModif.Enabled:= true;
end;

procedure TFrmDisco.CmdPSClick(Sender: TObject);
var
   nPS : single;
   npos : single;
   //p: integer;
begin
     //p:=CmdPlay.tag;
     //If p<>-1 then
        If uos_Getstatus(0)= 1 Then
           begin
                CmdPlayPS.Tag:= 0;
                CmdPaint(0);
                nPos:= uos_InputPositionSeconds(0, InputIndex1);
                nPS:= (Labeltot.tag/1000) - nPos;
                LabelPS.Tag:= trunc(nPS * 1000);
                LabelPS.Caption:= floattostr(labelPS.tag/1000);
                CmdModif.Enabled:= True;
           end;
end;

procedure TFrmDisco.CmdRechInitClick(Sender: TObject);
begin
    textartiste.Text:='';
    texttitre.Text:='';
    textannee.Text:='';
    textpays.Text:='';
    DiscoRefresh('Morceaux.numfich');

end;

procedure TFrmDisco.CmdSIClick(Sender: TObject);
var
   nSI : single;
   npos : single;

begin
        If uos_Getstatus(0)= 1 Then
           begin
                nPos:= uos_InputPositionSeconds(0, InputIndex1);
                nSI:= (Labeltot.tag/1000) - nPos;
                LabelSI.Tag:= trunc(nSI * 1000);
                LabelSI.Caption:= floattostr(labelSI.tag/1000);
                CmdModif.Enabled:= True;
           end;
end;

procedure TFrmDisco.CmdSIResetClick(Sender: TObject);
begin
  labelsi.Tag:=0;
  labelsi.Caption:='0';
  cmdmodif.enabled:=true;
end;

procedure TFrmDisco.CmdStopClick(Sender: TObject);
begin
  uos_stop(0);
end;


procedure TFrmDisco.CmdSuppArtisteClick(Sender: TObject);
var
  sArtiste : String;
  nArtiste: integer;
  i : integer;
  r: word;
  sql: string;
begin
     sArtiste:= cboArtiste.Items[cboartiste.ItemIndex];
     nArtiste:= PtrInt(cboArtiste.Items.Objects[cboArtiste.ItemIndex]);
     sql:='SELECT NumFich FROM Morceaux WHERE Numartiste = ' + inttostr(nArtiste) + ';';
     SQLQuery1.SQL.text:= sql;
     SQLQuery1.open;
  case SQLQuery1.eof of
    true:r:= MessageDlg('Êtes-vous sûr de vouloir supprimer ' + sArtiste + ' de la base ? (aucun morceau référencé)', mtWarning, [mbYes, mbNo, mbAbort],0);
    false:r:= MessageDlg('Êtes-vous sûr de vouloir supprimer ' + sArtiste + ' AINSI QUE les morceaux associés de la base ?', mtWarning, [mbYes, mbNo, mbAbort],0);
  end;
  SQLQuery1.close;

  If r = mrYes Then
     begin
        SQLQuery1.SQL.Clear;
        SQLQuery1.SQL.add('DELETE FROM Morceaux WHERE NumArtiste = ' + inttostr(nArtiste) + ';');
        SQLQuery1.ExecSQL;
        Form1.SQLTransaction1.CommitRetaining;
        SQLQuery1.close;

        SQLQuery1.SQL.Clear;
        SQLQuery1.SQL.add('DELETE FROM Artistes WHERE NumArtiste = ' + inttostr(nArtiste) + ';');
        SQLQuery1.ExecSQL;
        Form1.SQLTransaction1.CommitRetaining;
        SQLQuery1.close;

        i:= ListViewdisco.RowCount -1;
        While i > 0 do
          begin
             If Listviewdisco.Cells[2,i]=inttostr(nArtiste) then Listviewdisco.DeleteRow(i);
             i:=i-1;
          end;
        cboartiste.Items.Delete(cboartiste.itemindex);
        //DiscoRefresh('Morceaux.NumFich');
        //RefreshArtiste;
        TextModifArtiste.Text:='';
     end;
end;

procedure TFrmDisco.CmdSuppHoraireClick(Sender: TObject);
var
 r: Word;
 sHoraire: string;
begin
If ListHoraires.ItemIndex = -1 then exit;
sHoraire:=ListHoraires.Items[ListHoraires.ItemIndex];
r:= MessageDlg('Êtes-vous sûr de vouloir supprimer l''horaire ' + sHoraire + ' de l''élément ' + TextModifTitre.Text + ' ?', mtWarning, [mbYes, mbNo, mbAbort],0);
If r = mrYes Then
   begin
   SQLQuery1.SQL.Clear;
   SQLQuery1.SQL.add('DELETE FROM Tops WHERE Num = ' + inttostr(PtrInt(ListHoraires.Items.Objects[ListHoraires.ItemIndex])) + ';');
   SQLQuery1.ExecSQL;
   Form1.SQLTransaction1.CommitRetaining;
   SQLQuery1.close;
   ListHoraires.Items.Delete(ListHoraires.ItemIndex);
   end;
end;



procedure TFrmDisco.ComboCatClick(Sender: TObject);
begin
     DiscoRefresh ('Artistes.nomArtiste');
end;

procedure TFrmDisco.ComboFiltreChange(Sender: TObject);
begin
     DiscoRefresh ('Artistes.nomArtiste');
end;

procedure TFrmDisco.ComboGenreChange(Sender: TObject);
begin
  DiscoRefresh ('Artistes.nomArtiste');
end;

procedure TFrmDisco.ComboGenreClick(Sender: TObject);
begin
   DiscoRefresh ('Artistes.nomArtiste');
end;

procedure TFrmDisco.FormActivate(Sender: TObject);
begin
refreshArtiste;
refreshGenre;

DiscoRefresh('Morceaux.numfich');
end;



procedure TFrmDisco.ShowPosition;
var
  p: integer;
  temptime: ttime;
  ho, mi, se, ms: word;
begin
    //p:=CmdPlay.tag;
    If uos_Getstatus(0)= 1 then
       begin
          temptime := uos_InputPositionTime(0, InputIndex1);
          ////// Length of input in time
          DecodeTime(temptime, ho, mi, se, ms);
          FrmDisco.Caption := format('%.2d:%.2d:%.2d.%.3d', [ho, mi, se, ms]);
          //form1.TrackBar2.Position := uos_InputPosition(PlayerIndex1, InputIndex1);
       end;

 end;




end.

