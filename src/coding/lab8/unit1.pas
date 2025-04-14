unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, MyFileUnit;
 

const
  bufferSize = 256 * 1024;//1024 * 512;//64;// * ;
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
  writers: array[0..1] of file of user;
  readers: array[0..1] of MyReader;
  //readers: array[0..1] of file of user;
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



  //chunkFiles: file of longint;
  chunkFiles: array[0..1] of file of longint;
  selectedChunk: longint;
  procedure showPage();

implementation

{$R *.lfm}

{ TForm1 }
      
function getField(value:user):longint;
begin
     getField := (value shr (mode*8)) and 255;
end;

procedure TForm1.onClickCreateFile(Sender: TObject);
begin
 if createFileDialog.Execute then begin
      AssignFile(myfile, createFileDialog.FileName);
      Rewrite(myfile);
      //CloseFile(myfile);
      //
      srcSize:= 1024*1024*1024 div 4 div bufferSize;
      for i := 1 to srcSize do begin
          for j := 0 to bufferSize-1 do begin
              buffer[j] := (1+random(4)) or ((1+random(3)) shl 8) or ((1+random(13)) shl 16) or ((20+random(30)) shl 24);
              //buffer[j] := (1) or (2 shl 8);// or (2 shl 8) or (3 shl 16) or (4 shl 24);
              //buffer[j].corpus := 1 + random(11);
              //buffer[j].course := 1 + random(4);
              //buffer[j].region := 20 + random(30);

              //buffer[j].firstname := 'Abacaba';
              //buffer[j].firstname[1] := Chr(Ord('A') + random(Ord('Z') - Ord('A')));
              //for k := 2 to 10 do begin
              //    buffer[j].firstname[k] := Chr(Ord('a') + random(Ord('z') - Ord('a')));
              //end;
              //buffer[j].lastname := 'Abacaba';
              //buffer[j].lastname[1] := Chr(Ord('A') + random(Ord('Z') - Ord('A')));
              //for k := 2 to 10 do begin
              //    buffer[j].lastname[k] := Chr(Ord('a') + random(Ord('z') - Ord('a')));
              //end;
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
      //AssignFile(myfile, selectedFileName);
                     
      //CloseFile(myfile);
      showPage();
 end;
end;

procedure TForm1.onClickCheck(Sender: TObject);
begin             
     if not selectedFileName.IsEmpty then begin
           AssignFile(reader, selectedFileName);
           Reset(reader);
           unread := FileSize(reader);

           Read(reader, lastElement);
           mystring := 'File is sorted';

           for i := 1 to unread-1 do begin
               Read(reader, element);
               if getField(lastElement) > getField(element) then begin
                  mystring := 'File is unsorted';
                  break;
               end;
               lastElement := element;
           end;
           CloseFile(reader);  
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
end;



procedure sortBuffer(low, high:longint);
begin 
      if low < high then begin
         k := buffer[high];
         i := low - 1;
         for j := low to high - 1 do begin
             if buffer[j] < k then begin
                i := i + 1;
                sortTmp := buffer[i];
                buffer[i] := buffer[j];
                buffer[j] := sortTmp;
             end;
         end;    
         i := i + 1;
         sortTmp := buffer[i];
         buffer[i] := buffer[j];
         buffer[j] := sortTmp;
         sortBuffer(low, i - 1);
         sortBuffer(i + 1, high);
      end;


    //for i := 0 to n-1 do begin
    //    for j := i to n-1 do begin
    //        if buffer[j] < buffer[i] then begin
    //              current := buffer[i];
    //              buffer[i] := buffer[j];
    //              buffer[j] := current;
    //        end;
    //    end;
    //end;
    //for i := 0 to n-1 do begin
    //    current := buffer[i];
    //    j := i - 1;
    //    while (j >= 0) and (getField(current) - getField(buffer[j]) <= 0) do begin
    //        buffer[j + 1] := buffer[j];
    //        j := j - 1;
    //    end;
    //    buffer[j + 1] := current;
    //end;
