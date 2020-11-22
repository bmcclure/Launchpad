class SingleInputBox extends DialogBox {
    defaultValue := ""
    isPassword := false

    __New(app, title, text, defaultValue := "", owner := "", isPassword := false) {
        this.defaultValue := defaultValue
        this.isPassword := isPassword
        super.__New(app, title, text, owner, "*&OK|&Cancel")
    }

    Controls() {
        super.Controls()
        this.guiObj.AddEdit("xm w" . this.contentWidth . " -VScroll vDialogEdit" . (this.isPassword ? " Password" : ""), this.defaultValue)
    }

    ProcessResult(result) {
        value := this.guiObj["DialogEdit"].Value
        result := (result == "OK") ? value : ""
        return super.ProcessResult(result)
    }
}
