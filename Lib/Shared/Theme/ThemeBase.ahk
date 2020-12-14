class ThemeBase {
    eventManagerObj := ""
    idGenerator := ""
    themeId := ""
    mouseMoveCallback := ""
    static Gdip := ""
    name := ""
    themesDir := ""
    parentTheme := ""
    defaultTheme := "Lightpad"
    vars := Map()
    colors := Map("background", "FFFFFF", "text", "000000", "textLight", "959595", "accent", "9466FC", "accentLight", "EEE6FF", "accentDark", "8A57F0", "transColor", "")
    themeAssets := Map("logo", "Resources\Graphics\Logo.png", "icon", "Resources\Graphics\Launchpad.ico")
    buttons := Map("height", Map("s", 20, "m", 30, "l", 40, "xl", 80), "fixedWidth", Map("s", 80, "m", 100, "l", 120, "xl", 140))
    labels := Map("height", "auto", "fixedWidth", 75, "font", "normal")
    fonts := Map("normal", "s10 w200", "small", "s11", "large", "s13")
    windowStyles := Map("Child", "E0x40000000L", "Popup", "E0x80000000L", "HScroll", "E0x00100000L", "Tiles", "E0x00000000L")
    windowSettings := Map("default", Map("base", "", "size", Map("width", "auto", "height", "auto"), "position", Map("x", "auto", "y", "auto", "w", "auto", "h", "auto"), "spacing", Map("margin", 10, "windowMargin", "{{margin}}", "buttonSpacing", "{{margin}}"), "saveSize", true, "savePosition", true, "contentWidth", 420, "tabHeight", 350, "listViewHeight", "{{tabHeight}}", "options", Map()), "dialog", Map("base", "default", "saveSize", false, "savePosition", false, "options", Map("Border", true, "Caption", true, "OwnDialogs", false, "Resize", false, "Popup", true)), "form", Map("base", "dialog", "options", Map("Tiled", true)))
    windows := Map()
    themedButtons := Map()
    buttonMap := Map()
    hoveredButton := ""

    __New(name, themesDir, eventManagerObj, idGenerator, autoLoad := false) {
        if (ThemeBase.Gdip == "") {
            ThemeBase.Gdip := Gdip_Startup()
        }

        this.name := name
        this.themesDir := themesDir
        this.eventManagerObj := eventManagerObj
        this.idGenerator := idGenerator
        this.mouseMoveCallback := ObjBindMethod(this, "OnMouseMove")

        this.themeId := idGenerator.Generate()
        
        if (autoLoad) {
            this.LoadTheme()
        }

        this.eventManagerObj.Register(Events.MOUSE_MOVE, "Theme" . this.themeId, this.mouseMoveCallback)
    }

    __Delete() {
        this.eventManagerObj.Unregister(Events.MOUSE_MOVE, "Theme" . this.themeId)
        super.__Delete()
    }

    OnMouseMove(wParam, lParam, msg, hwnd) {
        if (hwnd != this.hoveredButton) {
            for btnHwnd, btn in this.themedButtons {
                if (btnHwnd == hwnd) {
                    this.SetHoveredButton(btn["picture"])
                    return
                }
            }

            ; No button is hovered, reset hovered button
            if (this.hoveredButton != "") {
                this.SetNormalButtonState(this.themedButtons[this.hoveredButton]["picture"])
                this.hoveredButton := ""
            }
        }
    }

    InitializeTheme() {
        iconSrc := this.GetThemeAsset("icon")

        if (iconSrc != "" and FileExist(iconSrc)) {
            TraySetIcon(iconSrc)
        }
    }

    GetColor(id) {
        return this.colors.Has(id) ? this.colors[id] : "000000"
    }

    GetThemeAsset(id) {
        return (this.themeAssets.Has(id)) ? this.themeAssets[id] : ""
    }

    GetButtonSize(id, fixedWidth := false) {
        buttonSize := Map("h", "auto", "w", "auto")

        if (this.buttons["height"].Has(id)) {
            buttonSize["h"] := this.buttons["height"][id]
        }

        if (fixedWidth and this.buttons["fixedWidth"].Has(id)) {
            buttonSize["w"] := this.buttons["fixedWidth"][id]
        }

        return buttonSize
    }

    GetFont(id) {
        return (this.fonts.Has(id)) ? this.fonts[id] : this.fonts["normal"]
    }

    GetWindowSettings(windowKey) {
        windowConfig := (this.windows.Has(windowKey)) ? this.windows[windowKey] : Map("settings", "default")

        if (windowConfig.Has("settings") and windowConfig["settings"] != "") {
            windowConfig := this.MergeProperty(windowConfig, this.LoadWindowSettings(windowKey))
        }

        return windowConfig
    }

    LoadWindowSettings(settingsKey) {
        windowSettings := ""

        if (this.windowSettings.Has(settingsKey)) {
            windowSettings := this.windowSettings[settingsKey]
        } else {
            windowSettings := this.windowSettings["default"]
        }

        if (windowSettings.Has("base") and windowSettings["base"] != "") {
            parentSettings := this.GetWindowSettings(windowSettings["base"])
            windowSettings := this.MergeProperty(windowSettings, parentSettings, false)
        }

        return this.DereferenceEnumerable(windowSettings)
    }

    GetWindowOptionsString(windowKey) {
        windowOptions := ""
        windowSettings := this.GetWindowSettings(windowKey)

        if (windowSettings.Has("options") and windowSettings["options"] != "") {
            for key, val in windowSettings["options"] {
                if (val != "") {
                    if this.windowStyles.Has(key) {
                        key := this.DereferenceValue(this.windowStyles[key], this.windowStyles)
                    }

                    if (windowOptions != "") {
                        windowOptions .= " "
                    }

                    if (val) {
                        windowOptions .= "+" . key
                    } else if (val == false) {
                        windowOptions .= "-" . key
                    }

                    if (Type(val) == "String" and val != "") {
                        windowOptions .= val
                    }
                }
            }
        }

        return windowOptions
    }

    DereferenceValues(themeMap := "") {
        if (themeMap == "") {
            this.name := this.DereferenceValue(this.name, this.vars)
            this.vars := this.DereferenceEnumerable(this.vars)
            this.colors := this.DereferenceEnumerable(this.colors)
            this.themeAssets := this.DereferenceEnumerable(this.themeAssets)
            this.buttons := this.DereferenceEnumerable(this.buttons)
            this.labels := this.DereferenceEnumerable(this.labels)
            this.fonts := this.DereferenceEnumerable(this.fonts)
            this.windowStyles := this.DereferenceEnumerable(this.windowStyles)
            this.windowSettings := this.DereferenceEnumerable(this.windowSettings)
            this.windows := this.DereferenceEnumerable(this.windows)
        } else {
            return this.DereferenceEnumerable(themeMap)
        }
    }

    DereferenceEnumerable(enum) {
        for key, val in enum {
            if (Type(val) == "Map" || Type(val) == "Array") {
                enum[key] := this.DereferenceEnumerable(val)
            } else {
                enum[key] := this.DereferenceValue(val, enum)
            }
        }

        return enum
    }

    DereferenceValue(value, valueMap, endRecursion := false) {
        for (key, val in valueMap) {
            if (value == "{{" . key . "}}") {
                value := StrReplace(value, "{{" . key . "}}", this.DereferenceValue(val, valueMap))
            }
        }

        return endRecursion ? value : this.DereferenceValue(value, this.vars, true)
    }

    ExpandPaths(themeMap := "") {
        if (themeMap == "" or themeMap.Has("themeAssets")) {
            themeAssets := themeMap != "" ? themeMap["themeAssets"] : this.themeAssets
        }

        themeAssets := themeMap == "" ? this.themeAssets : themeMap["themeAssets"]

        themeName := themeMap != "" ? themeMap["name"] : this.name
        parentTheme := themeMap != "" ? themeMap["parentTheme"] : this.parentTheme
        
        for key, val in themeAssets {
            themeAssets[key] := this.ExpandPath(val, themeName, parentTheme)
        }

        return themeMap
    }

    ExpandPath(value, themeName := "", parentTheme := "") {
        if (value != "") {
            SplitPath(value,,,,, driveLetter)

            if (driveLetter == "") {
                themePath := this.themesDir . "\" . this.name . "\" . value
                parentThemePath := parentTheme ? this.themesDir . "\" . parentTheme . "\" . value : ""
                defaultThemePath := this.themesDir . "\" . this.defaultTheme . "\" . value

                if (FileExist(themePath)) {
                    value := themePath
                } else if (FileExist(parentThemePath)) {
                    value := parentThemePath
                } else if (FileExist(defaultThemePath)) {
                    value := defaultThemePath
                }
            }
        }

        return value
    }

    LoadValuesIntoTheme(themeMap) {
        InvalidParameterException.CheckTypes("ThemeBase", "themeMap", themeMap, "Map")

        if (themeMap.Has("parentTheme") and themeMap["parentTheme"] != "") {
            parentMap := this.GetThemeMap(themeMap["parentTheme"])

            if (Type(parentMap) == "Map") {
                this.LoadValuesIntoTheme(parentMap)
            }
        }

        themeMap := this.DereferenceValues(themeMap)
        themeMap := this.ExpandPaths(themeMap)

        for key, val in themeMap {
            if (key == "name" or key == "parentTheme" or key == "themesDir") {
                continue
            }

            if (this.HasProp(key)) {
                this.%key% := this.MergeProperty(this.%key%, val, true)
            }
        }
    }

    MergeProperty(existingValue, newValue, overwriteMapKeys := false) {
        if (Type(existingValue) == "Map" and Type(newValue) == "Map") {
            newValue := this.MergeMap(existingValue, newValue, overwriteMapKeys)
        } else if (Type(existingValue) == "Array" and Type(newValue) == "Array") {
            newValue := this.MergeArray(existingValue, newValue, overwriteMapKeys)
        }

        return newValue
    }

    MergeMap(existingMap, newMap, overwriteKeys := false) {
        for key, val in newMap {
            if (overwriteKeys or !existingMap.Has(key)) {
                existingMap[key] := existingMap.Has(key) ? this.MergeProperty(existingMap[key], val, overwriteKeys) : val
            }
        }

        return existingMap
    }

    MergeArray(existingArray, newArray, overwriteMapKeys := false) {
        for index, val in newArray {
            valueExists := false
            existingType := ""

            for existingIndex, existingVal in existingArray {
                if (existingVal == val) {
                    valueExists := existingIndex
                    existingType := Type(existingVal)
                    break
                }
            }

            if (valueExists) {
                existingArray[valueExists] := this.MergeProperty(existingArray[valueExists], val, overwriteMapKeys)
            } else {
                existingArray.Push(val)
            }
        }

        return existingArray
    }

    LoadTheme(themeName := "") {
        if (themeName == "") {
            themeName := this.name
        }

        themeMap := this.GetThemeMap(themeName)

        if (Type(themeMap) != "Map") {
            InvalidParameterException.new("The provided theme name cannot be resolved to a valid theme.")
        }

        this.name := themeMap.Has("name") ? themeMap["name"] : themeName
        this.parentTheme := themeMap.Has("parentTheme") ? themeMap["parentTheme"] : ""
        this.LoadValuesIntoTheme(themeMap)
        this.DereferenceValues()
        this.ExpandPaths()
        this.InitializeTheme()
        return this
    }

    GetThemeMap(themeName) {
        throw MethodNotImplementedException.new("ThemeBase", "GetThemeMap")
    }

    AddButton(guiObj, options, text, handlerName := "") {
        picObj := ""

        try {
            picObj := guiObj.AddPicture(options . " 0xE")
            shape := ButtonShape.new(text, this.GetColor("buttonBackground"), this.GetColor("buttonText"), this.GetColor("border"), this.buttons["borderWidth"])
            shape.DrawOn(picObj)

            if (handlerName or picObj.Name) {
                if (handlerName == "") {
                    handlerName := "On" . picObj.Name
                }

                picObj.OnEvent("Click", handlerName)
            }

            this.themedButtons[picObj.Hwnd] := Map("picture", picObj, "text", text)
        } catch ex {
            ; Ignore errors
        }

        return picObj
    }

    DrawButtonOverlay(ctlObj, guiObj) {
        try {
            shape := ButtonShape.new(ctlObj.Text, this.GetColor("buttonBackground"), this.GetColor("buttonText"), this.GetColor("border"), this.buttons["borderWidth"])
            picObj := shape.DrawOver(ctlObj, guiObj)
            this.buttonMap[ctlObj.Hwnd] := picObj
            this.themedButtons[picObj.Hwnd] := Map("button", ctlObj, "picture", picObj, "text", ctlObj.Text)
        } catch ex {
            ; Ignore errors
        }
    }

    SetNormalButtonState(btn) {
        try {
            shape := ButtonShape.new(this.themedButtons[this.hoveredButton]["text"], this.GetColor("buttonBackground"), this.GetColor("buttonText"), this.GetColor("border"), this.buttons["borderWidth"])
            btn := shape.DrawOn(btn)
        } catch ex {
            ; Ignore errors
        }
        
        return btn
    }

    SetHoveredButton(btn) {
        if (this.hoveredButton == btn.Hwnd) {
            return
        }

        if (this.hoveredButton != "") {
            this.SetNormalButtonState(this.themedButtons[this.hoveredButton]["picture"])
            this.hoveredButton := ""
        }

        shape := ButtonShape.new(this.themedButtons[btn.Hwnd]["text"], this.GetColor("buttonBackgroundHover"), this.GetColor("buttonTextHover"), this.GetColor("borderHover"), this.buttons["borderWidth"])
        btn := shape.DrawOn(btn)
        this.hoveredButton := btn.Hwnd
        return btn
    }
}
