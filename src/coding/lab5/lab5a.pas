type
   comparator = function(a: integer; b: integer): integer;

var
  arr: array of integer;
  n, current, i, j: integer;
  input, output: text;
  
 
function compare(a:integer; b: integer): integer;
begin
    compare := a-b;
end;
  
procedure insertionSort(a: array of integer; n : integer; compare: comparator);
begin
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

begin
  Assign(input, 'input.txt');
  Reset(input);
  Read(input, &n);
  SetLength(arr, n);
  SetLength(arr, n);
  for i := 0 to n-1 do begin
    Read(input, &arr[i]);
  end;
  Close(input);
  
  insertionSort(&arr, n, compare);
  
  Assign(output, 'output.txt');
  Rewrite(output);
  for i := 0 to n-1 do begin
    Write(output, &arr[i]);
    if i < n-1 then Write(output, ' ');
  end;
  Writeln(output, '');
  Flush(output);
  Close(output);
end.