unit U_DirSnapshot2;

interface
uses system.SysUtils, system.IOUtils, System.Generics.Defaults, spring.Collections;

type

  TFileMatch = (both,left,right);

  TFileInfo = record
    RelativePath : string;
    FullPath     : string;
    Size         : Int64;
    ModifiedTime : TDateTime;
    Side         : TFileMatch;
    constructor    Create(const ARelativePath, AFullPath: string; ASize: Int64; AModified: TDateTime; ASide: TFileMatch);
  end;

  TFileInfoRelPathComp = class(TInterfacedObject, IEqualityComparer<TFileInfo>)
  public
    function Equals(const left, right: TFileInfo): Boolean;
    function GetHashCode(const value: TFileInfo): Integer;
  end;


  File2s = record
    match : TFileMatch;
    diff  : TPair<TFileInfo, TFileInfo>;
    constructor create(const f:TFileInfo; m:TFileMatch; snap2: IList<TFileInfo> = nil);
  end;


  TDirectorySnapshot = class
  private
    FFiles: IList<TFileInfo>;
  public
    property    Files: IList<TFileInfo> read FFiles;
    function    GetRelativePaths:  IEnumerable<string>;
    constructor Create(const ARootPath: string; Side: TFileMatch);
  end;

var
  RelPathComp  : TFileInfoRelPathComp;


implementation


constructor TFileInfo.Create(const ARelativePath, AFullPath: string; ASize: Int64; AModified: TDateTime; ASide: TFileMatch);
begin
  RelativePath := ARelativePath;
  FullPath     := AFullPath;
  Size         := ASize;
  ModifiedTime := AModified;
  Side         := ASide;
end;


constructor File2s.create(const f:TFileInfo; m:TFileMatch; snap2: IList<TFileInfo> = nil);
var
      f2 : TFileInfo;
begin
  var nil_case := Default(TFileInfo); // Empty record
      match    := m;
      case m of
         left  : diff := TPair<TFileInfo, TFileInfo>.Create(f,nil_case);
         right : diff := TPair<TFileInfo, TFileInfo>.Create(nil_case,f);
         both  : begin
                 f2   := snap2.FirstOrDefault( function(const fp: TFileInfo) : boolean
                                               begin
                                                 exit(fp.RelativePath=f.RelativePath);
                                               end );
                 diff := TPair<TFileInfo, TFileInfo>.Create(f,f2);
                 end;
      end;
end;


function TFileInfoRelPathComp.Equals(const left, right: TFileInfo): Boolean;
begin
  Result := SameText(left.RelativePath, right.RelativePath);
  // Use SameText for case-insensitive comparison, or use left.RelativePath = right.RelativePath for case-sensitive
end;


function TFileInfoRelPathComp.GetHashCode(const value: TFileInfo): Integer;
begin
  Result := BobJenkinsHash(PChar(UpperCase(value.RelativePath))^, Length(value.RelativePath) * SizeOf(Char), 0);
  // Use UpperCase if you used SameText in Equals for consistency
  // Or use value.RelativePath directly if using case-sensitive comparison
end;


function TDirectorySnapshot.GetRelativePaths: IEnumerable<string>;
begin
  Result := TEnumerable.Select< TFileInfo,string >
                        ( FFiles,
                          function(const fileInfo: TFileInfo): string
                          begin
                            Result := fileInfo.RelativePath;
                          end
                        );
end;


constructor TDirectorySnapshot.Create(const ARootPath: string; Side: TFileMatch);
begin
  FFiles := TCollections.CreateList<TFileInfo>;
  var fileInfo: TSearchRec;
  var allFiles := TDirectory.GetFiles(ARootPath, '*.*', TSearchOption.soAllDirectories);

  writeln('1*');
  for var filePath in allFiles do
  begin
    var relativePath := ExtractRelativePath(IncludeTrailingPathDelimiter(ARootPath), filePath);

    if FindFirst(filePath, faAnyFile, fileInfo) = 0 then
    try
      FFiles.Add(TFileInfo.Create(relativePath, filePath, fileInfo.Size, fileInfo.TimeStamp, Side));
    finally
      FindClose(fileInfo);
    end;
  end;
end;




initialization

  RelPathComp  := TFileInfoRelPathComp.Create;

end.
