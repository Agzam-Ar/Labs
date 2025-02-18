type
   comparator = function(j:longint; a:longint; b: longint): longint;

var
  arr: array of longint;
  n, current, i, j, step: longint;
  input, output: text;
  
 
function compareFunc(j:longint; a:longint; b: longint): longint;
begin
  if arr[j] >= current then begin
    arr[j + 1] := arr[j];
    j := j - 1;
    if j < 0 then arr[j + 1] := current;
    compareFunc := j;
  end else begin
    arr[j + 1] := current;
    compareFunc := -1;
  end;
end;
  
procedure insertionSort(n :longint; compare: comparator);
begin
     for i := 0 to n-1 do begin
        current := arr[i];
        j := i - 1;
        while (j >= 0) do begin
            j := compare(j, current, arr[j]);
        end;
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
  
  insertionSort(n, @compareFunc);
  
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