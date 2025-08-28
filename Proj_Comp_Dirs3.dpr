{$APPTYPE CONSOLE}
program Proj_Comp_Dirs3;

uses
  spring,
  spring.Collections,
  system.StrUtils,
  U_DirSnapshot2 in 'U_DirSnapshot2.pas';


var matched,removed,added : integer;

procedure CompareDirectoriesWithMultiMap;
begin
  var   snapshot1 := TDirectorySnapshot.Create('c:\users', left); //'d:\Obsidian Vault');
  var   snapshot2 := TDirectorySnapshot.Create('c:\users',right); // 'd:\Obsidian Vault0');

  writeln('2*');
  try
    // Create multimap and populate with files from both directories
    var multiMap := TCollections.CreateMultiMap<string, TFileInfo>;

    snapshot1.Files.ForEach( procedure(const f: TFileInfo)
                             begin
                               multiMap.Add(f.RelativePath, f);
                             end
                           );

    snapshot2.Files.ForEach( procedure(const f: TFileInfo)
                             begin
                               multiMap.Add(f.RelativePath, f);
                             end
                           );

    writeln('3*');
    for var key in multiMap.Keys.Distinct do
                             begin
                               var values := multiMap.Items[key];   // Gets all values for this key
                                   case values.Count of
                                       1: case values.First.Side of
                                              left : begin
                                                     //writeln('REMOVED: ', values.First.RelativePath);
                                                     inc(removed);
                                                     end;
                                              right: begin
                                                     //writeln('ADDED  : ', values.First.RelativePath);
                                                     inc(added);
                                                     end;
                                          end;
                                       2: begin      //writeln('MATCHED: ', values.First.RelativePath);
                                                     inc(matched);
                                          end;
                                   end;

                                 //writeln('Key: ',key, ' has ',values.Count,' values');
                             end;
  finally
    snapshot1.Free;
    snapshot2.Free;
    writeln('m: ',matched,'  r: ',removed,'  a: ',added);
  end;
end;


begin
   CompareDirectoriesWithMultiMap;
   readln;
end.
