{$APPTYPE CONSOLE}
program Proj_Comp_Dirs;

uses
  spring,
  spring.Collections,
  U_DirSnapshot in 'U_DirSnapshot.pas',
  U_ZipLists    in 'U_ZipLists.pas';


procedure CompareDirectories;
begin
  var   snapshot1 := TDirectorySnapshot.Create('d:\Obsidian Vault');
  var   snapshot2 := TDirectorySnapshot.Create('d:\Obsidian Vault0');

  try
    var comparison := ZipDirSnapshots(snapshot1, snapshot2);

    comparison.ForEach(
        procedure(const pair: File2s)
        begin
          case pair.match of
               both:  writeln('MATCHED: ', pair.diff.key.RelativePath);
               left:  writeln('REMOVED: ', pair.diff.key.RelativePath);
               right: writeln('ADDED  : ', pair.diff.value.RelativePath);
          end;
        end);
  finally
        snapshot1.Free;
        snapshot2.Free;
  end;
end;


begin
      CompareDirectories;
      readln;
end.



