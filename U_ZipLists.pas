unit U_ZipLists;

interface
uses spring.Collections, U_DirSnapshot;

type
   File2s = TPair<TFileInfo, TFileInfo>;

function ZipDirSnapshots(const snap1,snap2: TDirectorySnapshot) : IEnumerable<File2s>;

implementation


// Enhanced ZipByValue that works with file info

function ZipDirSnapshots(const snap1,snap2: TDirectorySnapshot) : IEnumerable<File2s>;
begin
  var nil_case   := Default(TFileInfo); // Empty record

  var list_both  := snap1.Files.Intersect(snap2.Files, RelPathComp);
  var list_left  := snap1.Files.Exclude  (list_both,   RelPathComp);
  var list_right := snap2.Files.Exclude  (list_both,   RelPathComp);


  Result :=     TEnumerable.Select<TFileInfo,File2s>(
                        list_both,
                        function(const f: TFileInfo): File2s
                        begin
                           result := File2s.Create(f,f);
                        end
                )
                .Concat (
                TEnumerable.Select<TFileInfo,File2s>(
                        list_left,
                        function(const f: TFileInfo): File2s
                        begin
                           result := File2s.Create(f,nil_case);
                        end
                )
                )
                .Concat (
                TEnumerable.Select<TFileInfo,File2s>(
                        list_right,
                        function(const f: TFileInfo): File2s
                        begin
                           result := File2s.Create(nil_case,f);
                        end
                )
                );
end;

end.



type
   ints   = TPair<integer,Integer>;

procedure ZipLists;
begin
  var list1 := TCollections.CreateList<Integer>([1,2,3,4,5,6]);
  var list2 := TCollections.CreateList<Integer>([2,4,6,8,10,12]);

  var lista := list1.Intersect(list2);
  var listb := list1.Exclude(list2);
  var listc := list2.Exclude(list1);

      for var i in listb do writeln(i);   writeln;
      for var i in listc do writeln(i);   writeln;

  var result := TEnumerable.Select<integer,Ints>(
                              lista,
                              function(const x: integer): Ints
                              begin
                                 result := Ints.Create(x,x);
                              end
                            )
                .Concat (
                TEnumerable.Select<integer,Ints>(
                              listb,
                              function(const x: integer): Ints
                              begin
                                 result := Ints.Create(x,0);
                              end
                )
                )
                .Concat (
                TEnumerable.Select<integer,Ints>(
                              listc,
                              function(const x: integer): Ints
                              begin
                                 result := Ints.Create(0,x);
                              end
                )
                );

      for var i in result do writeln( i.Key:3,' ',i.Value:3 );
end;


