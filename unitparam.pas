unit UnitParam;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqlite3conn, sqldb, FileUtil, Forms, Controls,
  Graphics, Dialogs, StdCtrls, Spin, ComCtrls, Grids, Buttons, ValEdit,
  CheckLst, ExtCtrls, inifiles, StrUtils;

type

  { TFrmParam }

  TFrmParam = class(TForm)
    CmdCorbeille: TButton;
    ComboInstru: TListBox;
    ChkTous: TButton;
    ChkAucun: TButton;
    Chktransition: TCheckBox;
    LabelInstru: TLabel;
    LstTransition: TStringGrid;
    ChkOrdre: TCheckBox;
    CmdBase: TButton;
    CmdPochette: TButton;
    CmdSupp: TButton;
    CmdVerif: TButton;
    CheckVerif: TCheckBox;
    ChkAutoPlay: TCheckBox;
    ChkRetardateur: TCheckBox;
    CmdAjout: TButton;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    LabelGenre: TLabel;
    LabelCounter: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    LabelSpinInter: TLabel;
    LabelMinutes: TLabel;
    ListDossiers: TStringGrid;
    ProgressBar1: TProgressBar;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SpinEcartJC: TSpinEdit;
    SpinSelect: TSpinEdit;
    TextEcartArtH: TSpinEdit;
    TextEcartArtM: TSpinEdit;
    TextEcartGenreH: TSpinEdit;
    TextEcartGenreM: TSpinEdit;
    TextEcartGenreJ: TSpinEdit;
    TextEcartTitM: TSpinEdit;
    TextEcartTitJ: TSpinEdit;
    SpinINTER: TSpinEdit;
    SQLite3Connection1: TSQLite3Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    Label2: TLabel;
    SpinPS: TFloatSpinEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    SpinVol: TSpinEdit;
    TabControl1: TTabControl;
    TextEcartArtJ: TSpinEdit;
    TextEcartTitH: TSpinEdit;
    TextInstru: TLabeledEdit;
    TextRetard: TEdit;
    procedure ChkAucunClick(Sender: TObject);
    procedure ChkRetardateurChange(Sender: TObject);
    procedure ChkTousClick(Sender: TObject);
    procedure ChktransitionChange(Sender: TObject);
    procedure CmdAjoutClick(Sender: TObject);
    procedure CmdBaseClick(Sender: TObject);
    procedure CmdCorbeilleClick(Sender: TObject);
    procedure CmdPochetteClick(Sender: TObject);
    procedure CmdSuppClick(Sender: TObject);
    procedure CmdVerifClick(Sender: TObject);
    procedure ComboInstruClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListDossiersBeforeSelection(Sender: TObject; aCol, aRow: Integer);
    procedure ListDossiersSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure ListDossiersSelection(Sender: TObject; aCol, aRow: Integer);
    procedure LstTransitionClick(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure TabControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure TextEcartArtHExit(Sender: TObject);
    procedure TextEcartArtJExit(Sender: TObject);
    procedure TextEcartArtMExit(Sender: TObject);
    procedure TextEcartGenreHExit(Sender: TObject);
    procedure TextEcartGenreJExit(Sender: TObject);
    procedure TextEcartGenreMExit(Sender: TObject);
    procedure TextEcartTitHExit(Sender: TObject);
    procedure TextEcartTitJExit(Sender: TObject);
    procedure TextEcartTitMExit(Sender: TObject);
    procedure TextInstruChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FrmParam: TFrmParam;

implementation

uses
  unit1, unitson, unitsearch;
{$R *.lfm}

{ TFrmParam }

Function searchGenre(nDossier: integer):integer;
begin
     FrmParam.SQLQuery1.SQL.Clear;
     FrmParam.SQLQuery1.SQL.text:='SELECT NumGenre FROM Dossiers WHERE NumDossier = '+inttostr(nDossier)+';';
     FrmParam.SQLQuery1.Open;
     If not FrmParam.SQLQuery1.RecordCount >0 then
       Result:=FrmParam.SQLQuery1.ParamByName('NumGenre').AsInteger
     else
       Result:=0;
     FrmParam.SQLQuery1.close;
end;

Function searchDossier(sCheminCourt : string):integer;
var
   bDossierExiste : boolean;
   i, nDossier: PtrInt;   //
begin
      // Vérification de l'existence du dossier
       bDossierExiste:=false;
       For i:=2 to FrmParam.ListDossiers.RowCount do
           if FrmParam.ListDossiers.cells[i,1] = sCheminCourt then
              begin
                bDossierExiste:=True;
                nDossier:=strtoint(FrmParam.ListDossiers.cells[i,3]);
                break;
              end;

        If not bDossierExiste then
           begin
             FrmParam.SQLQuery1.SQL.Clear;
             FrmParam.SQLQuery1.SQL.text:='INSERT INTO Dossiers (NumDossier, Chemin, NumCat, NomGenre) VALUES ((SELECT MAX(NumDossier) FROM Dossiers) + 1, :chemin, 0, :genre);';
             FrmParam.SQLQuery1.ParamByName('chemin').AsString:=sCheminCourt;
             FrmParam.SQLQuery1.ParamByName('genre').AsString:='Genre';
             FrmParam.SQLQuery1.ExecSQL;
             Form1.SQLTransaction1.CommitRetaining;
             If FrmParam.ListDossiers.RowCount > 1 then
                nDossier:=strtoint(FrmParam.ListDossiers.cells[FrmParam.ListDossiers.RowCount,3]) + 1
             else
                 nDossier:=1; ///FAUX !!!
             i:=FrmParam.ListDossiers.RowCount+1;
             FrmParam.ListDossiers.RowCount:=i;
             FrmParam.ListDossiers.cells[i,0]:='Genre';
             FrmParam.ListDossiers.cells[i,1]:=sChemincourt;
             FrmParam.ListDossiers.cells[i,2]:=inttostr(nDossier);
             FrmParam.SQLQuery1.close;
           end;
end;

Function InfoMP3(sFile : string; sNomFich : string; sChemin : string; sExt: string):boolean;
var
   sql: string;
   sCheminCourt, sNomGenre: string;
   Ledossier, Lepath: string;
   bExiste, bArtistExiste, bDossierExiste : boolean;
   sArtiste : String;
   sTitre: string;
   nArtiste, nCat : integer;
   sA: string;
   lst: TStringList;
   i, nDossier: PtrInt;
   nSI: integer;
begin
     //avant tout, vérification si le fichier est déjà dans la base ou non. S'il y est, on passe.
  lst:= Tstringlist.Create;
  sCheminCourt:=LeftStr(sChemin, Length(sChemin) -1);
  try
     Case FrmParam.TabControl1.TabIndex of
       0:begin
          nCat:=1;
          sA := Leftstr(sNomFich, length(sNomfich)-Length(sExt));
          lst.Delimiter:='/';
          lst.StrictDelimiter:=true;
          sA:=stringreplace(sA, ' - ', '/', [rfReplaceAll]);
          lst.delimitedtext:=sA;
          sArtiste:=trim(lst.Strings[0]);
          If lst.Count>1 then sTitre:=trim(lst.Strings[1]);
          nsI:=0;
          end;
       1:begin
          nCat:=2;
          sTitre:=Leftstr(sNomFich, length(sNomfich)-Length(sExt));
          sArtiste:=Rightstr(sCheminCourt, length(sChemincourt) - RPos('/', sCheminCourt));
          nSI:=40000;
          end;
       2:begin
          nCat:=3;
          sTitre:=Leftstr(sNomFich, length(sNomfich)-Length(sExt));
          sArtiste:=Rightstr(sCheminCourt, length(sChemincourt) - RPos('/', sCheminCourt));
          nSI:=0;
          end;
       end;

     bExiste:= false;
     bArtistExiste:=false;


   {If (Pos('''', sFile)<>0) Or (Pos('#', sFile)<>0) Then
      begin
        //showmessage ('Mode manuel pour ' + sChemincourt + ' ' + sNomFich);
        sql:= 'SELECT * FROM Morceaux ORDER BY NumFich;';
        FrmParam.SQLQuery1.SQL.Text:= sql;
        FrmParam.SQLQuery1.Open;
        If FrmParam.SQLQuery1.EOF then showmessage('eof');
        While Not FrmParam.SQLQuery1.EOF do
            begin
                 //If (FrmParam.SQLQuery1.FieldByName('Filename').AsString = sNomFich) then showmessage(sNomFich + ' OK');
                 //If (FrmParam.SQLQuery1.FieldByName('Chemin').AsString = sCheminCourt) then showMessage(sChemincourt + ' OK');
                //If (FrmParam.SQLQuery1.FieldByName('Filename').AsString = sNomFich) And (FrmParam.SQLQuery1.FieldByName('Chemin').AsString = sCheminCourt) Then
                 begin
                      //showmessage(sNomfich + ' existe');
                      bExiste:=true;
                      break;
                 end;
              FrmParam.SQLQuery1.Next;
            end;
        FrmParam.SQLQuery1.Close;
      End
    Else
        begin}
             //showmessage('mode auto' + snomfich);
           sql:= 'SELECT * FROM Morceaux, Dossiers WHERE Morceaux.NumDossier = Dossiers.NumDossier AND Morceaux.Filename = ''' + specialstr(sNomFich) + ''' And Dossiers.Chemin = ''' + specialstr(sCheminCourt) + ''';';
           FrmParam.SQLQuery1.SQL.Text:= sql;
           FrmParam.SQLQuery1.Open;
           If FrmParam.SQLQuery1.RecordCount <> 0 Then
              bExiste:=true;
           FrmParam.SQLQuery1.Close;
       // End;


  //If bExiste then showmessage('pas besoin de créer ' + snomfich);

  // vérif si le fichier n'est pas ailleurs (déplacé)
  If not bExiste then
     begin
       showmessage(specialstr(sNomFich)+' pas dans '+specialstr(sCheminCourt));
        sql:= 'SELECT Morceaux.numdossier, Morceaux.numgenre, Dossiers.chemin FROM Morceaux, Dossiers WHERE Morceaux.NumDossier = Dossiers.NumDossier AND Morceaux.Filename = ''' + specialstr(sNomFich) + ''';';
           FrmParam.SQLQuery1.SQL.Text:= sql;
           FrmParam.SQLQuery1.Open;
           If FrmParam.SQLQuery1.RecordCount <> 0 Then
              begin
                   Ledossier:=FrmParam.SQLQuery1.ParamByName('chemin').AsString;
                   Lepath:=  Ledossier +'/'+ specialstr(sNomFich);
                   // si fichier est dans un autre dossier
                   showmessage(specialstr(sNomFich)+' déjà dans '+specialstr(Ledossier)+' '+specialstr(Lepath));
                   If fileexists(Lepath) then
                   begin
                        If Messagedlg('Ce fichier existe déjà.','Le fichier '+specialstr(sNomFich)+' est déjà présent dans le dossier '+Ledossier+', voulez-vous l''ajouter quand même dans '+sChemincourt+' ?',mtconfirmation,[mbYes, mbNo, mbIgnore],0) = mrYes then
                          bExiste:=false
                        else
                          bExiste:=true;

                   end
                 else
                     // s'il n'est plus dans l'autre dossier, il a peut-être été déplacé. Dans ce cas, change-t-on le répertoire ?
                     begin
                         If Messagedlg('Ce fichier a peut-être été déplacé.','Le fichier '+specialstr(sNomFich)+' a disparu du dossier '+Ledossier+', a-t-il été déplacé dans '+sChemincourt+' et doit-on le mettre dans '+inttostr(searchGenre(nDossier))+' ?',mtconfirmation,[mbYes, mbNo, mbIgnore],0) = mrYes then
                            begin
                                 nDossier:=searchDossier(sCheminCourt);
                                 FrmParam.SQLQuery1.Edit;
                                 FrmParam.SQLQuery1.FieldByName('numdossier').AsInteger:=nDossier;
                                 FrmParam.SQLQuery1.FieldByName('numgenre').AsInteger:=searchGenre(nDossier);
                                 showmessage('mis dans le genre n°' + inttostr( searchGenre(nDossier)));
                                 FrmParam.SQLQuery1.Post;
                                 FrmParam.SQLQuery1.ApplyUpdates;
                            end;
                     end;
              end;

           FrmParam.SQLQuery1.Close;
     end;

  If not bExiste then
     begin
       showmessage(sNomFich + ' existe pas');     //
       //FrmParam.ListBox1.Items.Add(sNomFich);
       //Artiste existe ? si non, création
       {If (Pos('''', sArtiste)<>0) Or (Pos('#', sArtiste)<>0) Then
          begin
            sql:= 'SELECT NumArtiste, NomArtiste FROM Artistes ORDER BY NumArtiste;';
            FrmParam.SQLQuery1.SQL.Text:= sql;
            FrmParam.SQLQuery1.Open;
            While Not FrmParam.SQLQuery1.EOF do
            begin
              If UpperCase(FrmParam.SQLQuery1.FieldByName('NomArtiste').AsString) = UpperCase(Leftstr(sArtiste, 50)) Then
                 begin
                  bArtistExiste:=true;
                  break;
                 end;
              FrmParam.SQLQuery1.Next;
            end;

            If not bArtistExiste then
               begin
                    showmessage(sArtiste + ' existe pas');//
                  FrmParam.SQLQuery1.Insert;
                  FrmParam.SQLQuery1.FieldByName('NomArtiste').AsString:=Leftstr(sArtiste, 50);
                  FrmParam.SQLQuery1.Post;
                  nArtiste:=FrmParam.SQLQuery1.FieldByName('NumArtiste').Asinteger;
                  FrmParam.SQLQuery1.ApplyUpdates;
               end;
            FrmParam.SQLQuery1.close;
            Form1.SQLTransaction1.CommitRetaining;
          end
       else
           begin}
               //sql:= 'SELECT NumArtiste, NomArtiste FROM Artistes WHERE UPPER(NomArtiste) = ''' + UpperCase(Leftstr(sArtiste, 50)) + ''';';
               sql:= 'SELECT NumArtiste, NomArtiste FROM Artistes WHERE UPPER(NomArtiste) = :artiste;';
               FrmParam.SQLQuery1.SQL.Text:= sql;
               FrmParam.SQLQuery1.ParamByName('artiste').AsString := UpperCase(Leftstr(sArtiste, 50));
               FrmParam.SQLQuery1.Open;
               If FrmParam.SQLQuery1.RecordCount <> 0 Then
                  begin
                       bArtistExiste:=true;
                       nArtiste:= FrmParam.SQLQuery1.FieldByName('NumArtiste').AsInteger;
                  end;
                  FrmParam.SQLQuery1.Close;

               If not bArtistExiste then
                  begin
                       showmessage(':' + sArtiste + ':artiste existe pas');//
                   FrmParam.SQLQuery1.SQL.Clear;
                   //FrmParam.SQLQuery1.SQL.Text:= 'INSERT INTO Artistes (NomArtiste) VALUES (''' + Leftstr(sArtiste, 50) + ''');';
                   FrmParam.SQLQuery1.SQL.Text:= 'INSERT INTO Artistes (NomArtiste) VALUES (:artiste);';
                   FrmParam.SQLQuery1.ParamByName('artiste').AsString := Leftstr(sArtiste, 50);
                   FrmParam.SQLQuery1.ExecSQL;
                   Form1.SQLTransaction1.CommitRetaining;
                   FrmParam.SQLQuery1.close;
                   sql:= 'SELECT NumArtiste, NomArtiste FROM Artistes ORDER BY NumArtiste;';
                   FrmParam.SQLQuery1.SQL.Text:= sql;
                   FrmParam.SQLQuery1.Open;
                   FrmParam.SQLQuery1.last;
                   If Leftstr(sArtiste, 50) = FrmParam.SQLQuery1.FieldByName('NomArtiste').Asstring then nArtiste:= FrmParam.SQLQuery1.FieldByName('NumArtiste').AsInteger;
                   FrmParam.SQLQuery1.Close;
                  end;
           {end;}

       // Vérification de l'existence du dossier
       bDossierExiste:=false;


       For i:=1 to FrmParam.ListDossiers.RowCount do
           if FrmParam.ListDossiers.cells[i,1] = sCheminCourt then
              begin
                bDossierExiste:=True;
                nDossier:=strtoInt(FrmParam.ListDossiers.cells[i,2]);
                break;
              end;

        If not bDossierExiste then
           begin
             sNomGenre:=InputBox('GENRE','Veuillez préciser le genre correspondant à ce dossier :', 'indéfini');
             FrmParam.SQLQuery1.SQL.Clear;
             FrmParam.SQLQuery1.SQL.text:='INSERT INTO Dossiers (NumDossier, Chemin, NumCat, NomGenre) VALUES ((SELECT MAX(NumDossier) FROM Dossiers) + 1, :chemin, 0, :genre);';
             FrmParam.SQLQuery1.ParamByName('chemin').AsString:=sCheminCourt;
             FrmParam.SQLQuery1.ParamByName('genre').AsString:='Genre';
             FrmParam.SQLQuery1.ExecSQL;
             Form1.SQLTransaction1.CommitRetaining;
             If FrmParam.ListDossiers.RowCount > 1 then
                nDossier:=strtoint(FrmParam.ListDossiers.cells[FrmParam.ListDossiers.RowCount,3]) + 1
             else
                 nDossier:=1; ///FAUX !!!
             i:=FrmParam.ListDossiers.RowCount+1;
             FrmParam.ListDossiers.RowCount:=i;
             FrmParam.ListDossiers.cells[i,0]:=sNomGenre;
             FrmParam.ListDossiers.cells[i,1]:=sChemincourt;
             FrmParam.ListDossiers.cells[i,2]:=inttostr(nDossier);
             FrmParam.SQLQuery1.close;
           end;


        //ajout dans la base du nouveau morceau
        FrmParam.SQLQuery1.SQL.Clear;
        FrmParam.SQLQuery1.SQL.Add('INSERT INTO Morceaux (NumFich, Titre, NumArtiste, NumCat, NumGenre, Annee, Duree, NumDossier, Filename, DerniereDiffusion, PS, Intro, SurImpression, tempo, actif) ');
        FrmParam.SQLQuery1.SQL.Add('VALUES ((SELECT MAX(NumFich) FROM Morceaux)+ 1, :titre, ' + inttostr(nArtiste) + ', ' + inttostr(nCat) + ', 12, '''', 0, ' + inttostr(nDossier) + ', :nomfich, ''1900-01-01 12:00:00'', 0, 0, ' + inttostr(nSI) + ', 1, 0);');
        FrmParam.SQLQuery1.ParamByName('titre').AsString := sTitre;
        FrmParam.SQLQuery1.ParamByName('nomfich').AsString := sNomFich;

        //showmessage(sTitre + ' inséré');
        FrmParam.SQLQuery1.ExecSQL;
        Form1.SQLTransaction1.CommitRetaining;
        FrmParam.SQLQuery1.close;
        Result:=True;



       {sql:= 'SELECT Titre, NumArtiste, NumCat, NumGenre, Annee, Duree, Chemin, Filename, DerniereDiffusion, PS, Intro, SurImpression, tempo, actif FROM Morceaux;';
       showmessage('ajout' + sartiste + ' ' + stitre);//

       FrmParam.SQLQuery1.SQL.text:=sql;
       FrmParam.SQLQuery1.open;
       FrmParam.SQLQuery1.Insert;

       FrmParam.SQLQuery1.FieldByName('Titre').AsString:= sTitre;
       FrmParam.SQLQuery1.FieldByName('NumArtiste').AsInteger:= nArtiste;

       Case FrmParam.TabControl1.TabIndex of
         0:FrmParam.SQLQuery1.FieldByName('NumCat').AsInteger:= 1;
         1:FrmParam.SQLQuery1.FieldByName('NumCat').AsInteger:= 2;
       end;

       FrmParam.SQLQuery1.FieldByName('NumGenre').AsInteger:= 101;

       FrmParam.SQLQuery1.FieldByName('Annee').AsString:='';
       FrmParam.SQLQuery1.FieldByName('Duree').AsInteger:=0;
       FrmParam.SQLQuery1.FieldByName('Chemin').AsString:=sCheminCourt;
       FrmParam.SQLQuery1.FieldByName('Filename').AsString:=sNomFich;
       //FrmParam.SQLQuery1.FieldByName('DerniereDiffusion').AsDateTime:=strtodatetime('1900-01-01 12:00:00');
       FrmParam.SQLQuery1.FieldByName('PS').AsInteger:=0;
       FrmParam.SQLQuery1.FieldByName('Intro').AsInteger:=0;
       FrmParam.SQLQuery1.FieldByName('SurImpression').AsInteger:=40;
       FrmParam.SQLQuery1.FieldByName('tempo').AsInteger:=1;
       FrmParam.SQLQuery1.FieldByName('actif').AsInteger:=0;

       FrmParam.SQLQuery1.Post;
       FrmParam.SQLQuery1.ApplyUpdates;



       FrmParam.SQLQuery1.close;
       Form1.SQLTransaction1.CommitRetaining;}


     end
  else
      begin
         Result:=False;
      end;

  finally
         lst.free;
  end;
end;


Function searchforfiles (sCheminCourt : string):integer;
Var
   S:TSearchRec;
  sExt: string;
  sFile: string;
  chemin: string;
  nbFile: integer;
begin

     Chemin:=IncludeTrailingPathDelimiter(sCheminCourt);
  nbFile:=0;
  Result:=0;

  If findfirst(Chemin+'*.*',faAnyFile,S)=0
  then begin
    repeat
      if (s.name<>'.') and (s.name<>'..')
      then
        if(s.attr and faDirectory)=0 then
          begin
            nbFile:=nbFile + 1;

          end;
    until FindNext(S)<>0;
    FindClose(S);
    end;

  FrmParam.ProgressBar1.Max:=nbFile;
  FrmParam.ProgressBar1.position:=0;


  // Recherche de la première entrée du répertoire
  If FindFirst(Chemin+'*.*',faAnyFile,S)=0
  Then Begin
    Repeat
      // Il faut absolument dans le cas d'une procédure récursive ignorer
      // les . et .. qui sont toujours placés en début de répertoire
      // Sinon la procédure va boucler sur elle-même.
      If (S.Name<>'.')And(s.Name<>'..')
      Then Begin
        If (S.Attr And faDirectory)<>0
          // Dans le cas d'un sous-repertoire on appelle la même procédure
          Then Result:=Result+searchforfiles(Chemin+S.Name)
          // Sinon on compte simplement le fichier
          Else
            begin
              sFile:=Chemin + S.Name;
              sExt:= UpperCase(ExtractFileExt(sFile));
              FrmParam.ProgressBar1.position:=FrmParam.ProgressBar1.position+1;
              FrmParam.LabelCounter.caption:= 'Vérification du fichier ' + inttostr(FrmParam.ProgressBar1.position) + ' sur ' + inttostr(nbFile);
              Application.ProcessMessages;
              If (sExt='.MP3') or (sExt='.WAV') or (sExt='.OGG') or (sExt='.FLAC') then
                  begin
                    If InfoMP3(sFile, ExtractFileName(sFile), ExtractFilePath(sFile), sExt) then Inc(Result);
                  end

            end;
      End;
    // Recherche du suivant
    Until FindNext(S)<>0;
    FindClose(S);
  End;


end;

procedure TFrmParam.TextEcartTitMExit(Sender: TObject);
begin
    FrmParam.SQLQuery1.SQL.Clear;
FrmParam.SQLQuery1.SQL.add('UPDATE Dossiers SET ETM = ' + inttostr(TextEcartTitM.Value) + ' WHERE NumDossier = ' + FrmParam.ListDossiers.Cells[2,FrmParam.ListDossiers.Row] + ';');
FrmParam.SQLQuery1.ExecSQL;
Form1.SQLTransaction1.CommitRetaining;
FrmParam.SQLQuery1.close;
end;

procedure TFrmParam.TextInstruChange(Sender: TObject);
var
   i : integer;
begin
  If TextInstru.Text <>'' then
     For i:=0 to ComboInstru.Count - 1 do
         If uppercase(TextInstru.Text) = uppercase(leftstr(ComboInstru.Items[i], length(TextInstru.Text))) then
              begin
                   ComboInstru.TopIndex:=i;
                   break;
              end;

end;

Procedure refreshInstru;
var
  i:PtrInt;
  sInstru:string;
begin

  FrmParam.ComboInstru.Clear;
  FrmParam.ComboInstru.AddItem('[AUCUN]', TObject(-1));

  FrmParam.SQLQuery1.SQL.Text := 'SELECT NumFich, Titre FROM Morceaux WHERE NumCat = 4;' ;
  FrmParam.SQLQuery1.Open;
  While Not FrmParam.SQLQuery1.EOF do
     begin
        sInstru:=FrmParam.SQLQuery1.FieldByName('Titre').AsString;
        i:=PtrInt(FrmParam.SQLQuery1.FieldByName('NumFich').AsInteger);
        FrmParam.ComboInstru.AddItem(sInstru, TObject(i));
        FrmParam.SQLQuery1.Next
     end;

     FrmParam.SQLQuery1.close;

  FrmParam.ComboInstru.ItemIndex:=0;

end;

procedure AfficheEcart(aRow: integer);
var
   sql: string;
   obj: Tobject;
   n, i: integer;
   nInstru: integer;
begin

  sql:='SELECT EJ, EH, EM, EAJ, EAH, EAM, ETJ, ETH, ETM, NomGenre, Instru FROM Dossiers WHERE NumDossier = ' + FrmParam.ListDossiers.Cells[2,aRow] + ';';
 FrmParam.SQLQuery1.SQL.text:= sql;
 FrmParam.SQLQuery1.open;
 If not FrmParam.SQLQuery1.eof then
   begin

     FrmParam.TextEcartGenreJ.Value:= FrmParam.SQLQuery1.FieldByName('EJ').AsInteger;
     FrmParam.TextEcartGenreH.Value:= FrmParam.SQLQuery1.FieldByName('EH').Asinteger;
     FrmParam.TextEcartGenreM.Value:= FrmParam.SQLQuery1.FieldByName('EM').AsInteger;

     FrmParam.TextEcartArtJ.Value:= FrmParam.SQLQuery1.FieldByName('EAJ').AsInteger;
     FrmParam.TextEcartArtH.Value:= FrmParam.SQLQuery1.FieldByName('EAH').AsInteger;
     FrmParam.TextEcartArtM.Value:= FrmParam.SQLQuery1.FieldByName('EAM').AsInteger;

     FrmParam.TextEcartTitJ.Value:= FrmParam.SQLQuery1.FieldByName('ETJ').AsInteger;
     FrmParam.TextEcartTitH.Value:= FrmParam.SQLQuery1.FieldByName('ETH').AsInteger;
     FrmParam.TextEcartTitM.Value:= FrmParam.SQLQuery1.FieldByName('ETM').AsInteger;

     nInstru:=FrmParam.SQLQuery1.FieldByName('Instru').AsInteger;

     FrmParam.LabelGenre.Caption:= 'Ecart ' + FrmParam.SQLQuery1.FieldByName('NomGenre').AsString;

   end;
 FrmParam.SQLQuery1.close;

 //Instru
FrmParam.textInstru.Text:='';
If FrmParam.ComboInstru.Count>0 then
If nInstru = 0 then FrmParam.ComboInstru.ItemIndex:=0 else
 for i:=1 to FrmParam.ComboInstru.items.count -1 do
     begin
        If nInstru = PtrInt(FrmParam.ComboInstru.Items.Objects[i]) then FrmParam.ComboInstru.ItemIndex:=i;
     end;


 //Transitions
 For n:= 0 to FrmParam.LstTransition.RowCount -1 do
     begin
        FrmParam.LstTransition.Cells[1,n]:='0';
     end;

 sql:= 'SELECT * FROM transitions WHERE numGenre1 = ' + FrmParam.ListDossiers.Cells[2,aRow] + ';';
  FrmParam.SQLQuery1.SQL.text:= sql;
  FrmParam.SQLQuery1.open;
  While not FrmParam.SQLQuery1.EOF do
        begin
           For n:= 0 to FrmParam.LstTransition.RowCount -1 do
               if FrmParam.LstTransition.Cells[0,n]=FrmParam.SQLQuery1.FieldByName('numGenre2').AsString then FrmParam.LstTransition.Cells[1,n]:='1';
           FrmParam.SQLQuery1.Next;
        end;
FrmParam.SQLQuery1.close;


end;

procedure RefreshTransitions;
var
   sql: string;
   i: integer;
begin
//Liste des transitions
 sql:= 'SELECT * FROM dossiers ORDER BY NomGenre;';
 FrmParam.LstTransition.Clear;

 FrmParam.SQLQuery1.SQL.Text:=sql;
 FrmParam.SQLQuery1.Open;
 FrmParam.SQLQuery1.Last;
 FrmParam.SQLQuery1.First;

 i:=0;

 While not FrmParam.SQLQuery1.EOF do
       begin
          FrmParam.LstTransition.RowCount:=i+1;
          FrmParam.LstTransition.cells[0, i]:=FrmParam.SQLQuery1.FieldByName('NumDossier').AsString;
          FrmParam.LstTransition.cells[2, i]:=FrmParam.SQLQuery1.FieldByName('NomGenre').AsString;
          FrmParam.SQLQuery1.Next;
          i:=i+1;
       end;
 FrmParam.SQLQuery1.close;
end;

procedure FolderRefresh(nCat: integer);
var
  sql: string;
  i, n: integer;
  obj: Tobject;
begin

  sql:= 'SELECT * FROM dossiers WHERE numCat = ' + inttostr(nCat) + ' ORDER BY NomGenre;';


  //FrmParam.ListDossiers.Clear;
  FrmParam.SQLQuery1.SQL.Text:=sql;
  FrmParam.SQLQuery1.Open;
  FrmParam.SQLQuery1.Last;
  FrmParam.SQLQuery1.First;
  i:=FrmParam.SQLQuery1.RecordCount;
  FrmParam.ListDossiers.rowcount:= i + 1;

  While not FrmParam.SQLQuery1.EOF do
        begin
           n:=FrmParam.SQLQuery1.RecNo;
           FrmParam.ListDossiers.Cells[0,n]:=FrmParam.SQLQuery1.FieldByName('NomGenre').AsString;
           FrmParam.ListDossiers.Cells[1,n]:=FrmParam.SQLQuery1.FieldByName('Chemin').AsString;
           FrmParam.ListDossiers.Cells[2,n]:=inttostr(FrmParam.SQLQuery1.FieldByName('NumDossier').AsInteger);
           FrmParam.SQLQuery1.Next;
        end;

  FrmParam.SQLQuery1.close;

  If i<>0 then
   begin
     FrmParam.listdossiers.Row:=1;
     AfficheEcart(1);
     FrmParam.TextEcartGenreJ.Enabled:= true;
     FrmParam.TextEcartGenreH.Enabled:= true;
     FrmParam.TextEcartGenreM.Enabled:= true;

     FrmParam.TextEcartArtJ.Enabled:= true;
     FrmParam.TextEcartArtH.Enabled:= true;
     FrmParam.TextEcartArtM.Enabled:= true;

     FrmParam.TextEcartTitJ.Enabled:= true;
     FrmParam.TextEcartTitH.Enabled:= true;
     FrmParam.TextEcartTitM.Enabled:= true;
   end
  else
      begin
      FrmParam.TextEcartGenreJ.Enabled:= false;
      FrmParam.TextEcartGenreH.Enabled:= false;
      FrmParam.TextEcartGenreM.Enabled:= false;

     FrmParam.TextEcartArtJ.Enabled:= false;
     FrmParam.TextEcartArtH.Enabled:= false;
     FrmParam.TextEcartArtM.Enabled:= false;

     FrmParam.TextEcartTitJ.Enabled:= false;
     FrmParam.TextEcartTitH.Enabled:= false;
     FrmParam.TextEcartTitM.Enabled:= false;
      end;





end;

procedure TFrmParam.ChkRetardateurChange(Sender: TObject);
begin
  If ChkRetardateur.Checked Then TextRetard.Enabled:= True
  Else TextRetard.Enabled:= False;
end;

procedure TFrmParam.ChkAucunClick(Sender: TObject);
var
  n: integer;
  sql: string;
begin
     For n:= 0 to LstTransition.RowCount - 1 do LstTransition.Cells[1, n]:='0';
      FrmParam.SQLQuery1.SQL.Clear;
      FrmParam.SQLQuery1.SQL.add('DELETE FROM Transitions WHERE NumGenre1 = ' + FrmParam.ListDossiers.Cells[2,FrmParam.ListDossiers.Row] + ';');
      FrmParam.SQLQuery1.ExecSQL;
      Form1.SQLTransaction1.CommitRetaining;
      FrmParam.SQLQuery1.close;
end;

procedure TFrmParam.ChkTousClick(Sender: TObject);
var
  n: integer;
  sql: string;
begin
  Screen.Cursor:=crHourglass;
     For n:= 0 to LstTransition.RowCount - 1 do
         begin
            If LstTransition.Cells[1, n]='0' then
             begin
                  FrmParam.SQLQuery1.SQL.Clear;
                  FrmParam.SQLQuery1.SQL.text:='INSERT INTO Transitions (NumGenre1, NumGenre2) VALUES (:genre1, :genre2);';
                  FrmParam.SQLQuery1.ParamByName('genre1').Asinteger:=strtoint(FrmParam.ListDossiers.Cells[2,FrmParam.ListDossiers.Row]);
                  FrmParam.SQLQuery1.ParamByName('genre2').Asinteger:=strtoint(LstTransition.Cells[0, n]);
                  FrmParam.SQLQuery1.ExecSQL;
                  Form1.SQLTransaction1.CommitRetaining;
                  FrmParam.SQLQuery1.Close;
                  LstTransition.Cells[1, n]:='1';
             end;
         end;
     Screen.Cursor:=crDefault;
end;

procedure TFrmParam.ChktransitionChange(Sender: TObject);
begin
  Case ChkTransition.Checked of
       true:begin
          LstTransition.visible:=true;
          ChkTous.Visible:=true;
          ChkAucun.Visible:=true;
       end;
       false:begin
          LstTransition.visible:=false;
          ChkTous.Visible:=false;
          ChkAucun.Visible:=false;
       end;
  end;
end;

procedure TFrmParam.CmdAjoutClick(Sender: TObject);
var
   sCheminCourt, sNomGenre : string;
   nFichiers, i, nCat : integer;
   bDossierExiste: boolean;
   sCat: string;
   nDossier: integer;
begin
     nCat:= Tabcontrol1.TabIndex + 1;
    If SelectDirectory('Choisissez le dossier de sons que vous voulez ajouter','/home/', sCheminCourt) then
       begin
         bDossierExiste:=false;
         FrmParam.SQLQuery1.SQL.Text:='SELECT * FROM Dossiers Where Chemin = ''' + sCheminCourt + ''';';
         FrmParam.SQLQuery1.Open;
         If not FrmParam.SQLQuery1.EOF then
            begin
              bDossierExiste:=True;
              Case FrmParam.SQLQuery1.FieldByName('NumCat').AsInteger of
                 1:sCat:='MUSIQUE';
                 2:sCat:='CAPSULE';
                 3:sCat:='JINGLE';
                 4:sCat:='INSTRU';
              end;
              showMessage('Le dossier ' + sCheminCourt + ' est déjà référencé en ' + sCat + ' !');
            end;
            FrmParam.SQLQuery1.Close;
       end;

     If not bDossierExiste then
        begin
          sNomGenre:=InputBox('GENRE','Veuillez préciser le genre correspondant à ce dossier :', 'indéfini');
          FrmParam.SQLQuery1.SQL.Clear;
          FrmParam.SQLQuery1.SQL.text:='INSERT INTO Dossiers (NumDossier, Chemin, NumCat, NomGenre) VALUES ((SELECT MAX(NumDossier) FROM Dossiers) + 1, :chemin, ' + inttostr(nCat) + ', :genre);';
          FrmParam.SQLQuery1.ParamByName('chemin').AsString:=sCheminCourt;
          FrmParam.SQLQuery1.ParamByName('genre').AsString:=sNomGenre;
          FrmParam.SQLQuery1.ExecSQL;
          Form1.SQLTransaction1.CommitRetaining;
          FrmParam.SQLQuery1.close;

          FrmParam.SQLQuery1.SQL.text:='SELECT * FROM Dossiers ORDER BY NumDossier;';
          FrmParam.SQLQuery1.Open;
          If not FrmParam.SQLQuery1.EOF then
             begin
               FrmParam.SQLQuery1.Last;
               nDossier:=FrmParam.SQLQuery1.FieldByName('Numdossier').AsInteger;
             end;
          FrmParam.SQLQuery1.Close;
          FrmSearch.Tag:=nDossier;
          FrmSearch.ShowModal;
        end;

     Refreshtransitions;

end;

procedure TFrmParam.CmdBaseClick(Sender: TObject);
var
 sChemincourt: string;
 inifile: Tinifile;
begin
  inifile:= TIniFile.Create('JBox.ini');
  try
   If SelectDirectory('Choisissez le dossier dans lequel vous souhaitez enregistrer les pochettes','/home/', sCheminCourt) then
        begin
          inifile.WriteString('Base', 'chemin', sCheminCourt + '/MusicBase');
          CmdBase.Caption:=sCheminCourt + '/MusicBase';
        end;

  finally
         inifile.Free;
  end;
end;

procedure TFrmParam.CmdCorbeilleClick(Sender: TObject);
var
 sChemincourt: string;
 inifile: Tinifile;
begin
  inifile:= TIniFile.Create('JBox.ini');
  try
   If SelectDirectory('Choisissez le dossier-corbeille','/home/', sCheminCourt) then
     begin
        inifile.WriteString('Corbeille', 'Chemin', sCheminCourt);
        CmdCorbeille.Caption:=sCheminCourt;
     end;

  finally
         inifile.Free;
  end;
end;



procedure TFrmParam.CmdPochetteClick(Sender: TObject);
var
 sChemincourt: string;
 inifile: Tinifile;
begin
  inifile:= TIniFile.Create('JBox.ini');
  try
   If SelectDirectory('Choisissez le dossier dans lequel vous souhaitez enregistrer les pochettes','/home/', sCheminCourt) then
     begin
        inifile.WriteString('Pochettes', 'Chemin', sCheminCourt);
        CmdPochette.Caption:=sCheminCourt;
     end;

  finally
         inifile.Free;
  end;
end;

procedure TFrmParam.CmdSuppClick(Sender: TObject);
var
  sDossier : String;
  nDossier: PtrInt;
  i : integer;
  r: word;
  sql: string;
begin

     If ListDossiers.Row < 1 then exit;
     sDossier:= ListDossiers.Cells[0,ListDossiers.Row];
     nDossier:= strtoInt(ListDossiers.Cells[2,ListDossiers.Row]);

     sql:='SELECT NumFich FROM Morceaux WHERE NumDossier = ' + inttostr(nDossier) + ';';
     FrmParam.SQLQuery1.SQL.text:= sql;
     FrmParam.SQLQuery1.open;
     FrmParam.SQLQuery1.last;
     FrmParam.SQLQuery1.first;

  case FrmParam.SQLQuery1.eof of
    true:r:= MessageDlg('Êtes-vous sûr de vouloir supprimer ' + sDossier + ' de la base ? (aucun morceau référencé)', mtWarning, [mbYes, mbNo, mbAbort],0);
    false:r:= MessageDlg('Êtes-vous sûr de vouloir supprimer ' + sDossier + ' AINSI QUE les ' + inttostr(FrmParam.SQLQuery1.recordcount) + ' morceaux associés de la base ?', mtWarning, [mbYes, mbNo, mbAbort],0);
  end;
  FrmParam.SQLQuery1.close;

  If r = mrYes Then
     begin
        FrmParam.SQLQuery1.SQL.Clear;
        FrmParam.SQLQuery1.SQL.add('DELETE FROM Morceaux WHERE NumDossier = ' + inttostr(nDossier) + ';');
        FrmParam.SQLQuery1.ExecSQL;
        Form1.SQLTransaction1.CommitRetaining;
        FrmParam.SQLQuery1.close;

        FrmParam.SQLQuery1.SQL.Clear;
        FrmParam.SQLQuery1.SQL.add('DELETE FROM Dossiers WHERE NumDossier = ' + inttostr(nDossier) + ';');
        FrmParam.SQLQuery1.ExecSQL;
        Form1.SQLTransaction1.CommitRetaining;
        FrmParam.SQLQuery1.close;

        ListDossiers.DeleteRow(ListDossiers.Row);
     end;

 Refreshtransitions;

end;

procedure TFrmParam.CmdVerifClick(Sender: TObject);
var
   i : integer;
   n: integer;
   st: string;
begin
     FrmSearch.Tag:=0;
     FrmSearch.ShowModal;

     {For i:= 0 To ListBox1.Count - 1 do
      begin
         n:=searchforfiles(Listbox1.Items[i]);
         case n of
           0:st:=st + ''; //st+'Aucun fichier n''a été ajouté à la base dans '+ Listbox1.Items[i] + #13#10;
           1:st:=st + '1 fichier a été ajouté à la base dans '+ Listbox1.Items[i] + #13#10 + #13#10;
           else st:=st + inttostr(n) + ' fichiers ont été ajoutés à la base dans '+ Listbox1.Items[i] + #13#10 + #13#10;
         end;
      end;
  ShowMessage(st); }
end;

procedure TFrmParam.ComboInstruClick(Sender: TObject);
var
   nI: PtrInt;
begin

    //if PtrInt(ComboInstru.Items.Objects[ComboInstru.ItemIndex])<>-1 then nI:=0 else
     nI:= PtrInt(ComboInstru.Items.Objects[ComboInstru.ItemIndex]);
       FrmParam.SQLQuery1.SQL.Clear;
       FrmParam.SQLQuery1.SQL.add('UPDATE Dossiers SET Instru = ' + inttostr(nI) + ' WHERE NumDossier = ' + FrmParam.ListDossiers.Cells[2,FrmParam.ListDossiers.Row] + ';');
       FrmParam.SQLQuery1.ExecSQL;
       Form1.SQLTransaction1.CommitRetaining;
       FrmParam.SQLQuery1.close;

end;

procedure TFrmParam.FormActivate(Sender: TObject);
var
 inifile: Tinifile;
 nCat: integer;
 sql: string;
 i: integer;
begin
  inifile:= TIniFile.Create('JBox.ini');
try
  nCat:=TabControl1.TabIndex + 1;
  SpinPS.Value:= inifile.ReadInteger('Parametres', 'TimingFin' + inttostr(nCat), 5000)/1000;
  SpinInter.Value:= inifile.ReadInteger('Ecart', 'Mini' + inttostr(nCat), 0);
  SpinEcartJC.Value:= inifile.ReadInteger('Ecart', 'JC', 0);
  SpinSelect.Value:=inifile.ReadInteger('Parametres', 'PourcentSelect', 10);
  if nCat <> 2 then
   begin
    comboinstru.Visible:=false;
    textinstru.Visible:=false;
    labelinstru.Visible:=false;
   end;
  RefreshTransitions;

  FolderRefresh(nCat);



  //n:=  FrmParam.LstTransition.Items.IndexOfObject(obj);

  //TextEcartTitJ.Text:= inttostr(inifile.ReadInteger('Ecart', 'TitreJour' + inttostr(nCat), 0));
  //TextEcartTitH.Text:= inttostr(inifile.ReadInteger('Ecart', 'TitreHeure' + inttostr(nCat), 0));
  //TextEcartTitM.Text:= inttostr(inifile.ReadInteger('Ecart', 'TitreMinute' + inttostr(nCat), 0));

  //TextEcartArtJ.Text:= inttostr(inifile.ReadInteger('Ecart', 'ArtisteJour' + inttostr(nCat), 0));
  //TextEcartArtH.Text:= inttostr(inifile.ReadInteger('Ecart', 'ArtisteHeure' + inttostr(nCat), 0));
  //TextEcartArtM.Text:= inttostr(inifile.ReadInteger('Ecart', 'ArtisteMinute' + inttostr(nCat), 0));

  CmdPochette.Caption:=inifile.ReadString('Pochettes','Chemin', '[Sélectionner un dossier de stockage pour les pochettes]');
  CmdBase.Caption:=  inifile.ReadString('Base','chemin','[Sélectionner un emplacement pour la base]');
  CmdCorbeille.Caption:=  inifile.ReadString('Corbeille','chemin','[Sélectionner un emplacement pour la CORBEILLE]');

  Case inifile.ReadInteger('Parametres', 'Verifauto', 0) of
       0:CheckVerif.Checked:= false;
       1:CheckVerif.Checked:= true;
  end;
  Case inifile.ReadInteger('Parametres', 'AutoPlay', 0) of
       0:ChkAutoPlay.Checked:= false;
       1:ChkAutoPlay.Checked:= true;
  end;
  Case inifile.ReadInteger('Parametres', 'Retard', 0) of
       0:ChkRetardateur.Checked:= false;
       1:ChkRetardateur.Checked:= true;
  end;

  Case inifile.ReadInteger('Parametres', 'Ordre', 1) of
       0:ChkOrdre.Checked:= false;
       1:ChkOrdre.Checked:= true;
  end;
  Case inifile.ReadInteger('Parametres', 'Transitions', 0) of
       0:begin
          ChkTransition.Checked:= false;
          LstTransition.visible:=false;
          ChkTous.Visible:=false;
          ChkAucun.Visible:=false;
       end;
       1:begin
          ChkTransition.Checked:= true;
          LstTransition.visible:=true;
          ChkTous.Visible:=true;
          ChkAucun.Visible:=true;
       end;
  end;

  TextRetard.Text:= inifile.Readstring('Parametres', 'Heure', '00:00:00');

  SpinVol.Value:= inifile.ReadInteger('Parametres', 'VolumeSousImpress', 60);
  finally
inifile.Free;

  End;
end;

procedure TFrmParam.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
 inifile: Tinifile;
 sql: string;
 nCat: integer;
begin
  inifile:= TIniFile.Create('JBox.ini');

try
  nCat:=TabControl1.TabIndex + 1;
  sql:= 'SELECT * FROM dossiers WHERE numCat = ' + inttostr(nCat) + ' ORDER BY Chemin;';
  inifile.WriteInteger('Parametres', 'TimingFin' + inttostr(nCat), trunc(SpinPS.Value*1000));
  inifile.WriteInteger('Ecart', 'Mini' + inttostr(nCat), SpinINTER.Value);
  inifile.WriteInteger('Ecart', 'JC', SpinEcartJC.Value);
  inifile.WriteInteger('Parametres', 'PourcentSelect', SpinSelect.Value);
  ListDossiers.Clear;
  RefreshInstru;

  //inifile.WriteInteger('Ecart', 'TitreJour' + inttostr(nCat), strtoint(TextEcartTitJ.Text));
  //inifile.WriteInteger('Ecart', 'TitreHeure' + inttostr(nCat), strtoint(TextEcartTitH.Text));
  //inifile.WriteInteger('Ecart', 'TitreMinute' + inttostr(nCat), strtoint(TextEcartTitM.Text));

  //inifile.WriteInteger('Ecart', 'ArtisteJour' + inttostr(nCat), strtoint(TextEcartArtJ.Text));
  //inifile.WriteInteger('Ecart', 'ArtisteHeure' + inttostr(nCat), strtoint(TextEcartArtH.Text));
  //inifile.WriteInteger('Ecart', 'ArtisteMinute' + inttostr(nCat), strtoint(TextEcartArtM.Text));

  //FrmParam.SQLQuery1.SQL.Clear;
  //FrmParam.SQLQuery1.SQL.add('UPDATE Dossiers SET EJ = ' + TextEcartGenreJ.Text + ', EH = ' + TextEcartGenreH.Text + ', EM = ' + TextEcartGenreM.Text + ' WHERE NumDossier = ' + FrmParam.ListDossiers.Cells[2,FrmParam.ListDossiers.Row] + ';');
  //FrmParam.SQLQuery1.ExecSQL;
  //Form1.SQLTransaction1.CommitRetaining;
  //FrmParam.SQLQuery1.close;

  Case CheckVerif.Checked of
       false:inifile.WriteInteger('Parametres', 'Verifauto', 0);
       true:inifile.WriteInteger('Parametres', 'Verifauto', 1);
  end;
  Case ChkAutoPlay.Checked of
       false:inifile.WriteInteger('Parametres', 'AutoPlay', 0);
       true:inifile.WriteInteger('Parametres', 'AutoPlay', 1);
  end;
  Case ChkRetardateur.Checked of
       false:inifile.WriteInteger('Parametres', 'Retard', 0);
       true:inifile.WriteInteger('Parametres', 'Retard', 1);
  end;
  Case ChkOrdre.Checked of
       false:inifile.WriteInteger('Parametres', 'Ordre', 0);
       true:inifile.WriteInteger('Parametres', 'Ordre', 1);
  end;
  Case ChkTransition.Checked of
       false:inifile.WriteInteger('Parametres', 'Transitions', 0);
       true:inifile.WriteInteger('Parametres', 'Transitions', 1);
  end;
  inifile.Writestring('Parametres', 'Heure', TextRetard.Text);
  inifile.WriteInteger('Parametres', 'VolumeSousImpress', SpinVol.Value);


  finally
  inifile.Free;
end;
end;

procedure TFrmParam.FormCreate(Sender: TObject);
begin
  //SQLite3Connection1.DatabaseName:='/home/jeremie/MusicBase';
  //SQLite3Connection1.Connected:=true;

  //SQLTransaction1.DataBase:=SQLite3Connection1;

  FrmParam.SQLQuery1.DataBase := Form1.SQLite3Connection1;
  FrmParam.SQLQuery1.UsePrimaryKeyAsKey := False;
end;





procedure TFrmParam.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TFrmParam.ListDossiersBeforeSelection(Sender: TObject; aCol,
  aRow: Integer);
begin
  //FrmParam.SQLQuery1.SQL.Clear;
  //FrmParam.SQLQuery1.SQL.add('UPDATE Dossiers SET EJ = ' + TextEcartGenreJ.Text + ', EH = ' + TextEcartGenreH.Text + ', EM = ' + TextEcartGenreM.Text + ' WHERE NumDossier = ' + FrmParam.ListDossiers.Cells[2,FrmParam.ListDossiers.Row] + ';');
  //FrmParam.SQLQuery1.ExecSQL;
  //Form1.SQLTransaction1.CommitRetaining;
  //FrmParam.SQLQuery1.close;
end;

procedure TFrmParam.ListDossiersSelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin

end;


procedure TFrmParam.ListDossiersSelection(Sender: TObject; aCol, aRow: Integer);
begin

  AfficheEcart(aRow);

end;

procedure TFrmParam.LstTransitionClick(Sender: TObject);
var
sql: string;
n: integer;
begin
n:=LstTransition.Row;
if LstTransition.Cells[1, n]='0' then
 begin
    FrmParam.SQLQuery1.SQL.Clear;
    FrmParam.SQLQuery1.SQL.text:='INSERT INTO Transitions (NumGenre1, NumGenre2) VALUES (:genre1, :genre2);';
    FrmParam.SQLQuery1.ParamByName('genre1').Asinteger:=strtoint(FrmParam.ListDossiers.Cells[2,FrmParam.ListDossiers.Row]);
    FrmParam.SQLQuery1.ParamByName('genre2').Asinteger:=strtoint(LstTransition.Cells[0, n]);
    FrmParam.SQLQuery1.ExecSQL;
    Form1.SQLTransaction1.CommitRetaining;
    FrmParam.SQLQuery1.Close;
 end
else
   begin
      FrmParam.SQLQuery1.SQL.Clear;
      FrmParam.SQLQuery1.SQL.add('DELETE FROM Transitions WHERE NumGenre1 = ' + FrmParam.ListDossiers.Cells[2,FrmParam.ListDossiers.Row] + ' AND NumGenre2 = ' + LstTransition.Cells[0, n] + ';');
      FrmParam.SQLQuery1.ExecSQL;
      Form1.SQLTransaction1.CommitRetaining;
      FrmParam.SQLQuery1.close;
   end;

end;





procedure TFrmParam.TabControl1Change(Sender: TObject);
var
 inifile: Tinifile;
 nCat: integer;
begin
  inifile:= TIniFile.Create('JBox.ini');
try
  nCat:=TabControl1.TabIndex + 1;

  SpinPS.Value:= inifile.ReadInteger('Parametres', 'TimingFin' + inttostr(nCat), 5000)/1000;
  RefreshInstru;


  if (nCat= 1) OR (nCat= 4) then
   begin
    spinInter.Visible:=false;
    LabelspinInter.Visible:=false;
    Labelminutes.Visible:=false;
    LabelInstru.Visible:=false;
    ComboInstru.visible:=false;
    textinstru.Visible:=false;
   end
  else
      begin
        spinInter.Visible:=true;
        LabelspinInter.Visible:=true;
        Labelminutes.Visible:=true;
        SpinINTER.Value:= inifile.ReadInteger('Ecart', 'Mini' + inttostr(nCat), 0);
        if nCat=2 then
         begin
          LabelInstru.Visible:=true;
          ComboInstru.visible:=true;
          textinstru.Visible:=true;
         end
        else
        begin
          LabelInstru.Visible:=false;
          ComboInstru.visible:=false;
          textinstru.Visible:=false;
        end;
      end;


  FolderRefresh(nCat);

  //TextEcartTitJ.Text:= inttostr(inifile.ReadInteger('Ecart', 'TitreJour' + inttostr(nCat), 0));
  //TextEcartTitH.Text:= inttostr(inifile.ReadInteger('Ecart', 'TitreHeure' + inttostr(nCat), 0));
  //TextEcartTitM.Text:= inttostr(inifile.ReadInteger('Ecart', 'TitreMinute' + inttostr(nCat), 0));

  //TextEcartArtJ.Text:= inttostr(inifile.ReadInteger('Ecart', 'ArtisteJour' + inttostr(nCat), 0));
  //TextEcartArtH.Text:= inttostr(inifile.ReadInteger('Ecart', 'ArtisteHeure' + inttostr(nCat), 0));
  //TextEcartArtM.Text:= inttostr(inifile.ReadInteger('Ecart', 'ArtisteMinute' + inttostr(nCat), 0));

  finally
  inifile.Free;
end;

end;

procedure TFrmParam.TabControl1Changing(Sender: TObject;
var AllowChange: Boolean);
var
 inifile: Tinifile;
 nCat: integer;
 sql: string;
begin
  inifile:= TIniFile.Create('JBox.ini');
try
  nCat:=TabControl1.TabIndex + 1;
  inifile.WriteInteger('Parametres', 'TimingFin' + inttostr(nCat), trunc(SpinPS.Value*1000));
  inifile.WriteInteger('Ecart', 'Mini' + inttostr(nCat), SpinINTER.Value);
  inifile.WriteInteger('Ecart', 'JC', SpinEcartJC.Value);

  //inifile.WriteInteger('Ecart', 'TitreJour' + inttostr(nCat), strtoint(TextEcartTitJ.Text));
  //inifile.WriteInteger('Ecart', 'TitreHeure' + inttostr(nCat), strtoint(TextEcartTitH.Text));
  //inifile.WriteInteger('Ecart', 'TitreMinute' + inttostr(nCat), strtoint(TextEcartTitM.Text));

  //inifile.WriteInteger('Ecart', 'ArtisteJour' + inttostr(nCat), strtoint(TextEcartArtJ.Text));
  //inifile.WriteInteger('Ecart', 'ArtisteHeure' + inttostr(nCat), strtoint(TextEcartArtH.Text));
  //inifile.WriteInteger('Ecart', 'ArtisteMinute' + inttostr(nCat), strtoint(TextEcartArtM.Text));

  //FrmParam.SQLQuery1.SQL.Clear;
  //FrmParam.SQLQuery1.SQL.add('UPDATE Dossiers SET EJ = ' + inttostr(TextEcartGenreJ.Value) + ', EH = ' + inttostr(TextEcartGenreH.Value) + ', EM = ' + inttostr(TextEcartGenreM.Value) + ' WHERE NumDossier = ' + FrmParam.ListDossiers.Cells[2,FrmParam.ListDossiers.Row] + ';');
  //FrmParam.SQLQuery1.ExecSQL;
  //Form1.SQLTransaction1.CommitRetaining;
  //FrmParam.SQLQuery1.close;

  finally
  inifile.Free;
end;

end;

procedure TFrmParam.TextEcartArtHExit(Sender: TObject);
begin
   FrmParam.SQLQuery1.SQL.Clear;
FrmParam.SQLQuery1.SQL.add('UPDATE Dossiers SET EAH = ' + inttostr(TextEcartArtH.Value) + ' WHERE NumDossier = ' + FrmParam.ListDossiers.Cells[2,FrmParam.ListDossiers.Row] + ';');
FrmParam.SQLQuery1.ExecSQL;
Form1.SQLTransaction1.CommitRetaining;
FrmParam.SQLQuery1.close;
end;

procedure TFrmParam.TextEcartArtJExit(Sender: TObject);
begin
 FrmParam.SQLQuery1.SQL.Clear;
FrmParam.SQLQuery1.SQL.add('UPDATE Dossiers SET EAJ = ' + inttostr(TextEcartArtJ.Value) + ' WHERE NumDossier = ' + FrmParam.ListDossiers.Cells[2,FrmParam.ListDossiers.Row] + ';');
FrmParam.SQLQuery1.ExecSQL;
Form1.SQLTransaction1.CommitRetaining;
FrmParam.SQLQuery1.close;
end;

procedure TFrmParam.TextEcartArtMExit(Sender: TObject);
begin
   FrmParam.SQLQuery1.SQL.Clear;
  FrmParam.SQLQuery1.SQL.add('UPDATE Dossiers SET EAM = ' + inttostr(TextEcartArtM.Value) + ' WHERE NumDossier = ' + FrmParam.ListDossiers.Cells[2,FrmParam.ListDossiers.Row] + ';');
  FrmParam.SQLQuery1.ExecSQL;
  Form1.SQLTransaction1.CommitRetaining;
  FrmParam.SQLQuery1.close;
end;

procedure TFrmParam.TextEcartGenreHExit(Sender: TObject);
begin
FrmParam.SQLQuery1.SQL.Clear;
FrmParam.SQLQuery1.SQL.add('UPDATE Dossiers SET EH = ' + inttostr(TextEcartGenreH.Value) + ' WHERE NumDossier = ' + FrmParam.ListDossiers.Cells[2,FrmParam.ListDossiers.Row] + ';');
FrmParam.SQLQuery1.ExecSQL;
Form1.SQLTransaction1.CommitRetaining;
FrmParam.SQLQuery1.close;
end;

procedure TFrmParam.TextEcartGenreJExit(Sender: TObject);
begin
  FrmParam.SQLQuery1.SQL.Clear;
FrmParam.SQLQuery1.SQL.add('UPDATE Dossiers SET EJ = ' + inttostr(TextEcartGenreJ.Value) + ' WHERE NumDossier = ' + FrmParam.ListDossiers.Cells[2,FrmParam.ListDossiers.Row] + ';');
FrmParam.SQLQuery1.ExecSQL;
Form1.SQLTransaction1.CommitRetaining;
FrmParam.SQLQuery1.close;
end;

procedure TFrmParam.TextEcartGenreMExit(Sender: TObject);
begin
   FrmParam.SQLQuery1.SQL.Clear;
FrmParam.SQLQuery1.SQL.add('UPDATE Dossiers SET EM = ' + inttostr(TextEcartGenreM.Value) + ' WHERE NumDossier = ' + FrmParam.ListDossiers.Cells[2,FrmParam.ListDossiers.Row] + ';');
FrmParam.SQLQuery1.ExecSQL;
Form1.SQLTransaction1.CommitRetaining;
FrmParam.SQLQuery1.close;
end;

procedure TFrmParam.TextEcartTitHExit(Sender: TObject);
begin
FrmParam.SQLQuery1.SQL.Clear;
  FrmParam.SQLQuery1.SQL.add('UPDATE Dossiers SET ETH = ' + inttostr(TextEcartTitH.Value) + ' WHERE NumDossier = ' + FrmParam.ListDossiers.Cells[2,FrmParam.ListDossiers.Row] + ';');
  FrmParam.SQLQuery1.ExecSQL;
  Form1.SQLTransaction1.CommitRetaining;
  FrmParam.SQLQuery1.close;
end;

procedure TFrmParam.TextEcartTitJExit(Sender: TObject);
begin
  FrmParam.SQLQuery1.SQL.Clear;
FrmParam.SQLQuery1.SQL.add('UPDATE Dossiers SET ETJ = ' + inttostr(TextEcartTitJ.Value) + ' WHERE NumDossier = ' + FrmParam.ListDossiers.Cells[2,FrmParam.ListDossiers.Row] + ';');
FrmParam.SQLQuery1.ExecSQL;
Form1.SQLTransaction1.CommitRetaining;
FrmParam.SQLQuery1.close;
end;


end.

