// Фамилия: Арасланов
// Вариант: 2
//
// Лабораторная работа №5
// Исследование алгоритмов сортировки
//
// Цель работы: получить базовые сведения о наиболее известных алгоритмах сортировки, изучить принципы работы с текстовыми файлами.
//
// Задание:
// 1. Реализовать сортировку данных с помощью вставок.
// 2. Реализовать сортировку данных с помощью алгоритма слияния.
// 3. В обоих случаях необходимо предусмотреть возможность изменения компаратора (реализация компаратора в виде передаваемой в подпрограмму функции).
// 4. Считывание и вывод данных необходимо производить из текстового файла.
// 5. Для демонстрации работы программных реализаций самостоятельно подготовить варианты входных данных (при этом объем тестовых файлов должен позволять оценить скорость работы программ).

var
  arr: array of integer;
  n, element: integer;
  input, output: text;
  
procedure insertionSort(a: array of integer; n : integer; compare: (integer,integer)->integer);
begin
  var current:integer;
  var j:integer;
  for var i := 0 to n-1 do begin
    current := arr[i];
    j := i - 1;
    while (j >= 0) and (compare(current, arr[j]) <= 0) do begin
      arr[j + 1] := arr[j];
      j := j - 1;
    end;
    arr[j + 1] := current;
  end;
end;


procedure mergeSort(a: array of integer; l: integer; r : integer; compare: (integer,integer)->integer);
begin
  if l < r then begin
    var middle:integer;
    middle := l + ((r - l) div 2);
    mergeSort(arr, l, middle, compare);
    mergeSort(arr, middle + 1, r, compare);
  
    var ln:integer = middle - l + 1;
    var rn:integer = r - middle;

    var ls:array of integer;
    var rs:array of integer;
  
    SetLength(ls, ln);
    SetLength(rs, rn);
    var i:integer;
    var j:integer;
    var k:integer;
    for i := 0 to ln-1 do begin
      ls[i] := a[l + i];
    end;
    for i := 0 to rn-1 do begin
      rs[i] := a[middle + 1 + i];
    end;
    
    i := 0;
    j := 0;
    k := l;
    while (i < ln) and (j < rn) do begin
      if ls[i] <= rs[j] then begin
        arr[k] := ls[i];
        i := i + 1;
      end else begin
        arr[k] := rs[j];
        j := j + 1;
      end;
      k := k + 1;
    end;
    while i < ln do begin
      arr[k] := ls[i];
      i := i + 1;
      k := k + 1;
    end;
    while j < rn do begin
      arr[k] := rs[j];
      j := j + 1;
      k := k + 1;
    end;
    SetLength(rs, 0);
    SetLength(ls, 0);
  end;
end;


procedure readInputs(); begin
  Assign(input, 'lab1c/test.txt');
  Reset(input);
  Read(input, &n);
  SetLength(arr, n);
  SetLength(arr, n);
  for var i := 0 to n-1 do begin
    Read(input, &arr[i]);
  end;
  Close(input);
end;


procedure writeOutput(name : string); begin
  Assign(output, name);
  Rewrite(output);
  for var i := 0 to n-1 do begin
    Writeln(output, &arr[i]);
  end;
  Flush(output);
  Close(output);
end;

begin
  readInputs();
  Writeln('Begin');
  insertionSort(&arr, n, (a,b) -> a-b);
  Writeln('Sorted');
  readInputs();
  mergeSort(&arr, 0, n-1, (a,b) -> a-b);
  Writeln('Sorted');
  writeOutput('lab1c/sorted.txt');
  
//  Writeln('arr ', arr);
end.