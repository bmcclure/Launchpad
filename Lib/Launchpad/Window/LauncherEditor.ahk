﻿/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class LauncherEditor extends EntityEditorBase {
    knownGames := ""
    knownThemes := ""
    launcherTypes := ""
    gameTypes := ""

    __New(app, entityObj, mode := "config", windowKey := "", owner := "", parent := "") {
        if (windowKey == "") {
            windowKey := "LauncherEditor"
        }

        if (owner == "") {
            owner := "MainWindow"
        }

        super.__New(app, entityObj, "Launcher Editor", mode, windowKey, owner, parent)
    }

    Controls() {
        super.Controls()
        tabs := this.guiObj.Add("Tab3", " x" . this.margin . " w" . this.windowSettings["contentWidth"] . " +0x100", ["General", "Sources", "Advanced"])

        tabs.UseTab("General", true)
        this.AddComboBox("Key", "Key", this.entityObj.Key, this.knownGames, "Select an existing game from the API, or enter a custom game key to create your own. Use caution when changing this value, as it will change which data is requested from the API.")
        this.AddEntityTypeSelect("Launcher", "LauncherType", this.entityObj.ManagedLauncher.EntityType, this.launcherTypes, "LauncherConfiguration", "This tells Launchpad how to interact with any launcher your game might require. If your game's launcher isn't listed, or your game doesn't have a launcher, start with `"Default`".")
        this.AddEntityTypeSelect("Game", "GameType", this.entityObj.ManagedLauncher.ManagedGame.EntityType, this.gameTypes, "GameConfiguration", "This tells Launchpad how to launch your game. Most games can use 'default', but launchers can support different game types.")

        tabs.UseTab("Sources", true)
        this.AddLocationBlock("Icon Source", "IconSrc", "Clear")
        this.AddSelect("Launcher Theme", "ThemeName", this.entityObj.ThemeName, this.knownThemes)
        ; @todo Add data source keys checkboxes
        ; @todo Add data source item key

        tabs.UseTab("Advanced", true)
        this.AddTextBlock("DisplayName", "Display Name", true, "You can change the display name of the game if it differs from the key. The launcher filename will still be created using the key.")

        tabs.UseTab()
    }

    Create() {
        super.Create()
        this.knownGames := this.dataSource.ReadListing("Games")
        this.launcherTypes := this.dataSource.ReadListing("Types/Launchers")
        this.gameTypes := this.dataSource.ReadListing("Types/Games")
        this.knownThemes := this.app.Themes.GetAvailableThemes(true)
    }

    OnDefaultDisplayName(ctlObj, info) {
        return this.SetDefaultValue("DisplayName", !!(ctlObj.Value))
    }

    OnDefaultGameType(ctlObj, info) {
        return this.SetDefaultValue("GameType", !!(ctlObj.Value))
    }

    OnKeyChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.Key := ctlObj.Value

        ; @todo If new game type doesn't offer the selected launcher type, change to the default launcher type
    }

    OnLauncherTypeChange(ctlObj, info) {
        this.entityObj.ManagedLauncher.EntityType := ctlObj.Value
        this.entityObj.ManagedLauncher.UpdateDataSourceDefaults()

        ; @todo If new launcher type changes the game type, change it here
    }

    OnGameTypeChange(ctlObj, info) {
        this.entityObj.ManagedLauncher.ManagedGame.EntityType := ctlObj.Value
        this.entityObj.ManagedLauncher.ManagedGame.UpdateDataSourceDefaults()
    }

    OnLauncherConfiguration(ctlObj, info) {
        entity := this.entityObj.ManagedLauncher
        diff := entity.Edit(this.mode, this.guiObj)

        if (diff != "" and diff.ValueIsModified("LauncherType")) {
            this.guiObj["LauncherType"].Value := this.GetItemIndex(this.launcherTypes, entity.GetValue("Type"))
        }
    }

    OnGameConfiguration(ctlObj, info) {
        entity := this.entityObj.ManagedLauncher.ManagedGame
        diff := entity.Edit(this.mode, this.guiObj)

        if (diff != "" and diff.ValueIsModified("GameType")) {
            this.guiObj["GameType"].Value := this.GetItemIndex(this.gameTypes, entity.GetValue("Type"))
        }
    }

    OnDisplayNameChange(ctlObj, info) {
        this.guiObj.Submit(false)
        this.entityObj.DisplayName := ctlObj.Value
    }

    OnChangeIconSrc(btn, info) {
        existingVal := this.entityObj.UnmergedConfig.Has("IconSrc") ? this.entityObj.UnmergedConfig["IconSrc"] : ""

        if (!existingVal and this.entityObj.Config.Has("IconSrc")) {
            existingVal := this.entityObj.Config["IconSrc"]
        }

        file := FileSelect(1,, this.entityObj.Key . ": Select icon or .exe to extract icon from.", "Icons (*.ico; *.exe)")

        if (file) {
            this.entityObj.UnmergedConfig["IconSrc"] := file
            this.modified := true
            this.guiObj["IconSrc"].Text := file
        }
    }

    OnOpenIconSrc(btn, info) {
        if (this.entityObj.IconSrc) {
            Run this.entityObj.IconSrc
        }
    }

    OnClearIconSrc(btn, info) {
        if (this.entityObj.UnmergedConfig.Has("IconSrc")) {
            this.entityObj.UnmergedConfig.Delete("IconSrc")
            this.guiObj["IconSrc"].Text := this.entityObj.IconSrc
        }
    }
}
