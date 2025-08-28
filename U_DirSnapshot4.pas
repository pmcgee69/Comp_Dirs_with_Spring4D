unit U_DirSnapshot4;

interface
uses
system.SysUtils, system.IOUtils, spring.Collections;

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


  TDirectorySnapshot = class
  private
    FFiles: IList<TFileInfo>;
  public
    property    Files: IList<TFileInfo> read FFiles;
    constructor Create(const RootPath: string; Side: TFileMatch; MM: IMultiMap<string,TFileInfo>);
  //function    GetRelativePaths:  IEnumerable<string>;
  end;


implementation


constructor TFileInfo.Create(const ARelativePath, AFullPath: string; ASize: Int64; AModified: TDateTime; ASide: TFileMatch);
begin
  RelativePath := ARelativePath;
  FullPath     := AFullPath;
  Size         := ASize;
  ModifiedTime := AModified;
  Side         := ASide;
end;


constructor TDirectorySnapshot.Create(const RootPath: string; Side: TFileMatch; MM: IMultiMap<string,TFileInfo>);
begin
      FFiles   := TCollections.CreateList<TFileInfo>;
  var fi       :  TFileInfo;
  var fileInfo :  TSearchRec;
  var allFiles := TDirectory.GetFiles(RootPath, '*.*', TSearchOption.soAllDirectories);

      writeln('1*');
      for var filePath in allFiles do
      begin
        var relativePath := ExtractRelativePath(IncludeTrailingPathDelimiter(RootPath), filePath);

            if FindFirst(filePath, faAnyFile, fileInfo) = 0 then
            try
               fi := TFileInfo.Create(relativePath, filePath, fileInfo.Size, fileInfo.TimeStamp, Side);
               FFiles.Add(fi);
               MM.Add(fi.RelativePath,fi);
            finally
               FindClose(fileInfo);
            end;
      end;
end;


end.
