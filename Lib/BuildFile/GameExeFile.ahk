#Include ComposableBuildFile.ahk

class GameExeFile extends ComposableBuildFile {
    __New(app, config, launcherDir, key, filePath := "") {
        super.__New(app, config, launcherDir, key, ".exe", filePath)
    }

    ComposeFile() {
        assetsDir := this.app.AppConfig.AssetsDir . "\" . this.key

        exePath := this.FilePath
        iconPath := assetsDir . "\" . this.key . ".ico"
        ahkPath := assetsDir . "\" . this.key . ".ahk"
        
        ahk2ExePath := this.appDir . "\Vendor\AutoHotKey\Compiler\Ahk2Exe.exe"
        
        pid := RunWait(ahk2ExePath . " /in " . ahkPath . " /out " . exePath . " /icon " . iconPath)

        return this.FilePath
    }
}
