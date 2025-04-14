unit MyFileUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

const
  bufferSize = 256 * 1024;

type
  MyReader = class
    private

    public
          buffer : array[0..bufferSize - 1] of longint;
          fi : file of longint;
          procedure open(path: string);

  end;

implementation

procedure MyReader.open(path: string);
begin
     //MyReader.fi

end;



end.

