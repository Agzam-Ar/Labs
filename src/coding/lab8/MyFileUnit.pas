unit MyFileUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

const
  bufferSize = 1024 * 1024;

type
  MyReader = class
    private
    public
          fi : file of longint;
          buffer : array[0..bufferSize - 1] of longint;
          incoming : longint;
          index : longint;
          available : longint;
          procedure open(path: string);
          procedure close();
          function next():longint;
  end;
  MyWriter = class
    private
    public
          fi : file of longint;
          buffer : array[0..bufferSize - 1] of longint;
          incoming : longint;
          index : longint;
          available : longint;
          procedure open(path: string);
          procedure close();
          procedure write(value:longint);
  end;

implementation


procedure MyReader.open(path: string);
begin
     AssignFile(fi, path);
     Reset(fi);
     index := 0;
     available := 0;
     incoming := FileSize(fi);
end;
function MyReader.next():longint;
begin
     if index >= available then begin
        available := bufferSize;
        if available > incoming then available := incoming;
        BlockRead(fi, buffer, available);
        incoming := incoming - available;
        index := 0;
     end;
      
     next := buffer[index];
     //index := index + 1;
end;
procedure MyReader.close();
begin
     CloseFile(fi);
end;

procedure MyWriter.open(path: string);
begin
     AssignFile(fi, path);
     Rewrite(fi);
     index := 0;
end;


procedure MyWriter.write(value: longint);
begin
     if index >= bufferSize then begin
        BlockWrite(fi, buffer, bufferSize);
        index := 0;
     end;
     buffer[index] := value;
     index := index + 1;
end;
 
procedure MyWriter.close();
begin
     BlockWrite(fi, buffer, index);
     CloseFile(fi);
end;
end.



