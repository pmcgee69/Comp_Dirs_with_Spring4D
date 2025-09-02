{$APPTYPE CONSOLE}
program Proj_Comp_Dirs5;

uses
  spring.Collections,
  U_DirSnapshot5 in 'U_DirSnapshot5.pas';

procedure CompareDirectoriesWithDict;
begin
  var matched := 0; var removed := 0; var added := 0;

  var dir_dict  := TCollections.CreateDictionary<string,TFileInfo>;

  var snapshot1 := TDirectorySnapshot.Create('c:\users', left,dir_dict); // 'd:\Obsidian Vault');
  var snapshot2 := TDirectorySnapshot.Create('c:\users',right,dir_dict); // 'd:\Obsidian Vault0');

      writeln('3*');

      for var pair in dir_dict do
      begin
            case pair.Value.Side of
             left : begin
                      inc(removed);
                      writeln('REMOVED: ', pair.Value.RelativePath);
                    end;
             right: begin
                      inc(added);
                      writeln('ADDED  : ', pair.Value.RelativePath);
                    end;
             both : begin
                      inc(matched);
                      writeln('MATCHED: ', pair.Value.RelativePath);
                    end;
            end;
          //writeln('Key: ',key, ' has ',values.Count,' values');
      end;

      writeln('m: ',matched,'  r: ',removed,'  a: ',added);
      snapshot1.Free;
      snapshot2.Free;
end;


begin
   CompareDirectoriesWithDict;
   readln;
end.


