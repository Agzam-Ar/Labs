unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, MyFileUnit;
 

const
  bufferSize = 1024 * 1024 * 16;
  pageSize = 20;

type

  { TForm1 }

                               
  user = longint;

  bArray = array[0..bufferSize - 1] of user;

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    checkButton: TButton;
    modeSelect: TComboBox;
    sortButton: TButton;
    createFileDialog: TSaveDialog;
    fileViewer: TMemo;
    pageInput: TEdit;
    Label1: TLabel;
    openDialog: TOpenDialog;
    procedure onClickCheck(Sender: TObject);
    procedure onClickSelectFile(Sender: TObject);
    procedure onClickCreateFile(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure onClickSort(Sender: TObject);
    procedure onModeSelect(Sender: TObject);
    procedure onPageChange(Sender: TObject);
    procedure saveFileTo(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  myfile: file of user;
  buffer: bArray;
  bufferIndex: longint;  
  bufferIndexes: array[0..1] of user;
  totalElements: longint;          
  buffers: array[0..1] of bArray;

  currentBuffer: bArray;
  nextBuffer: bArray;
  selectedFileName : string;
  i: longint;
  j: longint;
  a1: longint;
  a2: longint;   
  i1: longint;
  i2: longint;
  page: longint;
  totalElements1: longint;
  totalElements2: longint;
  visibleElements: longint;
  linesList: TStringList;
  mystring: string;
  tmpstring: string;
  tmpcode: longint;
  tmpivalue: longint;
  chunkName1 : string;
  chunkName2 : string;

  current: user;

  mode: longint;

  src : file of user;
  srcSize : longint;
  chunks : array[0..3] of string;
  writers: array[0..1] of MyWriter;
  readers: array[0..1] of MyReader;
  reader: file of user;
  writer: file of user;
  chunk: longint;     
  unread: longint;
  readSize: longint;
  k: longint;
  availableElements: array[0..1] of longint;
  writerId: longint;
  s0, s1: longint;
  sizes: array[0..1] of longint;
  elements: array[0..1] of user;
  element : user;
  lastElement : user;

  sortTmp : user;
  sortPivot : longint;
  sortIndex : longint;


  //chunkFiles: file of longint;
  chunkFiles: array[0..1] of file of longint;
  selectedChunk: longint;
  procedure showPage();

implementation

{$R *.lfm}

{ TForm1 }

function getFieldMode(value, mode:user):longint;
begin
     getFieldMode := (value shr (mode*8)) and 255;
end;

function getField(value:user):longint;
begin
     getField := (value shr (mode*8)) and 255;
end;

procedure TForm1.onClickCreateFile(Sender: TObject);
begin
 if createFileDialog.Execute then begin
      AssignFile(myfile, createFileDialog.FileName);
      Rewrite(myfile);
      srcSize:= 1024*1024*1024 div 4 div bufferSize;
      for i := 1 to srcSize do begin
          for j := 0 to bufferSize-1 do begin
              buffer[j] := (1+random(4)) or ((1+random(3)) shl 8) or ((1+random(13)) shl 16) or ((20+random(30)) shl 24);
              srcSize := srcSize - 1;
          end;
          BlockWrite(myfile, buffer, bufferSize);
      end;  
      CloseFile(myfile);    
      selectedFileName := createFileDialog.FileName;  
      Form1.Caption := selectedFileName;
      showPage();
 end;
end;

procedure TForm1.onClickSelectFile(Sender: TObject);
begin
 if openDialog.Execute then begin
      selectedFileName := openDialog.FileName;
      Form1.Caption := selectedFileName;
      showPage();
 end;
end;

procedure TForm1.onClickCheck(Sender: TObject);
begin             
     if not selectedFileName.IsEmpty then begin
           readers[0].open(selectedFileName);
           unread := readers[0].incoming;
           lastElement := getField(readers[0].next());
           mystring := 'File is sorted';

           for i := 1 to unread-1 do begin
               element := getField(readers[0].next());
               if lastElement > element then begin
                  Str(i, tmpstring);
                  mystring := 'File is unsorted at ' + tmpstring;
                  Str((i-1) div pageSize, tmpstring);
                  mystring := mystring + ' (page ' + tmpstring;
                  Str(lastElement, tmpstring);
                  mystring := mystring + ') ' + tmpstring;
                  Str(element, tmpstring);
                  mystring := mystring + ' > ' + tmpstring;
                  break;
               end;
               lastElement := element;
           end;
           readers[0].close();
           linesList := TStringList.Create;
           linesList.add(mystring);
           Form1.fileViewer.Lines.Assign(linesList);
           linesList.Free;
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 linesList:=TStringList.Create;
 Form1.fileViewer.Lines.Assign(linesList);
 Form1.Caption := '';
 readers[0] := MyReader.Create;
 readers[1] := MyReader.Create;
 writers[0] := MyWriter.Create;
 writers[1] := MyWriter.Create;
end;

procedure QSort ( first, last: longint);
var L, R, c, X: longint;
begin
   if first < last then
   begin
      X:= getField(buffer[(first + last) div 2]);
      L:= first;
      R:= last;
         while L <= R do
         begin
            while getField(buffer[L]) < X do
               L:= L + 1;
            while getField(buffer[R]) > X do
               R:= R - 1;
            if L <= R then
            begin
               c:= buffer[L];
               buffer[L]:= buffer[R];
               buffer[R]:= c;
               L:= L + 1;
               R:= R - 1;
            end;
        end;
     QSort(first, R);
     QSort(L, last);
  end;
end;

procedure TForm1.onClickSort(Sender: TObject);
begin
     if not selectedFileName.IsEmpty then begin
          AssignFile(src, selectedFileName);
          Reset(src);

          chunks[0] := selectedFileName + '.0';
          chunks[1] := selectedFileName + '.1';
          chunks[2] := selectedFileName + '.2';
          chunks[3] := selectedFileName + '.3';

          writers[0].open(chunks[0]);
          writers[1].open(chunks[1]);

          chunk := 0;

          unread := FileSize(src);  
          srcSize := FileSize(src);
                
          Form1.Caption := 'Sorting';
          while unread > 0 do begin
		readSize := unread;
		if readSize > bufferSize then readSize := bufferSize;
                BlockRead(src, buffer, readSize);

                // Debug
                str(unread, mystring);
                str(readSize, tmpstring);
                Form1.Caption := 'Sorting ' + mystring + ' -> ' + tmpstring;

		QSort(0, readSize-1);
                BlockWrite(writers[chunk].fi, buffer, readSize);
		chunk := 1 - chunk;
		unread := unread - readSize;
          end;

          writers[0].close();
          writers[1].close();
          CloseFile(src);
             
          chunk := 0;
          k := 1;

          while bufferSize*k < srcSize do begin
                readers[0].open(chunks[0 + chunk]);
                readers[1].open(chunks[1 + chunk]);
                writers[0].open(chunks[2 - chunk]);
                writers[1].open(chunks[3 - chunk]);
                availableElements[0] := readers[0].incoming;
                availableElements[1] := readers[1].incoming;
                writerId := 0;

                while(availableElements[0] > 0) or (availableElements[1] > 0) do begin
                    s0 := availableElements[0];
                    s1 := availableElements[1];

                    if s0 > bufferSize*k then begin
                         s0 := bufferSize*k;
                    end;
                    if s1 > bufferSize*k then begin
                         s1 := bufferSize*k;
                    end;

                    // Debug
                    str(k, mystring);       
                    str(srcSize div bufferSize, tmpstring);
                    mystring := mystring + '/' + tmpstring;
                    str(availableElements[0] + availableElements[1], tmpstring);
                    mystring := mystring + ': ' + tmpstring;
                    Form1.Caption := mystring;

                    sizes[0] := s0;
                    sizes[1] := s1;

                    for i := 0 to 1 do begin
                        if sizes[i] = 0 then begin
                             continue;
                        end;
                        elements[i] := readers[i].next();
                        sizes[i] := sizes[i] - 1;
                    end;

                    i := 0;

                    if (s0 > 0) and (s1 > 0) then begin
                        while true do begin 
                            if getField(elements[0]) <= getField(elements[1]) then begin
                                i := 0;
                            end else begin
                                i := 1;
                            end;
                            writers[writerId].write(elements[i]);
                            if sizes[i] = 0 then break;
                            elements[i] := readers[i].next();
                            sizes[i] := sizes[i] - 1;
                        end;
                        i := 1 - i;
                    end else begin
                        if s0 = 0 then begin
                            i := 1;
                        end else begin
                            i := 0;
                        end;
                    end;
                    while true do begin
                        writers[writerId].write(elements[i]);
                        if sizes[i] = 0 then begin
                           break;
                        end;
                        elements[i] := readers[i].next();
                        sizes[i] := sizes[i] - 1;
                    end;
		    availableElements[0] := availableElements[0] - s0;
		    availableElements[1] := availableElements[1] - s1;
		    writerId := 1 - writerId;
                end;
                writers[0].close();
                writers[1].close();
                readers[0].close();
                readers[1].close();
                chunk := 2 - chunk;
                k := k * 2;
          end;
          Form1.Caption := 'Copying';
          writers[0].open('out.bin');
          readers[0].open(chunks[0]);
          unread := readers[0].incoming;
          for i := 0 to unread-1 do begin
              writers[0].write(readers[0].next());
          end;
          writers[0].close();
          readers[0].close();
          Form1.Caption := 'Ready';
     end;
     selectedFileName := 'out.bin';
     showPage();
end;

procedure TForm1.onModeSelect(Sender: TObject);
begin
  mode := Form1.modeSelect.ItemIndex;
end;

procedure TForm1.onPageChange(Sender: TObject);
begin
     showPage();
end;

procedure TForm1.saveFileTo(Sender: TObject);
begin

end;


procedure showPage();
var lastPage:longint;
begin                            
 Val(Form1.pageInput.Text, page, tmpcode);
 if not selectedFileName.IsEmpty then begin 
      page := page - 1;
      if page < 0 then page := 0;
      AssignFile(myfile, selectedFileName); 
      reset(myfile);
      totalElements := FileSize(myfile);
      lastPage := totalElements div pageSize;
      if totalElements mod pageSize = 0 then lastPage := lastPage - 1;

      if page > lastPage then page := lastPage;

      visibleElements := pageSize;
      if page = lastPage then visibleElements := totalElements mod pageSize;
                         
      linesList := TStringList.Create;

      Seek(myfile, page*pageSize);
      BlockRead(myfile, buffer, visibleElements);

      for j := 0 to visibleElements-1 do begin  
          str(page*pageSize + j + 1, mystring);
          str(totalElements, tmpstring);
          mystring := mystring + '/' + tmpstring;
          str(getFieldMode(buffer[j], 0), tmpstring);
          mystring := mystring + ') group=' + tmpstring;
          str(getFieldMode(buffer[j], 1) and 255, tmpstring);
          mystring := mystring + ', course=' + tmpstring;
          str(getFieldMode(buffer[j], 2) and 255, tmpstring);
          mystring := mystring + ', corpus=' + tmpstring;
          str(getFieldMode(buffer[j], 3) and 255, tmpstring);
          mystring := mystring + ', region=' + tmpstring;
          linesList.Add(mystring);
      end;
      Form1.fileViewer.Lines.Assign(linesList);
      linesList.Free;
      CloseFile(myfile);
 end;
end;


end.

