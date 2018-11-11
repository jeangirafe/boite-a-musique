unit unitSearch;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ComCtrls, StrUtils;

type

  { TFrmSearch }

  TFrmSearch = class(TForm)
    CmdValide: TButton;
    LabelCounter: TLabel;
    LabelDossier: TLabel;
    ListBox1: TListBox;
    ProgressBar1: TProgressBar;
    SQLQuery1: TSQLQuery;
    SQLQuery3: TSQLQuery;
    procedure CmdValideClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FrmSearch: TFrmSearch;

implementation

uses
  unit1, unitson;

{$R *.lfm}


Function searchDossier(sCheminCourt : string):integer;
var
   bDossierExiste : boolean;
   i, nDossier: PtrInt;   //
begin

      showmessage ('on cherche dans ' + schemincourt);
      bDossierExiste:=false;
       FrmSearch.SQLQuery1.SQL.Text:='SELECT * FROM Dossiers Where Chemin = ''' + sCheminCourt + ''';';
       FrmSearch.SQLQuery1.Open;
       showmessage ('on cherche 2 dans ' + schemincourt);
       If not FrmSearch.SQLQuery1.EOF then
          begin
            bDossierExiste:=True;
            nDossier:=FrmSearch.SQLQuery1.FieldByName('Numdossier').AsInteger;
          end;
       FrmSearch.SQLQuery1.Close;

       showmessage ('on cherche 3 dans ' + schemincourt);
        If not bDossierExiste then
           begin
             FrmSearch.SQLQuery1.SQL.Clear;
             FrmSearch.SQLQuery1.SQL.text:='INSERT INTO Dossiers (NumDossier, Chemin, NumCat) VALUES ((SELECT MAX(NumDossier) FROM Dossiers) + 1, :chemin, 0);';
             FrmSearch.SQLQuery1.ParamByName('chemin').AsString:=sCheminCourt;
             FrmSearch.SQLQuery1.ExecSQL;
             Form1.SQLTransaction1.CommitRetaining;
             FrmSearch.SQLQuery1.close;

             FrmSearch.SQLQuery1.SQL.text:='SELECT * FROM Dossiers ORDER BY NumDossier;';
             FrmSearch.SQLQuery1.Open;
             If not FrmSearch.SQLQuery1.EOF then
                begin
                  FrmSearch.SQLQuery1.Last;
                  nDossier:=FrmSearch.SQLQuery1.FieldByName('Numdossier').AsInteger;
                end;
             FrmSearch.SQLQuery1.Close;
           end;
       result:=nDossier;
end;


Function InfoMP3(sFile : string; sNomFich : string; sChemin : string; sExt: string; nCat: integer; nDossier: integer):boolean;
var
   sql: string;
   sCheminCourt: string;
   Ledossier, Lepath: string;
   bExiste, bArtistExiste, bDossierExiste, bExisteAilleurs : boolean;
   sArtiste : String;
   sTitre: string;
   nArtiste : integer;
   sA: string;
   lst: TStringList;
   i, num: integer;
   nSI: integer;
begin
     //avant tout, vérification si le fichier est déjà dans la base ou non. S'il y est, on passe.
  lst:= Tstringlist.Create;
  sCheminCourt:=LeftStr(sChemin, Length(sChemin) -1);
  try
     //Case nCat of
       //1:begin
          sA := Leftstr(sNomFich, length(sNomfich)-Length(sExt));
          lst.Delimiter:='/';
          lst.StrictDelimiter:=true;
          sA:=stringreplace(sA, ' - ', '/', [rfReplaceAll]);
          lst.delimitedtext:=sA;
          sArtiste:=trim(lst.Strings[0]);
          If lst.Count>1 then sTitre:=trim(lst.Strings[1]);
          nsI:=0;
          {end;
       2:begin
          sTitre:=Leftstr(sNomFich, length(sNomfich)-Length(sExt));
          sArtiste:=Rightstr(sCheminCourt, length(sChemincourt) - RPos('/', sCheminCourt));
          nSI:=40000;
          end;
       3:begin;
          sTitre:=Leftstr(sNomFich, length(sNomfich)-Length(sExt));
          sArtiste:=Rightstr(sCheminCourt, length(sChemincourt) - RPos('/', sCheminCourt));
          nSI:=0;
          end;
       end; }

     bExiste:= false;
     bExisteAilleurs:=false;
     bArtistExiste:=false;

           sql:= 'SELECT * FROM Morceaux, Dossiers WHERE Morceaux.NumDossier = Dossiers.NumDossier AND Morceaux.Filename = ''' + specialstr(sNomFich) + ''' And Dossiers.Chemin = ''' + specialstr(sCheminCourt) + ''';';
           FrmSearch.SQLQuery1.SQL.Text:= sql;
           FrmSearch.SQLQuery1.Open;
           If FrmSearch.SQLQuery1.RecordCount <> 0 Then
              bExiste:=true;
           FrmSearch.SQLQuery1.Close;


  If not bExiste then
     begin
        sql:= 'SELECT Morceaux.numfich, Dossiers.chemin, Dossiers.Numdossier FROM Morceaux, Dossiers WHERE Morceaux.NumDossier = Dossiers.NumDossier AND Morceaux.Filename = ''' + specialstr(sNomFich) + ''';';
           FrmSearch.SQLQuery1.SQL.Text:= sql;
           FrmSearch.SQLQuery1.Open;
           // vérif si le fichier n'est pas ailleurs (déplacé)
           If FrmSearch.SQLQuery1.RecordCount <> 0 Then
              bExisteAilleurs:=true
              else
               FrmSearch.SQLQuery1.Close;

           If bExisteAilleurs Then
              //EXISTE DEJA !!
              begin
                   //Showmessage(sNomfich + ' existe ailleurs');
                   Ledossier:=FrmSearch.SQLQuery1.FieldByName('chemin').AsString;
                   num:=FrmSearch.SQLQuery1.FieldByName('numfich').AsInteger;
                   Lepath:=  Ledossier +'/'+ specialstr(sNomFich);
                   // si fichier est dans un autre dossier

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
                         If Messagedlg('Ce fichier a peut-être été déplacé.','Le fichier '+specialstr(sNomFich)+' a disparu du dossier '+Ledossier+', a-t-il été déplacé dans '+sChemincourt+' ?',mtconfirmation,[mbYes, mbNo, mbIgnore],0) = mrYes then
                            begin
                                 FrmSearch.SQLQuery1.SQL.Clear;
                                 FrmSearch.SQLQuery1.SQL.Add('UPDATE Morceaux SET NumDossier = '+ inttostr(nDossier) +' WHERE NumFich=' + inttostr(num) + ';');
                                 FrmSearch.SQLQuery1.ExecSQL;
                                 Form1.SQLTransaction1.CommitRetaining;
                                 FrmSearch.SQLQuery1.close;
                            end;
                         end;
                     end
           else
               // si  n'existe pas encore, on crée
               begin

                    sql:= 'SELECT NumArtiste, NomArtiste FROM Artistes WHERE UPPER(NomArtiste) = :artiste;';
                    FrmSearch.SQLQuery1.SQL.Text:= sql;
                    FrmSearch.SQLQuery1.ParamByName('artiste').AsString := UpperCase(Leftstr(sArtiste, 50));
                    FrmSearch.SQLQuery1.Open;
                    If not FrmSearch.SQLQuery1.EOF Then
                       begin
                            bArtistExiste:=true;
                            nArtiste:= FrmSearch.SQLQuery1.FieldByName('NumArtiste').AsInteger;
                       end;
                    FrmSearch.SQLQuery1.Close;

                    If not bArtistExiste then
                    begin
                         //Showmessage(UpperCase(Leftstr(sArtiste, 50)) + ' n''existe pas encore, il est créé 1');
                         FrmSearch.SQLQuery1.SQL.Clear;
                         FrmSearch.SQLQuery1.SQL.Text:= 'INSERT INTO Artistes (NumArtiste, NomArtiste) VALUES ((SELECT MAX(NumArtiste) FROM Artistes)+ 1, :artiste);';
                         FrmSearch.SQLQuery1.ParamByName('artiste').AsString := Leftstr(sArtiste, 50);
                         FrmSearch.SQLQuery1.ExecSQL;
                         Form1.SQLTransaction1.CommitRetaining;
                         FrmSearch.SQLQuery1.close;
                         sql:= 'SELECT NumArtiste, NomArtiste FROM Artistes ORDER BY NumArtiste;';
                         FrmSearch.SQLQuery1.SQL.Text:= sql;
                         FrmSearch.SQLQuery1.Open;
                         FrmSearch.SQLQuery1.last;
                         If Leftstr(sArtiste, 50) = FrmSearch.SQLQuery1.FieldByName('NomArtiste').Asstring then nArtiste:= FrmSearch.SQLQuery1.FieldByName('NumArtiste').AsInteger;
                         FrmSearch.SQLQuery1.Close;
                    end;

                    //showmessage('5');

                    // Vérification de l'existence du dossier
                    bDossierExiste:=false;
                    FrmSearch.SQLQuery1.SQL.Text:='SELECT * FROM Dossiers Where Chemin = ''' + sCheminCourt + ''';';
                    FrmSearch.SQLQuery1.Open;
                    If not FrmSearch.SQLQuery1.EOF then
                       begin
                            bDossierExiste:=True;
                            nDossier:=FrmSearch.SQLQuery1.FieldByName('Numdossier').AsInteger;
                       end;
                    FrmSearch.SQLQuery1.Close;

                    If not bDossierExiste then
                       begin
                            FrmSearch.SQLQuery1.SQL.Clear;
                            FrmSearch.SQLQuery1.SQL.text:='INSERT INTO Dossiers (NumDossier, Chemin, NumCat) VALUES ((SELECT MAX(NumDossier) FROM Dossiers) + 1, :chemin, 0);';
                            FrmSearch.SQLQuery1.ParamByName('chemin').AsString:=sCheminCourt;
                            FrmSearch.SQLQuery1.ExecSQL;
                            Form1.SQLTransaction1.CommitRetaining;
                            FrmSearch.SQLQuery1.close;

                            FrmSearch.SQLQuery1.SQL.text:='SELECT * FROM Dossiers ORDER BY NumDossier;';
                            FrmSearch.SQLQuery1.Open;
                            If not FrmSearch.SQLQuery1.EOF then
                               begin
                                    FrmSearch.SQLQuery1.Last;
                                    nDossier:=FrmSearch.SQLQuery1.FieldByName('Numdossier').AsInteger;
                               end;
                            FrmSearch.SQLQuery1.Close;
                       end;


                    //ajout dans la base du nouveau morceau
                    FrmSearch.SQLQuery1.SQL.Clear;
                    FrmSearch.SQLQuery1.SQL.Add('INSERT INTO Morceaux (NumFich, Titre, NumArtiste, NumCat, NumGenre, Annee, Duree, NumDossier, Filename, DerniereDiffusion, PS, Intro, SurImpression, tempo1, tempo2, actif) ');
                    FrmSearch.SQLQuery1.SQL.Add('VALUES ((SELECT MAX(NumFich) FROM Morceaux)+ 1, :titre, ' + inttostr(nArtiste) + ', ' + inttostr(nCat) + ', 12, '''', 0, ' + inttostr(nDossier) + ', :nomfich, ''1900-01-01 12:00:00'', 0, 0, ' + inttostr(nSI) + ', 2, 2, 0);');
                    FrmSearch.SQLQuery1.ParamByName('titre').AsString := sTitre;
                    FrmSearch.SQLQuery1.ParamByName('nomfich').AsString := sNomFich;

                    //showmessage(sTitre + ' inséré');
                    FrmSearch.SQLQuery1.ExecSQL;
                    Form1.SQLTransaction1.CommitRetaining;
                    FrmSearch.SQLQuery1.close;
                    Result:=True;
               end
     end
  else
      begin
         Result:=False;
      end;

  finally
         lst.free;
  end;
