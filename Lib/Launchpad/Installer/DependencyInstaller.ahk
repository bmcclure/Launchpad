class DependencyInstaller extends InstallerBase {
    name := "Launchpad Dependency Installer"
    version := "latest"

    __New(appState, cache, extraComponents := "", tmpDir := "") {
        components := []

        dbVersion := "1.0.2"

        ahkUrl := "https://www.autohotkey.com/download/2.0/AutoHotkey_" . A_AhkVersion . ".zip"
        ahkPath := "Vendor\AutoHotKey"
        ahkComponent := DownloadableInstallerComponent.new(ahkUrl, true, ahkPath, appState, "AutoHotKey", cache, "Dependencies", true, tmpDir, false)
        ahkComponent.version := A_AhkVersion
        components.Push(ahkComponent)

        mpressUrl := "https://github.com/bmcclure/launcher-db/releases/download/" . dbVersion . "/mpress.exe"
        mpressPath := "Vendor\AutoHotKey\Compiler\mpress.exe"
        mpressComponent := DownloadableInstallerComponent.new(mpressUrl, false, mpressPath, appState, "Mpress", cache, "AutoHotKey", true, tmpDir, false)
        mpressComponent.version := dbVersion
        components.Push(mpressComponent)

        ahk2ExeUrl := "https://github.com/bmcclure/launcher-db/releases/download/" . dbVersion . "/Ahk2Exe.exe"
        ahk2ExePath := "Vendor\AutoHotKey\Compiler\Ahk2Exe.exe"
        ahk2ExeComponent := DownloadableInstallerComponent.new(ahk2ExeUrl, false, ahk2ExePath, appState, "Ahk2Exe", cache, "AutoHotKey", true, tmpDir, false)
        ahk2ExeComponent.version := dbVersion
        components.Push(ahk2ExeComponent)

        iconsExtUrl := "https://www.nirsoft.net/utils/iconsext.zip"
        iconsExtPath := "Vendor\IconsExt"
        components.Push(DownloadableInstallerComponent.new(iconsExtUrl, true, iconsExtPath, appState, "IconsExt", cache, "Dependencies", false, tmpDir, false))

        protocAssetName := FileExist("C:\Program Files (x86)") ? "protoc-{{version}}-win64.zip" : "protoc-{{version}}-win32.zip"
        components.Push(GitHubReleaseInstallerComponent.new("protocolbuffers/protobuf", protocAssetName, true, "Vendor\Protoc", appState, "Protoc", cache, "Dependencies", true, tmpDir, false))

        if (extraComponents != "") {
            for (index, component in extraComponents) {
                components.Push(component)
            }
        }

        super.__New(appState, "Dependencies", cache, components, tmpDir := "")
    }
}
