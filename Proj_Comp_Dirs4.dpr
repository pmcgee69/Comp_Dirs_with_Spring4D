{$APPTYPE CONSOLE}
program Proj_Comp_Dirs4;

uses
  spring.Collections,
  U_DirSnapshot4 in 'U_DirSnapshot4.pas';


procedure CompareDirectoriesWithMultiMap;
var
      matched,removed,added : integer;
begin
  var multiMap  := TCollections.CreateMultiMap<string, TFileInfo>;

  var snapshot1 := TDirectorySnapshot.Create('c:\users', left,multimap); //'d:\Obsidian Vault');
  var snapshot2 := TDirectorySnapshot.Create('c:\users',right,multimap); // 'd:\Obsidian Vault0');

      writeln('3*');

      for var key in multiMap.Keys.Distinct do
      begin
        var values := multiMap.Items[key];   // Gets all values for this key
            case values.Count of
                1: case values.First.Side of
                       left : begin
                                inc(removed);
                              //writeln('REMOVED: ', values.First.RelativePath);
                              end;
                       right: begin
                                inc(added);
                              //writeln('ADDED  : ', values.First.RelativePath);
                              end;
                   end;
                2: begin
                                inc(matched);
                              //writeln('MATCHED: ', values.First.RelativePath);
                   end;
            end;
          //writeln('Key: ',key, ' has ',values.Count,' values');
      end;

      writeln('m: ',matched,'  r: ',removed,'  a: ',added);
      snapshot1.Free;
      snapshot2.Free;
end;


begin
   CompareDirectoriesWithMultiMap;
   readln;
end.


