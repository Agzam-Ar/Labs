uses GraphABC;

// Фамилия: Арасланов
// Вариант: 98
//
// Лабораторная работа №7
// Исследование фракталов
//
//
// Цель работы: получение навыков реализации алгоритмов с рекурсивными вычислениями, знакомство с фракталами.
//
// Задание:
// 1. Написать программу для визуализации фрактала "Кривая Пеано".
// 2. Предусмотреть возможности масштабирования, изменения глубины прорисовки и перемещения полученной фигуры.
// 3. Построение множества ломанных, образующих фрактал, должно осуществляться в отдельном модуле.

var
  camX := 500;
  camY := 500;
  camZoom := 100.0;
  deepth := 1;
  first := true;
  lockDraw := true;
  dx := 0;
  dy := -4;
  angle := 0.0;
  
procedure line(x, y : real); begin
  if first then begin
    MoveTo(round(x), round(y));
    first := false
  end else 
    LineTo(round(x), round(y));
end;

function tx(x, y, a, b, c, d:real):real; begin
  tx := a*x + b*y;
end;

function ty(x, y, a, b, c, d:real):real; begin
  ty:= c*x + d*y;
end;

procedure drawSeg(x, y, a,b,c,d, deepth : real); begin
    if deepth = 0 then begin
        line(x + tx(-1,  1, a,b,c,d), y + ty(-1,  1, a,b,c,d));
        line(x + tx(-1, -1, a,b,c,d), y + ty(-1, -1, a,b,c,d));
        line(x + tx( 1, -1, a,b,c,d), y + ty( 1, -1, a,b,c,d));
        line(x + tx( 1,  1, a,b,c,d), y + ty( 1,  1, a,b,c,d));
    end else begin
        dx := dx div 2;
        dy := dy div 2;
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

procedure draw(); begin 
    first := true;
    LockDrawing;
    lockDraw := true;
    ClearWindow();
    drawSeg(camX, camY, cos(angle)*camZoom, -sin(angle)*camZoom, sin(angle)*camZoom, cos(angle)*camZoom, deepth);
    lockDraw := false;
    UnLockDrawing;
end;

procedure keyListener(k : integer); begin
  if not lockDraw then begin
    if k = ord('W') then camY := camY + 100;
    if k = ord('S') then camY := camY - 100;
    if k = ord('A') then camX := camX + 100;
    if k = ord('D') then camX := camX - 100;
    if k = ord('T') then angle := angle + Pi/20;
    if k = ord('R') then angle := angle - Pi/20;
    if k = ord('E') then camZoom := camZoom*1.2;
    if k = ord('Q') then camZoom := camZoom/1.2;
    if (ord('1') <= k) and (k <= ord('9')) then deepth := k-ord('0')-1;
    draw();
  end;
end;

begin
    Window.SetSize(camX,camY);
    camX := camX div 2;
    camY := camY div 2;
    Window.Title := 'Кривая Пеано';
    OnKeyDown := keyListener;
    draw();
end.
