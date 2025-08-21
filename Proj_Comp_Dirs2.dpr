{$APPTYPE CONSOLE}
program Proj_Comp_Dirs2;

uses
  spring,
  spring.Collections,
  U_DirSnapshot2 in 'U_DirSnapshot2.pas',
  U_ZipLists2 in 'U_ZipLists2.pas';

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



