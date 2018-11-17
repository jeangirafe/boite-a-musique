unit UnitSON;

{$mode objfpc}{$H+}

interface

uses
  uos_flat, Classes, SysUtils, Graphics, Dialogs;


Function ConvHMS(Millisec: integer): String;
Function ConvHMSMilli(Millisec: integer): String;
FUNCTION SpecialStr(stA : STRING) : STRING;
Function stringGenre(i : Integer): String;

////// This is the "standart" DSP procedure look.
//function DSPReverseBefore(Data: TuosF_Data; fft: TuosF_FFT): TDArFloat;
//function DSPReverseAfter(Data: TuosF_Data; fft: TuosF_FFT): TDArFloat;

function DSPStereo2Mono(Data: TuosF_Data; fft: TuosF_FFT): TDArFloat;


var
  BufferBMP: TBitmap;
  OutputIndex1, InputIndex1, DSPIndex1, DSPIndex2, PluginIndex1, PluginIndex2: integer;
  plugsoundtouch : boolean = false;
  plugbs2b : boolean = false;

implementation


FUNCTION SpecialStr(stA : STRING) : STRING;
  BEGIN
  //stA:=stringreplace(stA,'#','##', [rfReplaceall]);
  //stA:=stringreplace(stA,'&','&&', [rfReplaceall]);
    Result:=stringreplace(stA,'''','''''', [rfReplaceall]);

  END;

Function stringGenre(i : Integer): String;
begin
  Case i of
   0:result:='Blues';
   1:result:='Classic Rock';
   2:result:= 'Country';
   3:result:= 'Dance';
   4:result:= 'Disco';
   5:result:= 'Funk';
   6:result:= 'Grunge';
   7:result:= 'Hip-hop';
   8:result:= 'Jazz';
   9:result:= 'Mental';
   10:result:= 'New Age';
   11:result:= 'Oldies';
   12:result:= 'Other';
   13:result:= 'Pop';
   14:result:= 'R&B';
   15:result:= 'Rap';
   16:result:= 'Reggae';
   17:result:= 'Rock';
   18:result:= 'Rock';
   19:result:= 'Industrial';
   20:result:= 'Alternative';
   21:result:= 'Ska';
   22:result:= 'Death Metal';
   23:result:= 'Pranks';
   24:result:= 'Soundtrack';
   25:result:= 'Euro-Techno';
   26:result:= 'Ambient';
   27:result:= 'Trip-hop';
   28:result:= 'Vocal';
   29:result:= 'Jazz+Funk';
   30:result:='Fusion';
   31:result:='Trance';
   32:result:='Classical';
   33:result:='Instrumental';
   34:result:='Acid';
   35:result:='House';
   36:result:='Game';
   37:result:='Sound Clip';
   38:result:='Gospel';
   39:result:='Noise';
   40:result:='Alternative Rock';
   41:result:='Bass';
   42:result:='Soul';
   43:result:='Punk';
   44:result:='Space';
   45:result:='Meditative';
   46:result:='Instrumental Pop';
   47:result:='Instrumental Rock';
   48:result:='Ethnic';
   49:result:='Gothic';
   50:result:='Darkwave';
   51:result:='Techno-Industrial';
   52:result:='Electronic';
   53:result:='Pop-Folk';
   54:result:='Eurodance';
   55:result:='Dream';
   56:result:='Southern Rock';
   57:result:='Comedy';
   58:result:='Cult';
   59:result:='Gangsta';
   60:result:='Top 40';
   61:result:='Christian Rap';
   62:result:='Pop/Funk';
   63:result:='Jungle';
   64:result:='Native US';
   65:result:='Cabaret';
   66:result:='New Wave';
   67:result:='Psychadelic';
   68:result:='Rave';
   69:result:='Showtunes';
   70:result:='Trailer';
   71:result:='Lo-Fi';
   72:result:='Tribal';
   73:result:='Acid Punk';
   74:result:='Acid Jazz';
   75:result:='Polka';
   76:result:='Retro';
   77:result:='Musical';
   78:result:='Rock & Roll';
   79:result:='Hard Rock';
   80:result:='Folk';
   81:result:='Folk-Rock';
   82:result:='National Folk';
   83:result:='Swing';
   84:result:='Fast Fusion';
   85:result:='Bebob';
   86:result:='Latin';
   87:result:='Revival';
   88:result:='Celtic';
   89:result:='Bluegrass';
   90:result:='Avantgarde';
   91:result:='Gothic Rock';
   92:result:='Progressive Rock';
   93:result:='Psychedelic Rock';
   94:result:='Symphonic Rock';
   95:result:='Slow Rock';
   96:result:='Big Band';
   97:result:='Chorus';
   98:result:='Easy Listening';
   99:result:='Acoustic';
   100:result:='Humour';
   101:result:='Speech';
   102:result:='Chanson';
   103:result:='Opera';
   104:result:='Chamber Music';
   105:result:='Sonata';
   106:result:='Symphony';
   107:result:='Booty Bass';
   108:result:='Primus';
   109:result:='Porn Groove';
   110:result:='Satire';
   111:result:='Slow Jam';
   112:result:='Club';
   113:result:='Tango';
   114:result:='Samba';
   115:result:='Folklore';
   116:result:='Ballad';
   117:result:='Power Ballad';
   118:result:='Rhytmic Soul';
   119:result:='Freestyle';
   120:result:='Duet';
   121:result:='Punk Rock';
   122:result:='Drum Solo';
   123:result:='Acapella';
   124:result:='Euro-House';
   125:result:='Dance Hall';
   126:result:='Goa';
   127:result:='Drum & Bass';
   128:result:='Club-House';
   129:result:='Hardcore';
   130:result:='Terror';
   131:result:='Indie';
   132:result:='BritPop';
   133:result:='Negerpunk';
   134:result:='Polsk Punk';
   135:result:='Beat';
   136:result:='Christian Gangsta';
   137:result:='Heavy Metal';
   138:result:='Black Metal';
   139:result:='Crossover';
   140:result:='Contemporary C';
   141:result:='Christian Rock';
   142:result:='Merengue';
   143:result:='Salsa';
   144:result:='Thrash Metal';
   145:result:='Anime';
   146:result:='JPop';
   147:result:='SynthPop';
   148:result:='Bossa Nova';
   149:result:='Electronica';
   150:result:='ElectroPop';
   Else result:='Other';
end;
End;

Function ConvHMSMilli(Millisec: integer): String;
//converti des millisecondes en heure, minutes, secondes, millisecondes restante
var
  TH: integer;
  TM: integer;
  TS: integer;
  TMS: integer;
  Dp: string;
begin
  result:= '';
  Dp:= ':';
  TS:= trunc(Millisec/1000);
  TMS:=Millisec - (TS * 1000);
  TM:= trunc(TS / 60);
  TS:= TS - (TM * 60);
  TH:= trunc(TM / 60);
  TM:= TM - (TH * 60);
  If TH <> 0 Then result:= inttostr(TH) + Dp;
  result:= result + Format('%.2d', [TH]) + Dp + Format('%.2d', [TM]) + Dp + Format('%.2d', [TS])+ Dp + Format('%.3d', [TMS]);
End;

Function ConvHMS(Millisec: integer): String;
//converti des millisecondes en heure, minutes, secondes, millisecondes restante
var
  TH: integer;
  TM: integer;
  TS: integer;
  Dp: string;
begin
  result:= '';
  Dp:= ':';
  TS:= trunc(Millisec/1000);
  TM:= trunc(TS / 60);
  TS:= TS - (TM * 60);
  TH:= trunc(TM / 60);
  TM:= TM - (TH * 60);
  If TH <> 0 Then result:= inttostr(TH) + Dp;
  result:= result + Format('%.2d', [TM]) + Dp + Format('%.2d', [TS]);
End;

Function ConvS(Millisec: integer): String;
//converti des millisecondes en heure, minutes, secondes, millisecondes restante
var
  TH: integer;
  TM: integer;
  TS: integer;
  Dp: string;
begin
  result:= '';
  Dp:= ':';
  TS:= trunc(Millisec/1000);
  TM:= trunc(TS / 60);
  TS:= TS - (TM * 60);
  TH:= trunc(TM / 60);
  TM:= TM - (TH * 60);
  If TH <> 0 Then result:= inttostr(TH) + Dp;
  result:= result + Format('%.2d', [TM]) + Dp + Format('%.2d', [TS]);
End;



{procedure LoopProcPlayer1;
begin
 ShowPosition;
 //ShowLevel ;
end;   }


//{
function DSPReverseBefore(Data: TuosF_Data; fft: TuosF_FFT): TDArFloat;
begin
  if Data.position > Data.OutFrames div Data.ratio then
    uos_InputSeek(0, InputIndex1, Data.position - (Data.OutFrames div (Data.Ratio)));
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
//}

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
end;

end.