end;



Function searchforfiles (sCheminCourt : string; nCat: integer; nDossier: integer):integer;
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

  FrmSearch.ProgressBar1.Max:=nbFile;
  FrmSearch.ProgressBar1.position:=0;


  // Recherche de la première entrée du répertoire
  If FindFirst(Chemin+'*.*',faAnyFile,S)=0
  Then Begin
    FrmSearch.LabelDossier.caption:= Chemin;
    Repeat
      // Il faut absolument dans le cas d'une procédure récursive ignorer
      // les . et .. qui sont toujours placés en début de répertoire
      // Sinon la procédure va boucler sur elle-même.
      If (S.Name<>'.')And(s.Name<>'..')
      Then Begin
        If (S.Attr And faDirectory)<>0
          // Dans le cas d'un sous-repertoire on appelle la même procédure
          Then Result:= Result + searchforfiles(Chemin+S.Name, nCat, nDossier)
          // Sinon on compte simplement le fichier
          Else
            begin
              sFile:=Chemin + S.Name;
              sExt:= UpperCase(ExtractFileExt(sFile));
              FrmSearch.ProgressBar1.position:=FrmSearch.ProgressBar1.position+1;
              FrmSearch.LabelCounter.caption:= 'Vérification du fichier ' + inttostr(FrmSearch.ProgressBar1.position) + ' sur ' + inttostr(nbFile);
              Application.ProcessMessages;
              If (sExt='.MP3') or (sExt='.WAV') or (sExt='.OGG') or (sExt='.FLAC') or (sExt='.M4A') then
                  begin
                    If InfoMP3(sFile, ExtractFileName(sFile), ExtractFilePath(sFile), sExt, nCat, nDossier) then Inc(Result);
                  end

            end;
      End;
    // Recherche du suivant
    Until FindNext(S)<>0;
    FindClose(S);
  End;


