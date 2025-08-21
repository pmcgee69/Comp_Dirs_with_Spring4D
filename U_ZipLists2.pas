unit U_ZipLists2;

interface
uses spring.Collections, U_DirSnapshot2;

function ZipDirSnapshots(const snap1,snap2: TDirectorySnapshot) : IEnumerable<File2s>;

implementation


// Enhanced ZipByValue that works with file info

function ZipDirSnapshots(const snap1,snap2: TDirectorySnapshot) : IEnumerable<File2s>;
begin
  var list_both  := snap1.Files.Intersect(snap2.Files, RelPathComp);
  var list_left  := snap1.Files.Exclude  (list_both,   RelPathComp);
  var list_right := snap2.Files.Exclude  (list_both,   RelPathComp);


  Result :=     TEnumerable.Select<TFileInfo,File2s>(
                        list_both,
                        function(const f: TFileInfo): File2s
                        begin
                           result := File2s.Create(f,both,snap2.Files);
                        end
                )
                .Concat (
                TEnumerable.Select<TFileInfo,File2s>(
                        list_left,
                        function(const f: TFileInfo): File2s
                        begin
                           result := File2s.Create(f,left);
                        end
                )
                )
                .Concat (
                TEnumerable.Select<TFileInfo,File2s>(
                        list_right,
                        function(const f: TFileInfo): File2s
                        begin
                           result := File2s.Create(f,right);
                        end
                )
                );
end;



end.


