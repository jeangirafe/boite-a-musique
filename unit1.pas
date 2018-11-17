unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  uos_flat, Classes, SysUtils, odbcconn, sqldb, sqlite3conn, FileUtil, Forms,
  Controls, Graphics, Dialogs, StdCtrls, Grids, ExtCtrls, ComCtrls, Buttons,
  DateUtils, types, inifiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    CmdPause: TBitBtn;
    CmdGenererPlaylist: TBitBtn;
    CmdDisco: TBitBtn;
    CmdParam: TBitBtn;
    Image1: TImage;
    GridProg: TStringGrid;
    LabelPOS: TStaticText;
    LabelTOT: TStaticText;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ProgressBar1: TProgressBar;
    SQLQuery2: TSQLQuery;
    VuLeft: TProgressBar;
    SQLite3Connection1: TSQLite3Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    Timer1: TTimer;
    TimerFade: TTimer;
    VuRight: TProgressBar;
    procedure CmdDiscoClick(Sender: TObject);
    procedure CmdGenererPlaylistClick(Sender: TObject);
    procedure CmdParamClick(Sender: TObject);
    procedure CmdPauseClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure ODBCConnection1AfterConnect(Sender: TObject);
    procedure ProgressBar1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ProgressBar1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ProgressBar1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure TimerFadeTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;





  var
    {BufferBMP: TBitmap;
    nPlayer : integer;
    OutputIndex1, InputIndex1, DSPIndex1, DSPIndex2, PluginIndex1, PluginIndex2: integer;
    plugsoundtouch : boolean = false;
    plugbs2b : boolean = false;}
    Form1: TForm1;

implementation

uses
  unitDisco, UnitParam, unitson, unitSearch;
{$R *.lfm}

{ TForm1 }

Function EtatFade(nLigne : integer):integer;
begin
    if Form1.GridProg.Cells[7,nLigne]<>'' then result:=strtoint(Form1.GridProg.Cells[7,nLigne])
    else result:=-1;
end;

Function NumPlayer(nLigne : integer):integer;
begin
    if Form1.GridProg.Cells[6,nLigne]<>'' then result:=strtoint(Form1.GridProg.Cells[6,nLigne])
    else result:=-1;
end;


Function Nivolume(nLigne : integer):double;
begin
    if Form1.GridProg.Cells[3,nLigne]<>'' then result:=strtofloat(Form1.GridProg.Cells[3,nLigne])
    else result:=1;
end;

Function NumLigne(nPlayer : Integer) : Integer;
var
  n : Integer;
  bTrouve : Boolean;
begin
     bTrouve:= False;

     n:=Form1.GridProg.Rowcount - 1;
     While n>= 0 do
         begin
              If NumPlayer(n) = nPlayer Then
                 begin
                   bTrouve:= True;
                   Break;
                 end;
              n:=n-1;
         End;

If bTrouve Then result:= n else result:= -1;
End;


Function nEcartTitre(nCat :integer):integer;
var
  nJ, nH, nM:integer;
  inifile:Tinifile;
begin
     inifile:= TIniFile.Create('JBox.ini');
     nJ:= inifile.ReadInteger('Ecart', 'TitreJour' + inttostr(nCat), 0);
     nH:= inifile.ReadInteger('Ecart', 'TitreHeure' + inttostr(nCat), 0);
     nM:= inifile.ReadInteger('Ecart', 'TitreMinute' + inttostr(nCat), 0);
     result:= (nJ * 1440) + (nH * 60) + nM;
end;


Function nEcartArtiste(nCat :integer):integer;
var
  nJ, nH, nM:integer;
  inifile:Tinifile;
begin
     inifile:= TIniFile.Create('JBox.ini');
     nJ:= inifile.ReadInteger('Ecart', 'ArtisteJour' + inttostr(nCat), 0);
     nH:= inifile.ReadInteger('Ecart', 'ArtisteHeure' + inttostr(nCat), 0);
     nM:= inifile.ReadInteger('Ecart', 'ArtisteMinute' + inttostr(nCat), 0);
     result:= (nJ * 1440) + (nH * 60) + nM;
end;

Function NumCat(nLigne : integer):integer;
begin
    if Form1.GridProg.Cells[11,nLigne]<>'' then result:=strtoint(Form1.GridProg.Cells[11,nLigne])
    else result:=-1;
end;

Function NumID(nLigne : integer):integer;
begin
    if Form1.GridProg.Cells[5,nLigne]<>'' then result:=strtoint(Form1.GridProg.Cells[5,nLigne])
    else result:=-1;
end;

Function LastDiff(nCat : integer):TDatetime;
var
  sql:string;
  nDuree: integer;
begin
    sql:= 'SELECT DerniereDiffusion, Duree, PS FROM Morceaux WHERE NumCat = ' + inttostr(nCat) + ' ORDER BY DerniereDiffusion;';
    Form1.SQLQuery2.SQL.Text:=sql;
    Form1.SQLQuery2.Open;
    If not Form1.SQLQuery2.EOF then
       begin
         Form1.SQLQuery2.last;
         nDuree:=Trunc((Form1.SQLQuery2.FieldByName('Duree').AsInteger - Form1.SQLQuery2.FieldByName('PS').AsInteger)/1000);
         If nDuree < 0 then nDuree:=0;
         result:=IncSecond(Form1.SQLQuery2.FieldByName('DerniereDiffusion').AsDateTime, nDuree);
       end
    else
        result:=strtodatetime('1900-01-01 12:00:00');
    Form1.SQLQuery2.Close;
end;
Function GetHoraireDebut(nLigne: integer):TDatetime;
var
    nCat, nIntro, nIntroPrec, nCatPrec, nDureePrec, nPSPrec, nSIprec: integer;
    debutPrec: Tdatetime;
begin
     nCat:= NumCat(nLigne);
     nIntro:= strtoint(Form1.GridProg.Cells[13,nLigne]);
     nIntroPrec:= strtoint(Form1.GridProg.Cells[13,nLigne - 1]);
     nCatPrec:= NumCat(nLigne - 1);
     nDureePrec:= strtoint(Form1.GridProg.Cells[12,nLigne - 1]);
     nPSPrec:=strtoint(Form1.GridProg.Cells[8,nLigne - 1]);
     nSIprec:= strtoint(Form1.GridProg.Cells[14,nLigne - 1]);
     case nCat of
          1:begin
                 If nCatPrec = 1 then
                    nDureePrec:= nDureePrec - nPSPrec
                 else
                     begin
                          if nSIPrec < nPSPrec then nSIPrec:=nPSPrec;
                          if nIntro < nSIPrec then nDureePrec:= nDureePrec - (nPSPrec + Nintro)
                          else nDureePrec:= nDureePrec - nSIPrec;
                     end;
                     end;
            else
                if ((nCatPrec = 4) and (nCat = 2)) then nDureePrec:= nIntroPrec  else nDureePrec:= nDureePrec - nPSPrec;
     end;
     If Form1.GridProg.Cells[10, nLigne - 1] <> '' then debutPrec:= strtodatetime(Form1.GridProg.Cells[10,nLigne - 1])
     else debutPrec:=strtodatetime(Form1.GridProg.Cells[16, nLigne - 1]);
     result:=IncSecond(debutPrec, Trunc(nDureePrec/1000));
end;

Function FindePlaylist():Tdatetime;
var
    i:integer;
    heuredeb: tDatetime;
    nDuree: integer;
    nPS: integer;
begin
     i:=Form1.gridProg.rowcount - 1;
     While i>=0 do
         If Form1.GridProg.Cells[16, i]<> '' then break else i:= i - 1;
     If i = -1 then
        begin
          result:=Now;
          exit;
        end;
     If (i = 0) and (Form1.GridProg.Cells[16, i]= '') then result:=now
     else
         begin
              heuredeb:=strtodatetime(Form1.GridProg.Cells[16, i]);
              nDuree:=strtoint(Form1.GridProg.Cells[12, i]);
              nPS:=strtoint(Form1.GridProg.Cells[8, i]);
              nDuree:=nDuree - nPS;
              result:= IncSecond(heuredeb, Trunc(nDuree / 1000));
         end;
end;

Function bInter(nCat: integer):boolean;
var
  nEcartCAT : integer;
  nEcartJC : integer;
  date1, date2, date3 : TDatetime;
  i : integer;
  nDuree : integer;
  iniFile: Tinifile;
