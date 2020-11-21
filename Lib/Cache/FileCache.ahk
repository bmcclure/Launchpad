#Include Cache.ahk

class FileCache extends Cache {
    cachePath := ""

    __New(app, cachePath := "") {
        if (cachePath == "") {
            cachePath := A_Temp . "\Launchpad\Cache"
        }

        this.cachePath := cachePath
        DirCreate(this.cachePath)

        super.__New(app)
    }

    ItemExists(path) {
        return FileExist(this.GetCachePath(path))
    }

    ReadItem(path) {
        return (this.ItemExists(path)) ? FileRead(this.GetCachePath(path)) : ""
    }

    WriteItem(path, content) {
        this.CreateCacheDir(path)
        path := this.GetCachePath(path)

        if (FileExist(path)) {
            FileDelete(path)
        }
        
        FileAppend(content, path)
    }

    RemoveItem(path) {
        path := this.GetCachePath(path)

        if (path != "" and FileExist(path)) {
            FileDelete(path)
        }
    }

    GetItemTimestamp(path) {
        return (this.ItemExists(path)) ? FileGetTime(this.GetCachePath(path), "M") : ""
    }

    FlushCache() {
        if (DirExist(this.cachePath)) {
            DirDelete(this.cachePath, true)
        }
        
        DirCreate(this.cachePath)
    }

    CreateCacheDir(path) {
        path := this.GetCachePath(path)
        SplitPath(path,,cacheDir)
        DirCreate(cacheDir)
    }

    GetCachePath(path) {
        return this.cachePath "\" . this.ConvertPathToDestinationFormat(path)
    }

    ConvertPathToDestinationFormat(path) {
        return StrReplace(path, "/", "\")
    }

    ImportItemFromUrl(path, url) {
        this.CreateCacheDir(path)
        filePath := this.GetCachePath(path)

        Download(url, filePath)
        return filePath
    }

    CopyItem(path, destination) {
        sourcePath := this.GetCachePath(path)
        
        if (path != "" and sourcePath != "" and destination != "" and sourcePath != destination) {
            FileCopy(sourcePath, destination, true)
        }

        return destination
    }
}
