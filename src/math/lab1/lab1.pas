 var A,B,C,D,E,X,Y,K: set of string;
 var C2: set of real;
 var n, i :integer;
 var el :string;
 var realTmp :real;
 var charTmp :char;
 var integerTmp, integerTmp2 :integer;
 var code :integer;
 var ok :integer;
    
 // Обработка неправильного пользовательского ввода
 procedure readN();
 begin
    ok := 1;
    while ok = 1 do begin
      try
        Readln(&n);
        ok := 0;
      except
          Writeln('Некорректный ввод, желаете повторить (0 - нет, 1 - да)?');
          Readln(&integerTmp);
          if integerTmp = 0 then ok := 0;
      end;
    end;
 end;
 
 begin
    // Ввод множества натуральных чисел
    Writeln('Введите мощность A (натуральных):');
    readN();
    Writeln('Введите элементы:');
    i := 0;
    while i < n do begin
      try
        Readln(&integerTmp);
        Str(integerTmp, &el);
        if el in A then begin
          Writeln('Уже есть');
        end else begin
          Include(A, el);
          i := i + 1;
        end;
      except
          Writeln('Некорректный ввод, желаете повторить (0 - нет, 1 - да)?');
          Readln(&integerTmp);
          if integerTmp = 0 then i := n;
      end;
    end;
    
    // Ввод множества действительных чисел
    Writeln('Введите мощность B (действительные):');
    readN();
    Writeln('Введите элементы:');
    i := 0;
    while i < n do begin
      try
        Readln(&realTmp);
        el := FloatToStr(realTmp);
        if el in B then begin
          Writeln('Уже есть');
        end else begin
          Include(B, el);
          i := i + 1;
        end;
      except
          Writeln('Некорректный ввод, желаете повторить (0 - нет, 1 - да)?');
          Readln(&integerTmp);
          if integerTmp = 0 then i := n;
      end;
    end;
    
    // Ввод множества рациональных чисел
    Writeln('Введите мощность C (рациональные):');
    readN();
    Writeln('Введите элементы (в формате целая, дробная ...):');
    i := 0;
    while i < n do begin
      try
        Readln(&integerTmp);
        Readln(&realTmp);
        Str(integerTmp, &el);
        el := el + '/' + FloatToStr(realTmp);
        realTmp := integerTmp / realTmp;
        if (el in C) or (realTmp in C2) then begin
          Writeln('Уже есть');
        end else begin
          Include(C, el);
          Include(C2, realTmp);
          i := i + 1;
        end;
      except
          Writeln('Некорректный ввод, желаете повторить (0 - нет, 1 - да)?');
          Readln(&integerTmp);
          if integerTmp = 0 then i := n;
      end;
    end;
    
    
    // Ввод множества латинских символов
    Writeln('Введите мощность D (лат):');
    readN();
    Writeln('Введите элементы:');
    i := 0;
    while i < n do begin
      Readln(&charTmp);
      el := charTmp;
      if (65 <= Ord(charTmp)) and (Ord(charTmp) <= 90) then begin
        if el in D then begin
          Writeln('Уже есть');
        end else begin
          Include(D, el);
          i := i + 1;
        end;
      end else begin
          Writeln('Некорректный ввод, желаете повторить (0 - нет, 1 - да)?');
          Readln(&integerTmp);
          if integerTmp = 0 then i := n;
      end;
    end;
    
    
    // Ввод множества кирилических символов
    Writeln('Введите мощность E (рус):');
    readN();
    Writeln('Введите элементы:');
    i := 0;
    while i < n do begin
      Readln(&charTmp);
      el := charTmp;
      if (1040 <= Ord(charTmp)) and (Ord(charTmp) <= 1103) then begin
        if el in E then begin
          Writeln('Уже есть');
        end else begin
          Include(E, el);
          i := i + 1;
        end;
      end else begin
          Writeln('Некорректный ввод, желаете повторить (0 - нет, 1 - да)?');
          Readln(&integerTmp);
          if integerTmp = 0 then i := n;
      end;
    end;
    
    // Вывод результата
    Writeln('A (натуральные) = ', A);
    Writeln('B (действительные) = ', B);
    Writeln('C (рациональные) = ', C);
    Writeln('D (лат)= ', D);
    Writeln('E (рус) = ', E);
   
    X := A + B + C;
    Y := E * D;
    K := X - Y;
    Writeln('X (пересечение A,B,C) = ', X);
    Writeln('Y (объединение E,D) = ', Y);
    Writeln('K (разность X\Y)= ', K);
    Writeln('K мощность = ', K.count);
 end.