begin
     inifile:= TIniFile.Create('JBox.ini');
     nEcartCAT:= iniFile.readinteger('Ecart', 'Mini'+ inttostr(nCat), 0); // savoir si oui ou non, l'écart mini a été dépassé entre 2 morceaux de même catégorie
     nEcartJC:= iniFile.readinteger('Ecart', 'JC', 0);      // savoir si oui ou non, l'écart mini a été dépassé entre 1 jingle et 1 capsule
  If ((nEcartCAT = 0) And (nEcartJC = 0)) Or ((numcat(Form1.GridProg.Rowcount - 2) = 2) or (numcat(Form1.GridProg.Rowcount - 2) = 3)) Then
    result:= False
  Else
    begin
         date2:= FindePlaylist();
         date1:= LastDiff(nCat);
         If nCat=2 then
            date3:= LastDiff(3)
         Else
             date3:= LastDiff(2);

         //showmessage('Playlist se terminera à ' + datetimetostr(date2) + ' - Le dernier ' + inttostr(nCat) + ' a été diffusé ' + datetimetostr(date1));
         //showmessage(inttostr(SecondsBetween(date1, date2)));

          If (SecondsBetween(date1, date2) >= (nEcartCAT * 60)) AND (SecondsBetween(date3, date2) >= (nEcartJC * 60)) Then
             begin
                  result:= True;
                  //Form1.ListBox2.Items.Add(inttostr(ncat) + ' ok');
             end
          Else
              begin
                 result:= False;
                 //Form1.ListBox2.Items.add(inttostr(ncat) + ' PAS ok');
              end;
    End;
  End;

Procedure SetVolume(nLigne : integer; p: integer; nNiv: double);
begin
    Form1.GridProg.Cells[3,nLigne]:= Floattostr(nNiv);
    uos_InputSetDSPVolume(p, InputIndex1, nNiv, nNiv, true);

end;

Procedure SetVUmetre(p: integer);
var
  volLeft: double;
  volRight: double;
begin
   volLeft:=uos_InputGetLevelLeft(p, InputIndex1);
   Form1.VuLeft.position:= trunc(VolLeft *  Form1.VuLeft.max);
   volRight:=uos_InputGetLevelRight(p, InputIndex1);
   Form1.VuRight.position:= trunc(VolRight *  Form1.VuRight.max);


end;

Function ChargePlayer(LePath: string):integer;
var
   n: integer;
   nPlayer: integer;
   nStatus : integer;
   s: string;
begin
     result:=-1;
     For nPlayer:=1 to 5 do
          begin
               /////// Get the status of the player : -1 => error, 0 => has stopped, 1 => is running, 2 => is paused.
          s:= s + inttostr(nPlayer) + ' : ' + inttostr(uos_GetStatus(nPlayer)) + ' / ';
          if (uos_GetStatus(nPlayer) <> 1) And (Numligne(nPlayer) = -1) then
              begin
                   uos_CreatePlayer(nPlayer); /// you may create how many players you want, from 0 to to what you computer can do...
                   /// OLD uos_AddIntoDevOut(nPlayer);   //// Add Output with default parameter
                   If Fileexists(LePath) then
                     begin
                          result:=nPlayer;
                          /// OLD InputIndex1 := uos_AddFromFile(nPlayer, PChar(LePath));
                          /// OLD uos_InputSetPositionEnable(nPlayer, InputIndex1, 1) ;
                          /// OLD uos_InputSetDSP(nPlayer, inputIndex1, 1, true);
                          /// OLD uos_InputSetLevelEnable(nPlayer, InputIndex1, 3) ;


                          //// add input from audio file with custom parameters
                          //////////// PlayerIndex : Index of a existing Player
                          ////////// FileName : filename of audio file
                          ////////// OutputIndex : OutputIndex of existing Output // -1 : all output, -2: no output, other integer : existing output)
                          ////////// SampleFormat : -1 default : Int16 : (0: Float32, 1:Int32, 2:Int16) SampleFormat of Input can be <= SampleFormat float of Output
                          //////////// FramesCount : default : -1 (65536)
                          //  result : -1 nothing created, otherwise Input Index in array
                          InputIndex1 := uos_AddFromFile(nPlayer, PChar(LePath), -1, 0, 1024);

                          ///// DSP Volume changer
                          ////////// PlayerIndex1 : Index of a existing Player
                          ////////// In1Index : InputIndex of a existing input
                          ////////// VolLeft : Left volume  ( from 0 to 1 => gain > 1 )
                          ////////// VolRight : Right volume
                          uos_InputAddDSPVolume(nPlayer, InputIndex1, 1, 1);

                          //// add a Output with custom parameters
                          //// add a Output into device with custom parameters
                          //////////// PlayerIndex : Index of a existing Player
                          //////////// Device ( -1 is default Output device )
                          //////////// Latency  ( -1 is latency suggested ) )
                          //////////// SampleRate : delault : -1 (44100)
                          //////////// Channels : delault : -1 (2:stereo) (0: no channels, 1:mono, 2:stereo, ...)
                          //////////// SampleFormat : -1 default : Int16 : (0: Float32, 1:Int32, 2:Int16)
                          //////////// FramesCount : default : -1 (65536)
                          // ChunkCount : default : -1 (= 512)
                          //  result : -1 nothing created, otherwise Output Index in array
                          {$if defined(cpuarm)} // needs lower latency
                          uos_AddIntoDevOut(nPlayer, -1, 0.3, -1, -1, 0, 1024, -1);
                          {$else}
                          uos_AddIntoDevOut(nPlayer, -1, -1, -1, -1, 0, 1024, -1);
                          {$endif}

                          /////// procedure to execute when stream is terminated
                          //uos_EndProc(nPlayer, @ClosePlayer0);
                          ///// Assign the procedure of object to execute at end
                          //////////// PlayerIndex : Index of a existing Player
                          //////////// ClosePlayer1 : procedure of object to execute inside the loop

                          uos_InputSetPositionEnable(nPlayer, InputIndex1, 1) ;
                          uos_InputSetLevelEnable(nPlayer, InputIndex1, 3) ;

                     end;
                   break;
              end;
          end;
          //showmessage(s);


end;

Procedure MAJ_Pochette(nLigne : integer);
var
  sArtiste: string;
  sTitre: string;
  sFile: string;
  iniFile: Tinifile;
begin
     inifile:= TIniFile.Create('JBox.ini');
  sFile:= inifile.ReadString('Pochettes', 'chemin', '\home') + '/' + Form1.GridProg.cells[5,nLigne] + '.jpg';
  sArtiste:= Form1.GridProg.cells[1,nLigne];
  sTitre:= Form1.GridProg.cells[2,nLigne];
  If sTitre <> '' then Form1.Caption:= sArtiste + ' - ' + sTitre
  else Form1.Caption:=sArtiste;
  Form1.Image1.Hint:= sArtiste + #13#10 + sTitre + #13#10 + Form1.GridProg.Cells[18,nLigne] + ' (' + Form1.GridProg.Cells[15,nLigne] + ')';
  If fileexists(sFile) then Form1.Image1.Picture.LoadFromFile(sFile) else form1.Image1.Picture.Clear;

End;

Procedure MAJ_Diff(nLigne : integer);
var
  sDate: TdateTime;
  i: integer;
