unit Fractal;

interface

uses GraphABC;

var transforms: array [0..5] of real;

procedure line(x, y : real);
function tx(x, y, a, b, c, d:real):real;
function ty(x, y, a, b, c, d:real):real;
procedure drawSeg(x, y, a,b,c,d, deepth:real);
procedure drawFractal(deepth:integer);
  
implementation

var first := true;
  
procedure line; begin
  if first then begin
    MoveTo(round(x), round(y));
    first := false
  end else LineTo(round(x), round(y));
end;

function tx:real; begin
  tx := a*x + b*y;
end;

function ty:real; begin
  ty:= c*x + d*y;
end;

procedure drawSeg; begin
    if deepth = 0 then begin
        line(x + tx(-1,  1, a,b,c,d), y + ty(-1,  1, a,b,c,d));
        line(x + tx(-1, -1, a,b,c,d), y + ty(-1, -1, a,b,c,d));
        line(x + tx( 1, -1, a,b,c,d), y + ty( 1, -1, a,b,c,d));
        line(x + tx( 1,  1, a,b,c,d), y + ty( 1,  1, a,b,c,d));
    end else begin
        deepth := deepth - 1;
        a /= 2;
        b /= 2;
        c /= 2;
        d /= 2;
        drawSeg(x + tx(-2,  2, a,b,c,d), y + ty(-2,  2, a,b,c,d), -b,-a,-d,-c, deepth);
        drawSeg(x + tx(-2, -2, a,b,c,d), y + ty(-2, -2, a,b,c,d),  a, b, c, d, deepth);
        drawSeg(x + tx( 2, -2, a,b,c,d), y + ty( 2, -2, a,b,c,d),  a, b, c, d, deepth);
        drawSeg(x + tx( 2,  2, a,b,c,d), y + ty( 2,  2, a,b,c,d),  b, a, d, c, deepth);
    end;
end;

procedure drawFractal(deepth:integer); begin 
    first := true;
    drawSeg(transforms[0], transforms[1], transforms[2], transforms[3], transforms[4], transforms[5], deepth);
end;

initialization
end.