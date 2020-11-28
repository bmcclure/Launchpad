class LightpadThemeInstallerAsset extends FileInstallerAssetBase {
    __New(appState, stateKey, cache, parentStateKey := "", overwrite := false, tmpDir := "", onlyCompiled := false) {
        super.__New("Themes\Lightpad.json", appState, cache, stateKey, parentStateKey, overwrite, tmpDir, onlyCompiled)
    }

    InstallFilesAction() {
        if (this.overwrite and this.destPath != "Themes\Lightpad.json" and FileExist(this.destPath)) {
            FileDelete(this.destPath)
        }

        if (!FileExist(this.destPath)) {
            FileInstall "Themes\Lightpad.json", "Themes\Lightpad.json", !!(this.overwrite)
        }

        return super.InstallFilesAction()
    }
}