end;

procedure TForm1.onClickSort(Sender: TObject);
begin
      //linesList := TStringList.Create;
      //for j := 0 to visibleElements-1 do begin
      //    str(buffer[j], mystring);
      //    str(page*pageSize + j + 1, tmpstring);
      //    mystring := tmpstring + ') ' + mystring;
      //    str(totalElements, tmpstring);
      //    mystring := mystring + ' of ' + tmpstring;
      //    linesList.Add(mystring);
      //end;

     if not selectedFileName.IsEmpty then begin
          AssignFile(src, selectedFileName);
          Reset(src);

          chunks[0] := selectedFileName + '.0';
          chunks[1] := selectedFileName + '.1';
          chunks[2] := selectedFileName + '.2';
          chunks[3] := selectedFileName + '.3';

          AssignFile(writers[0], chunks[0]);
          AssignFile(writers[1], chunks[1]);
          Rewrite(writers[0]);
          Rewrite(writers[1]);

          chunk := 0;

          unread := FileSize(src);  
          srcSize := FileSize(src);
                
          Form1.Caption := 'Sorting';
          while unread > 0 do begin
		readSize := unread;
		if readSize > bufferSize then readSize := bufferSize;
                BlockRead(src, buffer, readSize);
		//sortBuffer(0, readSize);
                BlockWrite(writers[chunk], buffer, readSize);
		chunk := 1 - chunk;
		unread := unread - readSize;
          end;
                        
          CloseFile(writers[0]);
          CloseFile(writers[1]);
          CloseFile(src);
             
          chunk := 0;

          k := 1;

          //mystring:= '';
          //str(bufferSize*k, tmpstring);
          //mystring:= mystring + tmpstring;
          //str(srcSize, tmpstring);
          //mystring:= mystring + '/' + tmpstring;

          //bufferSize
          while bufferSize*k < srcSize do begin
          	AssignFile(readers[0], chunks[0 + chunk]);
          	AssignFile(readers[1], chunks[1 + chunk]);
          	AssignFile(writers[0], chunks[2 - chunk]);
          	AssignFile(writers[1], chunks[3 - chunk]);
                Reset(readers[0]);
                Reset(readers[1]);
                Rewrite(writers[0]);
                Rewrite(writers[1]);
                availableElements[0] := FileSize(readers[0]);
                availableElements[1] := FileSize(readers[1]);
                writerId := 0;

                                   
                    //mystring := '';
                str(k, tmpstring);
                //mystring := mystring + tmpstring;
                Form1.Caption := tmpstring;
                    //str(s1, tmpstring);
                    //mystring := mystring + ' ' + tmpstring;
                //linesList.add('merge ' + chunks[0 + chunk] + ' and ' + chunks[1 + chunk]);
                //linesList.add('to ' + chunks[3 - chunk] + ' and ' + chunks[2 - chunk]);

                while(availableElements[0] > 0) or (availableElements[1] > 0) do begin
                    s0 := availableElements[0];
                    s1 := availableElements[1];

                    if s0 > bufferSize*k then begin
                         s0 := bufferSize*k;
                    end;
                    if s1 > bufferSize*k then begin
                         s1 := bufferSize*k;
                    end;

                    str(k, mystring);
                    str(availableElements[0] + availableElements[1], tmpstring);
                    mystring := mystring + ': ' + tmpstring;
                    //str(availableElements[1], tmpstring);
                    //mystring := mystring + '/' + tmpstring;
                    Form1.Caption := mystring;

                    //mystring := '';
                    //str(s0, tmpstring);
                    //mystring := mystring + tmpstring;
                    //str(s1, tmpstring);
                    //mystring := mystring + ' ' + tmpstring;
                    //linesList.Add(mystring);


                    sizes[0] := s0;
                    sizes[1] := s1;

                    for i := 0 to 1 do begin
                        if sizes[i] = 0 then begin
                             continue;
                        end; 
                        Read(readers[i], elements[i]);
                        sizes[i] := sizes[i] - 1;
                    end;

                    i := 0;

                    if (s0 > 0) and (s1 > 0) then begin
                        while true do begin
                            //str(k, mystring);
                            //str(availableElements[0], tmpstring);
                            //mystring := mystring + ': ' + tmpstring;
                            //str(availableElements[1], tmpstring);
                            //mystring := mystring + '/' + tmpstring;
                            //str(sizes[0], tmpstring);
                            //mystring := mystring + ' -> ' + tmpstring;
                            //str(sizes[1], tmpstring);
                            //mystring := mystring + '/' + tmpstring;
                            //Form1.Caption := mystring;

                            //if getField(elements[0]) <= getField(elements[1]) then begin

                            //if elements[0] <= elements[1] then begin
                            //    i := 0;
                            //end else begin
                            //    i := 1;
                            //end; 
                            i := Ord(elements[0] > elements[1]);
                            BlockWrite(writers[writerId], elements[i], 1);
                            //Write(writers[writerId], elements[i]);
                            if sizes[i] = 0 then break;  
                            BlockRead(readers[i], elements[i], 1);
                            //Read(readers[i], elements[i]);
                            Dec(sizes[i]);
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
                        Write(writers[writerId], elements[i]);
                        if sizes[i] = 0 then begin
                           break;
                        end;
                        Read(readers[i], elements[i]);
                        sizes[i] := sizes[i] - 1;
                    end;
		    availableElements[0] := availableElements[0] - s0;
		    availableElements[1] := availableElements[1] - s1;
		    writerId := 1 - writerId;
                end;

                CloseFile(writers[0]);
                CloseFile(writers[1]);
                CloseFile(readers[0]);
                CloseFile(readers[1]);

                chunk := 2 - chunk;
                k := k + 1;
          end;

          AssignFile(writer, 'out.bin');
          AssignFile(reader, chunks[2-chunk]);

          Reset(reader);
          Rewrite(writer);

          unread := FileSize(reader);

          for i := 0 to unread-1 do begin
              Read(reader, element);
              Write(writer, element);
          end;

          CloseFile(writer);
          CloseFile(reader);
     end;
     //Form1.fileViewer.Lines.Assign(linesList);
     //linesList.Free;
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
begin                            
 Val(Form1.pageInput.Text, page, tmpcode);
 if not selectedFileName.IsEmpty then begin
      if page < 1 then page := 1;
      page := page - 1;
      AssignFile(myfile, selectedFileName); 
      reset(myfile);
      totalElements := FileSize(myfile);

      if page > totalElements div pageSize then page := totalElements div pageSize;

      visibleElements := pageSize;
      if page = totalElements div pageSize then visibleElements := totalElements mod pageSize;

      Seek(myfile, page*pageSize);
      BlockRead(myfile, buffer, visibleElements);

      linesList := TStringList.Create;
      for j := 0 to visibleElements-1 do begin  
          str(page*pageSize + j + 1, mystring);
          str(totalElements, tmpstring);
          mystring := mystring + '/' + tmpstring;
          str(buffer[j] and 255, tmpstring);
          mystring := mystring + ') group=' + tmpstring;
          str((buffer[j] shr 8) and 255, tmpstring);
          mystring := mystring + ', course=' + tmpstring;
          str((buffer[j] shr 16) and 255, tmpstring);
          mystring := mystring + ', corpus=' + tmpstring;
          str((buffer[j] shr 24) and 255, tmpstring);
          mystring := mystring + ', region=' + tmpstring;
          //str(mode, tmpstring);
          //mystring := mystring + 'mode=' + tmpstring;

          linesList.Add(mystring);
      end;
      Form1.fileViewer.Lines.Assign(linesList);
      linesList.Free;
      CloseFile(myfile);
 end;
end;


end.

