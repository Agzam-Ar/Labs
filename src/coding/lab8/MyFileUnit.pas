unit MyFileUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

const
  bufferSize = 256 * 1024;

type
  MyReader = class
    buffer : array[0..bufferSize - 1] of longint;
    fi : file of longint;
    procedure open(path: string);
    private

    public

  end;

implementation

procedure MyReader.open(path: string);
begin
     //MyReader.fi

end;



end.