end;

{ TFrmSearch }




procedure TFrmSearch.CmdValideClick(Sender: TObject);
begin
  FrmSearch.Close;
end;

procedure TFrmSearch.FormActivate(Sender: TObject);
var
  sql:string;
  sChemin: string;
  nCat, n, nDossier: integer;
begin

  //ListBox1.Items.add('coucou');
  //Application.ProcessMessages;


  FrmSearch.CmdValide.Enabled:=false;
    Screen.Cursor:=crHourglass;

    Case FrmSearch.Tag of
      0:sql:= 'SELECT * FROM dossiers ORDER BY NumDossier;';
      else sql:= 'SELECT * FROM dossiers WHERE NumDossier = ' + inttostr(FrmSearch.tag) + ';';
    end;

    ListBox1.Clear;
    SQLQuery3.SQL.Text:=sql;
    Application.ProcessMessages;

    SQLQuery3.Open;
    While not SQLQuery3.EOF do
          begin
             sChemin:= SQLQuery3.FieldByName('Chemin').AsString; // TObject(SQLQuery3.FieldByName('NumDossier').AsInteger));
             nCat:= SQLQuery3.FieldByName('numcat').Asinteger;
             nDossier:=SQLQuery3.FieldByName('numDossier').Asinteger;
             n:=searchforfiles(sChemin, nCat, nDossier);
             If n = 1 then ListBox1.Items.add('1 fichier a été ajouté à la base dans '+ sChemin)
                  else if n > 1 then ListBox1.Items.add(inttostr(n) + ' fichiers ont été ajoutés à la base dans '+ sChemin);
             SQLQuery3.Next;
          end;

    SQLQuery3.close;
    Screen.Cursor:=crDefault;
    FrmSearch.CmdValide.Enabled:=true;

end;

procedure TFrmSearch.FormCreate(Sender: TObject);
begin
  SQLQuery1.DataBase := Form1.SQLite3Connection1;
  SQLQuery1.UsePrimaryKeyAsKey := False;

  SQLQuery3.DataBase := Form1.SQLite3Connection1;
  SQLQuery3.UsePrimaryKeyAsKey := False;
end;

procedure TFrmSearch.FormShow(Sender: TObject);
begin

end;





end.

