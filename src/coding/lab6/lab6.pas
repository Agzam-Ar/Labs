uses GraphABC, Fractal;

// Фамилия: Арасланов
// Вариант: 98
//
// Лабораторная работа №7
// Исследование фракталов
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
  camAngle := 0.0;
  deepth := 1;
  lockDraw := true;
  
procedure draw(); begin 
    LockDrawing;
    lockDraw := true;
    transforms[0] :=  camX;
    transforms[1] :=  camY;
    transforms[2] :=  cos(camAngle)*camZoom;
    transforms[3] := -sin(camAngle)*camZoom;
    transforms[4] :=  sin(camAngle)*camZoom;
    transforms[5] :=  cos(camAngle)*camZoom;
    ClearWindow();
    drawFractal(deepth);
    lockDraw := false;
    UnLockDrawing;
end;

procedure keyListener(k : integer); begin
  if not lockDraw then begin
    if k = VK_W then camY := camY + 100;
    if k = VK_S then camY := camY - 100;
    if k = VK_A then camX := camX + 100;
    if k = VK_D then camX := camX - 100;
    if k = VK_T then camAngle := camAngle + Pi/20;
    if k = VK_R then camAngle := camAngle - Pi/20;
    if k = VK_E then camZoom := camZoom*1.2;
    if k = VK_Q then camZoom := camZoom/1.2;
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