begin
//Enregistrement de la diffusion
    Form1.SQLQuery1.SQL.Clear;
    Form1.SQLQuery1.SQL.Text:= 'UPDATE Morceaux SET DerniereDiffusion = ''' + FormatDateTime('yyyy-mm-dd hh:nn:ss',Now) + ''' WHERE NumFich =' + inttostr(numID(nLigne)) + ';';
    Form1.SQLQuery1.ExecSQL;
    Form1.SQLTransaction1.CommitRetaining;
    Form1.SQLQuery1.close;
//Inscription dans la grille
Form1.GridProg.cells[10,nLigne]:= FormatDateTime('dd-mm-yyyy hh:nn:ss', Now); //datetostr(Now);
Form1.GridProg.cells[16,nLigne]:= FormatDateTime('dd-mm-yyyy hh:nn:ss', Now);

// Mise à jour de l'horaire pour les lignes suivantes
For i:= nLigne to Form1.GridProg.rowcount - 1 do
     if i <> nLigne then
          If Form1.GridProg.Cells[0,i]<>'' then Form1.GridProg.cells[16,i]:= FormatDateTime('dd-mm-yyyy hh:nn:ss', GetHoraireDebut(i));

End;

Procedure StopSon;
begin
    //uos_stop(p);
    //Form1.GridProg.cells[6, nLigne]:= '';
end;

Procedure PlaySon(nLigne: integer);
var
   nPlayer: integer;
   samformat: shortint;
   temptime: ttime;
   ho, mi, se, ms: word;
begin
     If Form1.GridProg.Cells[6,nLigne]<>'' then
       begin
            nPlayer:=strtoint(Form1.GridProg.Cells[6,nLigne]);
            uos_Play(nPlayer);
            temptime:= uos_InputLengthTime(nPlayer, inputIndex1 );
            DecodeTime(temptime, ho, mi, se, ms);
            Form1.labeltot.tag:= integer(mi + 1000*se + 60000*mi + 3600000*ho);
            Form1.LabelTOT.caption:= format('%.2d:%.2d:%.2d.%.3d', [ho, mi, se, ms]);

       end;
end;

Procedure MAJ_Prog(nLigne:integer; nId : Integer; sArtist : string; sTitre : string; sFichier : string; nCat:integer; nGenre: integer; nDuree : integer; nIntro :integer; nPS :integer; nSI:integer; nEntame:integer; tempo1:integer; tempo2:integer; sAnnee:string; sPays: string; nArtiste: integer; nFade: integer);
var
   nCatprec:integer;
   nDureePrec:integer;
   nSIPrec:integer;
   nPSPrec:integer;
   debutPrec, finPrec :Tdatetime;
begin

        Form1.GridProg.Cells[0,nLigne]:= sFichier;
        Form1.GridProg.Cells[1,nLigne]:= sArtist;
        Form1.GridProg.Cells[2,nLigne]:= sTitre;
        Form1.GridProg.Cells[3,nLigne]:= '1'; // VOLUME        'Genre'; //stringGenre(nGenre)
        Form1.GridProg.Cells[4,nLigne]:= inttostr(nGenre);
        Form1.GridProg.Cells[5,nLigne]:= inttostr(nId);
        //n° player
        Form1.GridProg.Cells[6,nLigne]:= '';
        //état du fade
        Form1.GridProg.Cells[7,nLigne]:= '0';
        //PS
        Form1.GridProg.Cells[8,nLigne]:= inttostr(nPS);
        //tempo1
        Form1.GridProg.Cells[9,nLigne]:= inttostr(Tempo1);
        //Diffusion réelle

        //numéro de Catégorie (musique/interlude...)
        Form1.GridProg.Cells[11,nLigne]:= inttostr(nCat);
        Form1.GridProg.Cells[12,nLigne]:= inttostr(nDuree); //en ms
        Form1.GridProg.Cells[13,nLigne]:= inttostr(nIntro);
        Form1.GridProg.Cells[14,nLigne]:= inttostr(nSI);
        Form1.GridProg.Cells[15,nLigne]:= sAnnee;
        If nLigne = 0 then
          Form1.GridProg.Cells[16,nLigne]:= FormatDateTime('dd-mm-yyyy hh:nn:ss', Now)
        else
          Form1.GridProg.Cells[16,nLigne]:= FormatDateTime('dd-mm-yyyy hh:nn:ss', GetHoraireDebut(nLigne));

        Form1.GridProg.Cells[17,nLigne]:= inttostr(Tempo2);
        Form1.GridProg.Cells[18,nLigne]:= sPays;
        Form1.GridProg.Cells[19,nLigne]:= inttostr(nArtiste);
        Form1.GridProg.Cells[20,nLigne]:= inttostr(nEntame);
        Form1.GridProg.Cells[21,nLigne]:= inttostr(nFade);

          {begin
               nCatPrec:= NumCat(nLigne - 1);
               nDureePrec:= strtoint(Form1.GridProg.Cells[12,nLigne - 1]);
               nPSPrec:=strtoint(Form1.GridProg.Cells[8,nLigne - 1]);
               nSIprec:= strtoint(Form1.GridProg.Cells[14,nLigne - 1]);
               case nCat of
                    1:begin
                    If nCatPrec = 1 then
                      nDureePrec:= nDureePrec - nPSPrec
                    else
                        begin
                             if nSIPrec < nPSPrec then nSIPrec:=nPSPrec;
                             if nIntro < nSIPrec then nDureePrec:= nDureePrec - (nPSPrec + Nintro)
                             else nDureePrec:= nDureePrec - nSIPrec;
                        end;
                        end;
               else nDureePrec:= nDureePrec - nPSPrec
               end;
               If Form1.GridProg.Cells[10, nLigne - 1] <> '' then debutPrec:= strtodatetime(Form1.GridProg.Cells[10,nLigne - 1])
               else debutPrec:=strtodatetime(Form1.GridProg.Cells[16, nLigne - 1]);
               finprec:=IncSecond(debutPrec, Trunc(nDureePrec/1000));
               Form1.GridProg.Cells[16,nLigne]:=datetimetostr(finprec);
          end;}





end;

//Function Requete_Morceau(nLigne : integer; nId : Integer; sArtist : string; sTitre : string; sFichier : string; nCat:integer; nGenre: integer; nDuree : integer; nIntro :integer; nPS :integer; nSI:integer; tempo:integer; nIDprec:integer; sAnnee:string):boolean;
Function Requete_Morceau(nLigne : integer; nCat:integer; tempo2:integer; nIDprec: integer; nGenrePrec: integer):boolean;
var
   sql, sql1, sql2, sql3, sql4, sql5, sql6, sql7, sql8 :string;
   sDate1: string;
   sDate2: string;
   sDate3, sDate4: string;
   nChoix: integer;
   nPourcent: integer;
   nOrdre: boolean;
   n, nA1, nA2: integer;

   nId: Integer;
   nArtiste: integer;
   sFichier, sFichier2: String;
   sArtist: String;
   sTitre: String;
   nGenre : Integer;
   nPS : Integer;
   nIntro : Integer;
   nDuree : Integer;
   nSI : Integer;
   nEntame : Integer;
   nInstru: integer;
   nFade: integer;
   tempo1 : integer;
   tHoraire: TDatetime;
   bHoraire: integer;
   brqst: boolean;

   sAnnee : String;
   sPays: string;

   inifile: Tinifile;
begin
     inifile:= TIniFile.Create('JBox.ini');
     bHoraire:=1;
     brqst:=false;
     //While Form1.SQLQuery1.EOF do
     While brqst = false do
         begin
            Form1.SQLQuery1.close;
            If (nCat = 2) and (not bInter(2)) then nCat:=1;
            //If ((nCat = 2) and (not bEcartJC(3))) or ((nCat = 3) and (not bEcartJC(2))) then nCat:=1;

            If ((nCat = 3) and (bHoraire = 1)) then
               sql1:='SELECT Morceaux.Numfich, Morceaux.titre, Morceaux.Annee, Morceaux.Filename, Morceaux.Duree, Morceaux.PS, Morceaux.Intro, Morceaux.SurImpression, Morceaux.Numcat, Morceaux.Numgenre, Morceaux.tempo1, Morceaux.tempo2, Artistes.NumArtiste, Artistes.NomArtiste, Morceaux.Actif, Morceaux.Entame, Morceaux.Fade, Dossiers.Chemin, Dossiers.Instru, Tops.Horaire, Tops.Offset, Artistes.Pays, (Dossiers.EJ*1440 + Dossiers.EH*60 + Dossiers.EM) AS ECART FROM Artistes, Morceaux, Dossiers, Tops WHERE (Artistes.NumArtiste = Morceaux.NumArtiste) AND (Morceaux.Numdossier=Dossiers.Numdossier) AND (Tops.Numtop = Morceaux.NumFich) '
            else sql1:= 'SELECT Morceaux.Numfich, Morceaux.titre, Morceaux.Annee, Morceaux.Filename, Morceaux.Duree, Morceaux.PS, Morceaux.Intro, Morceaux.SurImpression, Morceaux.Numcat, Morceaux.Numgenre, Morceaux.tempo1, Morceaux.tempo2, Artistes.NumArtiste, Artistes.NomArtiste, Morceaux.Actif, Morceaux.Entame, Morceaux.Fade, Dossiers.Chemin, Dossiers.Instru, Artistes.Pays, (Dossiers.EJ*1440 + Dossiers.EH*60 + Dossiers.EM) AS ECART FROM Artistes, Morceaux, Dossiers WHERE (Artistes.NumArtiste = Morceaux.NumArtiste) AND (Morceaux.Numdossier=Dossiers.Numdossier) ';
                 //else sql1:= 'SELECT Morceaux.Numfich, Morceaux.titre, Morceaux.Annee, Morceaux.Filename, Morceaux.Duree, Morceaux.PS, Morceaux.Intro, Morceaux.SurImpression, Morceaux.Numcat, Morceaux.Numgenre, Morceaux.tempo1, Morceaux.tempo2, Artistes.NumArtiste, Artistes.NomArtiste, Morceaux.Actif, Morceaux.Entame, Morceaux.Fade, Dossiers.Chemin, Artistes.Pays FROM Artistes, Morceaux, Dossiers WHERE (Artistes.NumArtiste = Morceaux.NumArtiste) AND (Morceaux.Numdossier=Dossiers.Numdossier) ';


            case tempo2 of
                 0:sql2:= ' AND Morceaux.tempo1 <> 2 AND Morceaux.tempo1 <> 3';
                 1:sql2:= ' AND Morceaux.tempo1 <> 3';
                 2:sql2:= ' AND Morceaux.tempo1 <> 0';
                 3:sql2:= ' AND Morceaux.tempo1 <> 0 AND Morceaux.tempo1 <> 1';
            end;

            If nCat <> 0 Then sql3:= ' AND Morceaux.NumCat = ' + inttostr(nCat);

            tHoraire:=FindePlaylist;
            sDate1:=FormatDateTime('yyyy-MM-dd hh:nn:ss', IncMinute(tHoraire, -1 * necartTitre(nCat)));
            sDate2:=FormatDateTime('yyyy-MM-dd hh:nn:ss', IncMinute(tHoraire, -1 * necartArtiste(nCat)));
            sDate3:=FormatDateTime('hh:nn:ss', IncMinute(tHoraire, -2));
            sDate4:=FormatDateTime('hh:nn:ss', IncMinute(tHoraire, 2));

            If nLigne>0 then nA1:=strtoint(Form1.GridProg.Cells[19,nLigne-1]);
            If nLigne>1 then nA2:=strtoint(Form1.GridProg.Cells[19,nLigne-2]);

            //sql4:= ' AND Morceaux.DerniereDiffusion < ''' + sDate1 + ''' AND Morceaux.NumArtiste NOT IN (SELECT Morceaux.NumArtiste FROM Morceaux WHERE Morceaux.DerniereDiffusion > ''' + sDate2 + ''' ) ';

            sql4:= ' AND Morceaux.Numfich NOT IN ( SELECT Morceaux.Numfich FROM Morceaux, Dossiers WHERE Morceaux.Numdossier=Dossiers.Numdossier AND (CAST((JulianDay(''' + FormatDateTime('yyyy-MM-dd hh:nn:ss', tHoraire) + ''')  - JulianDay(Morceaux.Dernierediffusion))*1400 AS INTEGER) < (Dossiers.ETJ*1440 + Dossiers.ETH*60 + Dossiers.ETM))) ';
            sql4:= ' AND Morceaux.NumArtiste NOT IN ( SELECT Morceaux.NumArtiste FROM Morceaux, Dossiers WHERE Morceaux.Numdossier=Dossiers.Numdossier AND (CAST((JulianDay(''' + FormatDateTime('yyyy-MM-dd hh:nn:ss', tHoraire) + ''')  - JulianDay(Morceaux.Dernierediffusion))*1400 AS INTEGER) < (Dossiers.EAJ*1440 + Dossiers.EAH*60 + Dossiers.EAM))) ';
            sql4:= sql4 + ' AND Morceaux.NumArtiste <> ' + inttostr(nA1) + ' AND Morceaux.NumArtiste <> ' + inttostr(nA2) + ' ';

            if ((nCat = 3) And (bHoraire = 1)) then sql5:= ' AND Tops.horaire > ''' + sDate3 + ''' AND Tops.Horaire < ''' + sDate4 + ''' '
            else sql5:= ' AND Morceaux.Top = 0 ';
            //showmessage(sql5);

            //sql6:= ' AND (CAST(JulianDay(''' + FormatDateTime('yyyy-MM-dd hh:nn:ss', tHoraire) + ''')  - JulianDay(Morceaux.Dernierediffusion) AS INTEGER)*1440) > ECART ';
            sql6:= ' AND Morceaux.Numdossier NOT IN ( SELECT Morceaux.Numdossier FROM Morceaux, Dossiers WHERE Morceaux.Numdossier=Dossiers.Numdossier AND (CAST((JulianDay(''' + FormatDateTime('yyyy-MM-dd hh:nn:ss', tHoraire) + ''')  - JulianDay(Morceaux.Dernierediffusion))*1400 AS INTEGER) < (Dossiers.EJ*1440 + Dossiers.EH*60 + Dossiers.EM))) ';
             //(CAST((JulianDay('2018-04-29 19:57:00')  - JulianDay(Morceaux.Dernierediffusion))*1400 AS INTEGER)  < (Dossiers.EJ*1440 + Dossiers.EH*60 + Dossiers.EM))

            If (inifile.ReadInteger('Parametres', 'Transitions', 0)= 1) AND (nGenrePrec <>0) then
              sql7:= ' AND Morceaux.Numdossier IN (SELECT Transitions.NumGenre2 FROM Transitions WHERE Transitions.NumGenre1 = ' + inttostr(nGenrePrec) + ') ';

            If nIDprec <> 0 Then sql8:= ' AND Morceaux.Numfich <> ' + inttostr(nIDprec);
            sql8:= sql8 + ' AND Morceaux.actif = 1 ORDER BY Morceaux.Dernierediffusion'; //ORDER BY Morceaux.NumFich;';

              Case inifile.ReadInteger('Parametres', 'Ordre', 1) of
                   0:nOrdre:= false;
                   1:nOrdre:= true;
              end;
            If nOrdre then sql8:= sql8 + ', NumFich DESC;'
            Else sql8:= sql8 + ';';

            sql:= sql1 + sql2 + sql3 + sql4 + sql5 + sql6 + sql7 + sql8;

            Form1.SQLQuery1.SQL.Text:=sql;
            Form1.SQLQuery1.Open;

            If Form1.SQLQuery1.eof then
               begin
                    Form1.ListBox1.Items.Add('Echec de la requête sur la catégorie ' + inttostr(nCat));
                    Case nCat of
                         1:break;
                         2:nCat:=1;
                         3:if bHoraire = 1 then bHoraire:=0 else nCat:=2;
                    end;
                    brqst:=false;
               end
            else
                begin
                   Form1.SQLQuery1.Last;
                   nChoix:=Form1.SQLQuery1.RecordCount;
                   nPourcent:=inifile.ReadInteger('Parametres', 'PourcentSelect', 10);
                   nChoix:=Trunc((nPourcent/100)*nChoix);
                   n:= Random(nChoix);
                   Form1.SQLQuery1.First;
                   If nCat = 1 then Form1.SQLQuery1.MoveBy(n);
                   While brqst = false do
                      begin
                           sFichier:= Form1.SQLQuery1.FieldByName('Chemin').AsString+'/'+Form1.SQLQuery1.FieldByName('Filename').AsString;
                           If fileexists(sFichier) then brqst:=true
                           else
                               begin
                                    brqst:=false;
                                    Form1.SQLQuery1.Next;
                                    If Form1.SQLQuery1.EOF then break;
                               end;
                      end;
                end;


            end;

     //on tente une autre requête en ne prenant pas en compte les transitions
        If (Form1.SQLQuery1.eof AND (inifile.ReadInteger('Parametres', 'Transitions', 0)= 1)) then
          begin
               Form1.SQLQuery1.close;
               Form1.ListBox1.Items.Add('Echec de la requête en tenant compte des transitions');
               sql:=sql1 + sql2 + sql3 + sql4 + sql5 + sql6 + sql8;
               Form1.SQLQuery1.SQL.Text:=sql;
               Form1.SQLQuery1.Open;
               brqst:=true;
          End;

//on tente une autre requête sur toutes les catégories
   If Form1.SQLQuery1.eof And ((nCat = 2) or (nCat = 3)) then
     begin
          Form1.SQLQuery1.close;
          Form1.ListBox1.Items.Add('Echec de la requête sur la catégorie ' + inttostr(nCat));
          Case nCat of
               2:sql:=sql1 + sql2 + ' AND Morceaux.NumCat = 1' + sql4 + sql6;
               3:begin
                      if bInter(2) then
                         sql3:= ' AND Morceaux.NumCat = 2'
                      else
                          sql3:= ' AND Morceaux.NumCat = 1';
                      sql:=sql1 + sql2 + sql3 + sql4 + sql6 + sql8;
                    end;

          end;
          Form1.SQLQuery1.SQL.Text:=sql;
          Form1.SQLQuery1.Open;
          brqst:=true;
     End;

   //on tente une autre requête sur toutes les tempos
   If Form1.SQLQuery1.eof And (tempo2 <> 1) then
     begin
          Form1.SQLQuery1.close;
          Form1.ListBox1.Items.Add('Echec de la requête sur le tempo ' + inttostr(tempo2));
          sql:=sql1 + sql3 + sql4 + sql6 + sql8;
          Form1.SQLQuery1.SQL.Text:=sql;
          Form1.SQLQuery1.Open;
          brqst:=true;
     End;

   //on tente une autre requête en ne prenant pas en compte l'écart
   If Form1.SQLQuery1.eof then
     begin
          Form1.SQLQuery1.close;
          Form1.ListBox1.Items.Add('Echec de la requête sur l''écart');
          sql:=sql1 + sql3 + sql8;
          Form1.SQLQuery1.SQL.Text:=sql;
          Form1.SQLQuery1.Open;
          brqst:=true;
     End;

   ///If not Form1.SQLQuery1.eof then
   If brqst = true then
      begin
        ///Form1.SQLQuery1.Last;
        ///nChoix:=Form1.SQLQuery1.RecordCount;
        ///n:= Random(nChoix);
        //Form1.Label1.Caption:=inttostr(nCat)+ ' ' +inttostr(n)+'/'+inttostr(nChoix);

        ///Form1.SQLQuery1.First;
        ///If nCat = 1 then Form1.SQLQuery1.MoveBy(n);
        ///If not Form1.SQLQuery1.eof then
           ///begin
                sFichier:= Form1.SQLQuery1.FieldByName('Chemin').AsString+'/'+Form1.SQLQuery1.FieldByName('Filename').AsString;
                ///If fileexists(sFichier) then
                   ///begin
                    nCat:= Form1.SQLQuery1.FieldByName('NumCat').AsInteger;
                    nInstru:= Form1.SQLQuery1.FieldByName('Instru').AsInteger;
                    If ((nCat = 2) and (nInstru <> 0)) then
                      begin
                          Form1.SQLQuery2.SQL.text:='SELECT Morceaux.Numfich, Morceaux.titre, Morceaux.Annee, Morceaux.Filename, Morceaux.Duree, Morceaux.PS, Morceaux.Intro, Morceaux.SurImpression, Morceaux.Numcat, Morceaux.Numgenre, Morceaux.tempo1, Morceaux.tempo2, Artistes.NumArtiste, Artistes.NomArtiste, Morceaux.Actif, Morceaux.Entame, Morceaux.Fade, Dossiers.Chemin, Dossiers.Instru, Artistes.Pays, (Dossiers.EJ*1440 + Dossiers.EH*60 + Dossiers.EM) AS ECART FROM Artistes, Morceaux, Dossiers WHERE (Artistes.NumArtiste = Morceaux.NumArtiste) AND (Morceaux.Numdossier=Dossiers.Numdossier) AND Morceaux.NumFich = ' + inttostr(nInstru) + ';';
                          Form1.SQLQuery2.Open;
                          If not Form1.SQLQuery2.EOF then
                             begin
                                sFichier2:= Form1.SQLQuery2.FieldByName('Chemin').AsString+'/'+Form1.SQLQuery2.FieldByName('Filename').AsString;
                                If fileexists(sFichier2) then
                                   begin
                                        nId:= Form1.SQLQuery2.FieldByName('NumFich').AsInteger;
                                        sArtist:= Form1.SQLQuery2.FieldByName('NomArtiste').AsString;
                                        nArtiste:= Form1.SQLQuery2.FieldByName('NumArtiste').AsInteger;
                                        sTitre:= Form1.SQLQuery2.FieldByName('Titre').AsString;
                                        sAnnee:= Form1.SQLQuery2.FieldByName('Annee').AsString;
                                        nGenre:= Form1.SQLQuery2.FieldByName('NumGenre').AsInteger;
                                        nPS:= Form1.SQLQuery2.FieldByName('PS').AsInteger;
                                        nDuree:= Form1.SQLQuery2.FieldByName('Duree').AsInteger;
                                        nIntro:= Form1.SQLQuery2.FieldByName('Intro').AsInteger;
                                        nEntame:= Form1.SQLQuery2.FieldByName('Entame').AsInteger;
                                        tempo1:= Form1.SQLQuery2.FieldByName('tempo1').AsInteger;
                                        tempo2:= Form1.SQLQuery2.FieldByName('tempo2').AsInteger;
                                        nSI:= Form1.SQLQuery2.FieldByName('SurImpression').AsInteger;
                                        sPays:= Form1.SQLQuery2.FieldByName('Pays').Asstring;
                                        nFade:= Form1.SQLQuery2.FieldByName('Fade').AsInteger;

                                        Form1.ListBox1.Items.Add('Ajout de l''instru '+ sTitre);

                                        MAJ_Prog(nLigne, nId, sArtist, sTitre, sFichier2, 4, nGenre, nDuree, nIntro, nPS, nSI, nEntame, tempo1, tempo2, sAnnee, sPays, nArtiste, nFade);
                                        nLigne:=nLigne + 1;
                                        Form1.GridProg.Rowcount:= Form1.GridProg.Rowcount + 1;
                                   end;
                                Form1.SQLQuery2.Close;
                             end;
                      end;
                    nId:= Form1.SQLQuery1.FieldByName('NumFich').AsInteger;
                    sArtist:= Form1.SQLQuery1.FieldByName('NomArtiste').AsString;
                    nArtiste:= Form1.SQLQuery1.FieldByName('NumArtiste').AsInteger;
                    sTitre:= Form1.SQLQuery1.FieldByName('Titre').AsString;
                    sAnnee:= Form1.SQLQuery1.FieldByName('Annee').AsString;
                    nGenre:= Form1.SQLQuery1.FieldByName('NumGenre').AsInteger;
                    nPS:= Form1.SQLQuery1.FieldByName('PS').AsInteger;
                    nDuree:= Form1.SQLQuery1.FieldByName('Duree').AsInteger;
                    nIntro:= Form1.SQLQuery1.FieldByName('Intro').AsInteger;
                    nEntame:= Form1.SQLQuery1.FieldByName('Entame').AsInteger;
                    tempo1:= Form1.SQLQuery1.FieldByName('tempo1').AsInteger;
                    tempo2:= Form1.SQLQuery1.FieldByName('tempo2').AsInteger;
                    nSI:= Form1.SQLQuery1.FieldByName('SurImpression').AsInteger;
                    sPays:= Form1.SQLQuery1.FieldByName('Pays').Asstring;
                    nFade:= Form1.SQLQuery1.FieldByName('Fade').AsInteger;

                    Form1.ListBox1.Items.Add('Choix de '+ sTitre);
                    result:=true;
                    MAJ_Prog(nLigne, nId, sArtist, sTitre, sFichier, nCat, nGenre, nDuree, nIntro, nPS, nSI, nEntame, tempo1, tempo2, sAnnee, sPays, nArtiste, nFade);
                   ///end
                ///else result:=false;



           ///end;
      end
   else result:=false;

   Form1.SQLQuery1.Close;
   inifile.Free;

end;

procedure TForm1.CmdDiscoClick(Sender: TObject);
begin

   FrmDisco.ShowModal;
end;

procedure TForm1.CmdGenererPlaylistClick(Sender: TObject);
var
   {nId: Integer;
   sFichier: String;
   sArtist: String;
   sTitre: String;}
  nCat : Integer;
  {nGenre : Integer;
  nPS : Integer;
  nIntro : Integer;}
  i : Integer;
  n : Integer;
  tempo1 : Integer;
  nIDprec, nGenrePrec : Integer;
  LePath: string;
  nPlayer: integer;
  nLigne: integer;
  {nDuree : Integer;
  nSI : Integer;
  sAnnee : String;}
begin
  If CmdGenererPlaylist.Tag = 1 then
     begin
       screen.cursor:=11;
       tempo1:=1;
       nIDPrec:=0;
       nGenrePrec:=0;
       nCat:=1;
       For i:=0 to 2 do
           begin
             //If Requete_Morceau(i, nId, sArtist, sTitre, sFichier, nCat, nGenre, nDuree, nIntro, nPS, nSI, tempo, nIDprec, sAnnee) then
             If Requete_Morceau(i, nCat, tempo1, nIDprec, nGenrePrec) then
                begin

                     Lepath:=Form1.GridProg.Cells[0, i];
                     nPlayer:=ChargePlayer(LePath);
                     Form1.GridProg.Cells[6,i]:=inttostr(nPlayer);
                     If (nPlayer<>-1) and (i=0) then
                       begin
                            PlaySon(i);
                            Maj_Pochette(i);
                            Maj_Diff(i);
                            Labeltot.Visible:= True;
                            LabelPos.Visible:= True;
                            Progressbar1.Position:= 0;
                            TimerFade.enabled:=true;
                            CmdGenererPlaylist.Enabled:=false;
                            CmdPause.Enabled:=true;
                       end;
                end;
           end;
       Gridprog.Row:=0;
       Timer1.Enabled:= True;

       screen.cursor:=0;

       end
     else
         begin
               CmdGenererPlaylist.Tag:= 1;
               TimerFade.enabled:=true;
               Timer1.enabled:=true;
               CmdGenererPlaylist.Enabled:=false;
               CmdPause.Enabled:=true;
               If Form1.GridProg.Cells[6, Form1.GridProg.row]<>'' then
                   begin
                        nPlayer:=strtoint(Form1.GridProg.Cells[6,Form1.GridProg.row]);
                        uos_Play(nPlayer);
                   end;

         end;


end;

procedure TForm1.CmdParamClick(Sender: TObject);
begin
   FrmParam.ShowModal;
end;

procedure TForm1.CmdPauseClick(Sender: TObject);
var
   nPlayer: integer;
   nLigne: integer;
begin
  if uos_getstatus(0) = 1 then uos_stop(0);
  CmdPause.Enabled:=false;
  CmdGenererPlaylist.Enabled:=true;
  CmdGenererPlaylist.Tag:= 2;
  TimerFade.enabled:=false;
  Timer1.enabled:=false;
  If Form1.GridProg.Cells[6, Form1.GridProg.row]<>'' then
       begin
            nPlayer:=strtoint(Form1.GridProg.Cells[6,Form1.GridProg.row]);
            uos_Pause(nPlayer);
       end;
end;

procedure TForm1.FormActivate(Sender: TObject);
var
  inifile: Tinifile;
  ordir: string;
  PortAudioFileName: string;
  SndFileFileName: string;
  Mpg123FileName: string;
  Mp4ffFileName: string;
  FaadFileName: string;
{$IFDEF Darwin}
  opath: string;
{$ENDIF}

begin
  ordir := application.Location;
  //uos_logo();
             {$IFDEF Windows}
     {$if defined(cpu64)}
  PortAudioFileName := ordir + 'lib\Windows\64bit\LibPortaudio-64.dll';
  SndFileFileName := ordir + 'lib\Windows\64bit\LibSndFile-64.dll';
  Mpg123FileName := ordir + 'lib\Windows\64bit\LibMpg123-64.dll';
  //Edit5.Text := ordir + 'lib\Windows\64bit\plugin\LibSoundTouch-64.dll';
{$else}
  PortAudioFileName := ordir + 'lib\Windows\32bit\LibPortaudio-32.dll';
  SndFileFileName := ordir + 'lib\Windows\32bit\LibSndFile-32.dll';
  Mpg123FileName := ordir + 'lib\Windows\32bit\LibMpg123-32.dll';
  Mp4ffFileName := ordir + 'lib\Windows\32bit\LibMp4ff-32.dll';
  FaadFileName := ordir + 'lib\Windows\32bit\LibFaad2-32.dll';
  //Edit5.Text := ordir + 'lib\Windows\32bit\plugin\LibSoundTouch-32.dll';
  //Edit6.Text := ordir + 'lib\Windows\32bit\plugin\Libbs2b-32.dll';
   {$endif}

 {$ENDIF}

 {$IFDEF freebsd}
    {$if defined(cpu64)}
    PortAudioFileName := ordir + 'lib/FreeBSD/64bit/libportaudio-64.so';
     SndFileFileName := ordir + 'lib/FreeBSD/64bit/libsndfile-64.so';
    Mpg123FileName := ordir + 'lib/FreeBSD/64bit/libmpg123-64.so';
    //Edit5.Text := '' ;
    //Edit6.text := ordir + 'lib/FreeBSD/64bit/plugin/libbs2b-64.so';

    {$else}
   PortAudioFileName := ordir + 'lib/FreeBSD/32bit/libportaudio-32.so';
     SndFileFileName := ordir + 'lib/FreeBSD/32bit/libsndfile-32.so';
    Mpg123FileName := ordir + 'lib/FreeBSD/32bit/libmpg123-32.so';
     //Edit5.Text := '' ;
{$endif}

 {$ENDIF}

  {$IFDEF Darwin}
  opath := ordir;
  opath := copy(opath, 1, Pos('/uos', opath) - 1);
  PortAudioFileName := opath + '/lib/Mac/32bit/LibPortaudio-32.dylib';
  SndFileFileName := opath + '/lib/Mac/32bit/LibSndFile-32.dylib';
  Mpg123FileName := opath + '/lib/Mac/32bit/LibMpg123-32.dylib';
  //Edit5.Text := opath + '/lib/Mac/32bit/plugin/LibSoundTouch-32.dylib';

            {$ENDIF}

   {$IFDEF linux}
    {$if defined(cpu64)}
  PortAudioFileName := ordir + 'lib/Linux/64bit/LibPortaudio-64.so';
  SndFileFileName := ordir + 'lib/Linux/64bit/LibSndFile-64.so';
  Mpg123FileName := ordir + 'lib/Linux/64bit/LibMpg123-64.so';
  Mp4ffFileName := ordir + 'lib/Linux/64bit/LibMp4ff-64.so';
  FaadFileName := ordir + 'lib/Linux/64bit/LibFaad2-64.so';
  //Edit5.Text := ordir + 'lib/Linux/64bit/plugin/LibSoundTouch-64.so';
  //Edit6.Text := ordir + 'lib/Linux/64bit/plugin/libbs2b-64.so';
{$else}
  PortAudioFileName := ordir + 'lib/Linux/32bit/LibPortaudio-32.so';
  SndFileFileName := ordir + 'lib/Linux/32bit/LibSndFile-32.so';
  Mpg123FileName := ordir + 'lib/Linux/32bit/LibMpg123-32.so';
  Mp4ffFileName := ordir + 'lib/Linux/32bit/LibMp4ff-32.so';
  FaadFileName := ordir + 'lib/Linux/32bit/LibFaad2-32.so';
  //Edit5.Text := ordir + 'lib/Linux/32bit/plugin/LibSoundTouch-32.so';
  //Edit6.Text := ordir + 'lib/Linux/32bit/plugin/libbs2b-32.so';
{$endif}

            {$ENDIF}

  //opendialog1.Initialdir := application.Location + 'sound';
 uos_LoadLib(PChar(PortAudioFileName), PChar(SndFileFileName), PChar(Mpg123FileName),  PChar(Mp4ffFileName), PChar(FaadFileName), nil);
  inifile:=Tinifile.Create('JBox.ini');
  If inifile.ReadInteger('Parametres', 'VerifAuto', 0) = 1 Then
     begin
          FrmSearch.Tag:=0;
          FrmSearch.ShowModal;
     end;

  If inifile.ReadInteger('Parametres', 'AutoPlay', 0) = 1 Then CmdGenererPlaylistClick(sender);

end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if uos_getstatus(0) = 1 then uos_stop(0);
  if uos_getstatus(1) = 1 then uos_stop(1);
  uos_UnloadPlugin('soundtouch');
  uos_UnloadPlugin('bs2b');
  uos_UnloadLib();
  uos_free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  inifile: Tinifile;
begin
  inifile:=Tinifile.Create('JBox.ini');

  SQLite3Connection1.DatabaseName:=inifile.ReadString('Base','chemin','/home/jeremie/MusicBase');
  SQLite3Connection1.Connected:=true;

  SQLTransaction1.DataBase:=SQLite3Connection1;

  Form1.SQLQuery1.DataBase := SQLite3Connection1;
  Form1.SQLQuery1.UsePrimaryKeyAsKey := False;
  Form1.SQLQuery2.DataBase := SQLite3Connection1;
  Form1.SQLQuery2.UsePrimaryKeyAsKey := False;


  Application.ProcessMessages;

end;

procedure TForm1.ODBCConnection1AfterConnect(Sender: TObject);
begin

end;

procedure TForm1.ProgressBar1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TForm1.ProgressBar1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  nPlayer: integer;
  nPos, nTot: double;
begin
  Form1.Progressbar1.Position:=Round(Form1.Progressbar1.Max * (X/Form1.Progressbar1.Width));
  nPlayer:=Numplayer(Form1.gridprog.row);
  If nPlayer<>-1 then
    begin
       nTot:=Form1.LabelTOT.tag/1000;
       nPos:=nTot * (X/Form1.Progressbar1.Width);
       uos_InputSeekSeconds(nPlayer, InputIndex1 ,nPos);
    end;

end;

procedure TForm1.ProgressBar1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  nPlayer: integer;
  nPos, nTot: double;
begin
  nPlayer:=Numplayer(Form1.gridprog.row);
  If nPlayer<>-1 then
    begin
       nTot:=Form1.LabelTOT.tag/1000;
       nPos:=nTot * (X/Form1.Progressbar1.Width);
       Form1.Progressbar1.Hint:= convHMS(trunc(nPos*1000));
    end;

end;


procedure TForm1.Timer1Timer(Sender: TObject);
var
  nPlayer, nPlayer2, p: integer;
  nLigne, NewLine: integer;
  nPos, ntot, nFade: integer;
  nSec: single;
  temptime: ttime;
  ho, mi, se, ms: word;
  nPS, nSI, nSeuil, nIntro, nIntroONAIR, nEntame, pcSI: integer;
  nivSI, VolLeft: double;
  bEnchaine, bFade, bSousImpress, bSousImpressPREC, bSuivantCharge, bFadePrec: boolean;
  TimingFin: integer;
  tempo2, nIDPrec, nGenrePrec, nCat: integer;
  inifile: Tinifile;
  LePath: string;
begin
  nLigne:=gridprog.row;
  nPlayer:=Numplayer(nLigne);
  nTot:=labeltot.tag;

  inifile:= TIniFile.Create('JBox.ini');
  pcSI:= inifile.ReadInteger('Parametres', 'VolumeSousImpress', 60);
  TimingFin:= inifile.ReadInteger('Parametres', 'TimingFin' + inttostr(NumCat(nLigne)), 5000);
  If nPlayer<>-1 then
    begin

        if uos_GetStatus(nPlayer)=1 then
           begin
                //************ ACTUALISATION DE l'AFFICHAGE 'ON AIR' *****************************
                nSec:= uos_InputPositionSeconds(nPlayer, InputIndex1);
                nPos:= trunc(nSec * 1000);
                LabelPos.Tag:=nPos;
                temptime := uos_InputPositionTime(nPlayer, InputIndex1);
                DecodeTime(temptime, ho, mi, se, ms);
                LabelPos.Caption := format('%.2d:%.2d:%.2d.%.3d', [ho, mi, se, ms]);
                Form1.Progressbar1.Position:= Round(Form1.Progressbar1.Max * (nPos / nTot));
                SetVUmetre(nPlayer);

                //************ VERIFICATION DE L'ENCHAINEMENT (point de sortie dépassé ? --> on enchaine) *****************
                nPS:= strtoint(GridProg.cells[8,nLigne]);
                nSI:= strtoint(GridProg.cells[14,nLigne]);
                nFade:= strtoint(GridProg.cells[21,nLigne]);
                nIntroONAIR:= strtoint(GridProg.cells[13,nLigne]);
                nSeuil:= nSI;

                If nSeuil < nPS Then nSeuil:= nPS;
                If nPS = 0 Then nPS:= TimingFin;
                If GridProg.cells[13, nLigne+1] <> '' Then nIntro:= strtoint(GridProg.cells[13, nLigne+1]);
                If GridProg.cells[20, nLigne+1] <> '' Then nEntame:= strtoint(GridProg.cells[20, nLigne+1]);

                bEnchaine:= False;
                bFade:= False;
                bSousImpress:= False;
                nivSI:= pcSI/100;
                Case NumCat(nLigne) of
                    -1:bEnchaine:= False;
                   1:Case NumCat(nLigne + 1) of  // MUSIQUE suivie de ...
                        -1:benchaine:=False;
                        1:If ntot - nPos <= (nPS + nEntame) Then       // MUSIQUE
                              begin
                                bEnchaine:= True;
                                If nFade = 1 then bFade:= true else bFade:=False;
                              end;

                        else If ntot - nPos <= (nPS + nEntame) Then //nIntro) Then   // AUTRE
                                 begin
                                   bEnchaine:= True;
                                   If nFade = 1 then bFade:= true else bFade:=False;
                                 end;

                     end;

                     4:Case NumCat(nLigne + 1) of  // INSTRU suivi de ...
                          -1:benchaine:=False;
                        2:If nPos >= nIntroONAIR Then       // CAPSULE
                              begin
                                bEnchaine:= True;
                                if nFade = 1 then bSousImpressPREC:= True;
                              end;

                        else If ntot - nPos <= (nPS + nEntame) Then //nIntro) Then   // AUTRE
                                 begin
                                   bEnchaine:= True;
                                   bFade:= True;
                                 end;
                     end;

                     else case NumCat(nLigne + 1) of  // AUTRE, suivi de ...
                          -1:benchaine:=False;
                          1:If (((nTot - nPos <= (nPS + nIntro)) And (ntot - nPos <= nSeuil)) Or (nTot - nPos <= (nPS + nEntame))) Then    // MUSIQUE, soit on tient compte du seuil pour l'intro, soit juste de l'entame
                               begin
                                 bEnchaine:= True;
                                 bFade:= False;
                                 If (nIntro > 1000) And (nSeuil > nPS) Then
                                    begin
                                         bSousImpress:= True;
                                         If nLigne > 0 then
                                            begin
                                                 If (Numcat(nLigne - 1) = 4) and (uos_GetStatus(numplayer(nLigne - 1))=1) then bFadePrec:=true // si le précédent est un INSTRU toujours en sous impression, on le fade
                                            end;
                                    end
                               end;
                          else If nTot - nPos <= (nPS + nEntame) Then  // Autre
                               begin
                                 bEnchaine:= True;
                                 bFade:= False;
                               end;
                          end;
                   end;


                   If bEnchaine Then
                        begin
                          //si aucun fade n'est en cours
                          If Etatfade(nLigne) = 0 Then
                               begin
                               //lance fade ON AIR
                                 If bFade Then GridProg.cells[7, nLigne]:= '1';
                                 If (bFadePrec and (nLigne > 0)) Then
                                    begin
                                         GridProg.Cells[7, nLigne - 1]:= '1'; // lance fade précédent (instru toujours en cours)
                                    end;
                                 //si on n'est pas sur la dernière ligne,
                                 If nLigne < GridProg.RowCount - 1 Then
                                      begin
                                        //on lance la suite
                                        nPlayer2:= NumPlayer(nLigne + 1);
                                        If nPlayer2 = -1 Then
                                             begin
                                               Lepath:=Form1.GridProg.Cells[0,nLigne+1];
                                               nPlayer2:=ChargePlayer(LePath);
                                               Form1.GridProg.Cells[6,nLigne+1]:=inttostr(nPlayer2);
                                             end;

                                        If bSousImpress And (nPlayer2 <> -1) Then
                                             begin
                                               SetVolume(nLigne + 1, nPlayer2, nivSI); //uos_SetDSPVolumeIn(nPlayer2, InputIndex1, nivSI, nivSI, true);
                                               //LabelV(nPlayer2).Width = 38.55 * pcSI
                                               GridProg.cells[7, nLigne + 1]:= '2';
                                             end;

                                        If bSousImpressPREC Then
                                           begin
                                                GridProg.cells[7, nLigne - 1]:= '4'; // cas d'un instru à mettre en sous-impression
                                           end;

                                        Playson(nLigne+1);
                                        GridProg.Row:= nLigne + 1;
                                        MAJ_Pochette(GridProg.Row);
                                        MAJ_Diff(GridProg.Row);
                                        GridProg.TopRow:= GridProg.Row;


                                        //on fade le ON AIR
                                        If bFade Then
                                           begin
                                                VolLeft:= Nivolume(Gridprog.row); //uos_InputGetLevelLeft(nPlayer, InputIndex1);
                                                SetVolume(GridProg.row, nPlayer, VolLeft - 0.0125); //uos_SetDSPVolumeIn(nPlayer, InputIndex1, VolLeft - 0.0125, VolLeft - 0.0125, true);
                                           end;

                                      end
                                 else
                                    //charger la suite
                                 end;
                               end;


        End;





    end;




  //************ PLAYER ARRÊTé --> on vide le player / on enchaine si c'est le player ON AIR *******************
  For p:= 1 To 5 do
      begin
           If uos_GetStatus(p)<>1 Then
              begin
              //si c'est le Player ON AIR
                If NumLigne(p) = Gridprog.row then
                  begin
                       //si on n'est pas sur la dernière ligne,
                        nLigne:= Gridprog.row;
                        If nLigne < GridProg.Rowcount - 1 Then
                          begin
                            //on lance la suite
                            nPlayer2:= NumPlayer(GridProg.Row + 1);
                            If nPlayer2 = -1 Then
                              begin
                                   Lepath:=Form1.GridProg.Cells[0,nLigne + 1];
                                   nPlayer2:=ChargePlayer(LePath);
                                   Form1.GridProg.Cells[6,nLigne + 1]:=inttostr(nPlayer2);
                                   if nPlayer2 = - 1 then break;
                              end;
                            Playson(nLigne+1);
                            GridProg.Row:= nLigne + 1;
                            MAJ_Pochette(GridProg.Row);
                            MAJ_Diff(GridProg.Row);
                            GridProg.TopRow:= GridProg.Row;
                            //on vide l'ancien ON AIR
                            uos_stop(p);
                            GridProg.cells[6, nLigne]:= '';
                          end;
                   End
                 else If numligne(p)<>-1 then

                     begin
                           nLigne:= NumLigne(p);
                           Case uos_GetStatus(p) of
                             0:begin
                               //0 : stoppé ----> on ne fait rien (voir lignes plus bas)
                               If nLigne = GridProg.Row + 1 Then
                                  bSuivantCharge:= False;
                               If nLigne < GridProg.Row Then
                                 begin
                                      //SI lignes antérieures, on libère le player
                                      uos_Stop(p);
                                      GridProg.cells[6, nLigne]:= '';
                                 end;
                                 end;
                             else
                                  begin //donc -1 ou 2 'chargé
                                    If nLigne = GridProg.Row + 1 Then bSuivantCharge:= True;
                                    If nLigne < GridProg.Row Then
                                      begin
                                        uos_Stop(p);
                                        GridProg.cells[6, nLigne]:= '';
                                      end;
                                  end;
                             end;
                      end;
                 end;
              end;

       //}

  //si on air+1 pas chargé, et qu'un player est libre
  If bSuivantCharge = False Then
     begin
          Lepath:=Form1.GridProg.Cells[0,GridProg.Row + 1];
          nPlayer2:=ChargePlayer(LePath);
          Form1.GridProg.Cells[6,Gridprog.row + 1]:=inttostr(nPlayer2);
          If nPlayer2<>-1 then bSuivantCharge:=true;
     end;


  //************ CHARGEMENT DE LA SUITE ***********************
  //si le ONAIR est sur l'avant-dernière ou la dernière ligne, on ajoute une ligne et on y charge un nouveau morceau
  // On ne charge pas trop à l'avance sinon, il faut prendre en compte les lignes non jouées dans l'historique. (Valider dès requête ?)
  If (GridProg.Row > GridProg.Rowcount - 3) Then //Or (GridProg.Row = GridProg.Rowcount - 1) Then //'And (NumPlayer(0) = 0 Or Not StreamIsActive(NumPlayer(0))) Then
    begin
         //GridProg.Redraw = False

         GridProg.Rowcount:= GridProg.Rowcount + 1;
         NewLine:= GridProg.rowcount - 1;

         //choix d'un nouveau morceau pour la nouvelle ligne NewLine
         tempo2:= strtoint(GridProg.cells[17, NewLine - 1]);
         nIDprec:= strtoint(GridProg.cells[5, NewLine - 1]);
         nGenrePrec:= strtoint(GridProg.cells[4, NewLine - 1]);
         //diffusion d'un interlude ?
         If bInter(3) Then
            nCat:= 3
         Else
             if bInter(2) then
               nCat:= 2
             else
                 nCat:= 1;

         //If Requete_Morceau(NewLine, nId, sArtist, sTitre, sFichier, nCat, nGenre, nDuree, nIntro, nPS, nSI, tempo, nIDprec, sAnnee) then
         If Requete_Morceau(NewLine, nCat, tempo2, nIDprec, nGenrePrec) then
            begin
                 Lepath:=Form1.GridProg.Cells[0,NewLine];
                 nPlayer2:= ChargePlayer(LePath);
                 if nPlayer2<>-1 Then
                    begin
                      Lepath:=Form1.GridProg.Cells[0, NewLine];
                      nPlayer2:=ChargePlayer(LePath);
                      Form1.GridProg.Cells[6, NewLine]:=inttostr(nPlayer2);
                    end;
            end;


             //GridProg.Redraw = True
    end;

end;

procedure TForm1.TimerFadeTimer(Sender: TObject);
var
  p, p2:integer;
  nLigne: integer;
  nDuree, nPos, nPS, nOffset, pcSI: integer;
  temptime: ttime;
  ho, mi, se, ms: word;
  VolLeft, VolRight, nivSI: double;
  inifile: Tinifile;
begin

//'états : 0 : au max / 1 : à baisser / 2 : au mini, en attente / 3 : à monter / 4 à baisser au niveau de sous-impression

inifile:= TIniFile.Create('JBox.ini');
pcSI:= inifile.ReadInteger('Parametres', 'VolumeSousImpress', 60);

For p:= 1 To 5 do
    begin
         //si le player est en lecture

      If uos_GetStatus(p) = 1 Then
        begin
          nLigne:= NumLigne(p);
          VolLeft:= Nivolume(nLigne); //VolLeft:=uos_InputGetLevelLeft(p, InputIndex1);
          //Form1.GridProg.Cells[3,nLigne]:=inttostr (EtatFade(nLigne)) + ' - ' + Floattostr(VolLeft);
          //si un fade est en cours
          Case Etatfade(nLigne) of
               1: begin
                  //si le volume est toujours haut, on continue à le baisser
                  If VolLeft > 0.0125 Then SetVolume(nLigne, p, VolLeft - 0.0125) //uos_SetDSPVolumeIn(p, InputIndex1, VolLeft - 0.0125, VolLeft - 0.0125, true)
                  Else
                  //sinon, on arrête le son et on vide le player
                    begin
                         uos_stop(p);
                         Form1.GridProg.cells[6, nLigne]:= '';
                    end;
                  end;
               2: begin
                  //fade in en attente
                  p2:= NumPlayer(nLigne - 1);
                  //LabelPays.Caption = "stream" & p2 & ":" & StreamIsActive(p2) & " ligne:" & NumLigne(p2)
                  If (uos_GetStatus(p2)=1) And (nLigne - 1 >= 0) Then
                     begin
                          //nDuree:= strtoint(Form1.GridProg.cells[12,NumLigne(p2)]);
                          temptime := uos_InputLengthTime(p2, inputIndex1 );
                          DecodeTime(temptime, ho, mi, se, ms);
                          nDuree:= integer(mi + 1000*se + 60000*mi + 3600000*ho);
                          //If nDuree = 0 Then nDuree:= m_objMediaPosition(p2).Duration * 1000;
                          nPS:= strtoint(Form1.GridProg.cells[8, NumLigne(p2)]);
                          nPos:= trunc(uos_InputPositionSeconds(p2, InputIndex1)*1000);
                          nOffset:= trunc((1 - VolLeft)*8000); //8000 = (50ms / 0.00625)
                          //Form1.Label1.Caption:= 'reste:' + floattostr((nDuree - nPos) / 1000) + ' avant:' + floattostr((nPS + nOffset) / 1000);
                          If nDuree - nPos <= (nPS + nOffset) Then
                          begin
                               Form1.GridProg.cells[7, nLigne]:= '3';
                               SetVolume(nLigne, p, VolLeft + 0.00625); //uos_SetDSPVolumeIn(p, InputIndex1, VolLeft + 0.00625, VolLeft + 0.00625, true); //'50
                          end;
                     End
                  Else
                      begin
                           Form1.GridProg.cells[7,nLigne]:='3';
                           SetVolume(nLigne, p, VolLeft + 0.00625); //uos_SetDSPVolumeIn(p, InputIndex1, VolLeft + 0.00625, VolLeft + 0.00625, true); //'50
                      end;
                  End;
               3: begin
                  //si le volume est toujours bas, on continue à le monter
                  If VolLeft <= 0.99375 Then //'50 Then
                     SetVolume(nLigne, p, VolLeft + 0.00625) //uos_SetDSPVolumeIn(p, InputIndex1, VolLeft + 0.00625, VolLeft + 0.00625, true) //'50
                     Else
                         begin
                         //sinon, on le met au max et on change le statut
                         SetVolume(nLigne, p, 1); //uos_SetDSPVolumeIn(p, InputIndex1, 1, 1, true);
                         Form1.GridProg.cells[7, nLigne]:= '0';
                         End;
                     End;

          4: begin
             //si le volume est toujours plus haut que le niveau de SOUSIMPRESSION, on continue à le baisser
             nivSI:=pcSI/100;
             If VolLeft > nivSI Then SetVolume(nLigne, p, VolLeft - 0.0125); //uos_SetDSPVolumeIn(p, InputIndex1, VolLeft - 0.0125, VolLeft - 0.0125, true)
             End;
          end;

    //témoin
    //nivSI:= VolLeft;
    //pcSI:= 100 - ((-1 * nivSI) / 40);
    //LabelV(p).Width = 38.55 * pcSI
    end;
end;


//n = GridProg.Row

//p = NumPlayer(n)

//If p = -1 Then Exit Sub
//If Not StreamIsActive(p) Or ObjPtr(m_objBasicAudio(p)) <= 0 Then Exit Sub
end;


{
function DSPReverseBefore(Data: TuosF_Data; fft: TuosF_FFT): TDArFloat;
begin
  if Data.position > Data.OutFrames div Data.ratio then
    uos_Seek(nPlayer, InputIndex1, Data.position - (Data.OutFrames div (Data.Ratio)));
end;

function DSPReverseAfter(Data: TuosF_Data; fft: TuosF_FFT): TDArFloat;
var
  x: integer;
  arfl: TDArFloat;
begin
  SetLength(arfl, length(Data.Buffer));

  for x := 0 to ((Data.OutFrames * Data.Ratio) - 1) do
    if odd(x) then
      arfl[x] := Data.Buffer[((Data.OutFrames * Data.Ratio) - 1) - x - 1]
    else
      arfl[x] := Data.Buffer[((Data.OutFrames * Data.Ratio) - 1) - x + 1];
  Result := arfl;
end;


function DSPStereo2Mono(Data: TuosF_Data; fft: TuosF_FFT): TDArFloat;
var
  x: integer = 0;
  ps: PDArShort;     //////// if input is Int16 format
  pl: PDArLong;      //////// if input is Int32 format
  pf: PDArFloat;     //////// if input is Float32 format

  samplef : single; //cFloat;
  samplei : integer;
begin
 if (Data.channels = 2) then
begin

 case Data.SampleFormat of
  2:
  begin
    ps := @Data.Buffer;
   while x < Data.OutFrames  do
        begin
      samplei := round((ps^[x] + ps^[x+1])/2);
      ps^[x] := samplei ;
      ps^[x+1] := samplei ;
      x := x + 2;
      end;
   end;

  1:
  begin
    pl := @Data.Buffer;
   while x < Data.OutFrames  do
        begin
      samplei := round((pl^[x] + pl^[x+1])/2);
      pl^[x] := samplei ;
      pl^[x+1] := samplei ;
      x := x + 2;
      end;
   end;

  0:
  begin
    pf := @Data.Buffer;
   while x < Data.OutFrames  do
        begin
      samplef := (pf^[x] + pf^[x+1])/2;
      pf^[x] := samplef ;
      pf^[x+1] := samplef ;
      x := x + 2;
      end;
   end;


end;
Result := Data.Buffer;
end
else Result := Data.Buffer;
end;}

end.

