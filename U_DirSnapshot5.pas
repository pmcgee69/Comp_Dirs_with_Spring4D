unit U_DirSnapshot5;

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
    constructor Create(const RootPath: string; Side: TFileMatch; Dict:IOrderedDictionary<string,TFileInfo>);
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


constructor TDirectorySnapshot.Create(const RootPath: string; Side: TFileMatch; Dict:IOrderedDictionary<string,TFileInfo>);
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
               case side of
                 left : Dict.Add(fi.RelativePath,fi);
                 right: if not Dict.ContainsKey(fi.RelativePath) then Dict.Add(fi.RelativePath,fi)
                                                                 else
                                                                   begin
                                                                      fi.Side := both;
                                                                      Dict[fi.RelativePath] := fi;
                                                                   end;
               end;
            finally
               FindClose(fileInfo);
            end;
      end;
end;


end.
