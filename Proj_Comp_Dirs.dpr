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
          if (pair.Key.RelativePath <> '') and (pair.Value.RelativePath <> '') then
               writeln('MATCHED: ', pair.Key.RelativePath)
          else if pair.Key.RelativePath <> '' then
               writeln('REMOVED: ', pair.Key.RelativePath)
          else
               writeln('ADDED: ', pair.Value.RelativePath);
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



