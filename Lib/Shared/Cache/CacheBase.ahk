class CacheBase {
    stateObj := ""

    __New(stateObj) {
        this.stateObj := stateObj
    }

    ItemExists(reference) {
        return this.stateObj.Exists(reference)
    }

    GetItemTimestamp(reference) {
        return this.stateObj.GetTimestamp(reference)
    }

    WriteItem(reference, content) {
        if (this.WriteItemAction(reference, content)) {
            this.stateObj.SetItem(reference)
        }
    }

    ReadItem(reference) {
        content := ""

        if (this.stateObj.Exists(reference)) {
            content := this.ReadItemAction(reference)
        }

        return content
    }

    SetNotFound(reference) {
        this.stateObj.SetNotFoundItem(reference)
    }

    RemoveItem(reference) {
        if (this.stateObj.Exists(reference)) {
            this.RemoveItemAction(reference)
            this.stateObj.RemoveItem(reference)
        }
    }

    FlushCache() {
        this.FlushCacheAction()
        this.stateObj.ClearItems()
    }

    ImportItemFromUrl(reference, url) {
        tempFile := this.app.Config.TempDir . "\cacheDownload"
        DirCreate(this.app.Config.TempDir)
        Download(url, tempFile)
        content := FileRead(tempFile)
        
        if (FileExist(tempFile)) {
            FileDelete(tempFile)
        }
        
        this.WriteItem(reference, content)

        return content
    }

    GetCacheAge(reference) {
        return this.stateObj.GetCacheAge(reference)
    }

    CopyItem(reference, destination) {
        if (this.ItemExists(reference)) {
            content := this.GetItem(reference)
            this.WriteItem(destination, content)
        }
        
        return destination
    }

    ItemNeedsUpdate(reference) {
        return this.stateObj.IsExpired(reference)
    }

    /**
    * ABSTRACT METHODS
    */

    WriteItemAction(reference, content) {
        throw(MethodNotImplementedException.new("CacheBase", "WriteItemAction"))
    }

    ReadItemAction(reference) {
        throw(MethodNotImplementedException.new("CacheBase", "ReadItemAction"))
    }

    RemoveItemAction(reference) {
        throw(MethodNotImplementedException.new("CacheBase", "RemoveItemAction"))
    }

    FlushCacheAction() {
        throw(MethodNotImplementedException.new("CacheBase", "FlushCacheAction"))
    }
}
