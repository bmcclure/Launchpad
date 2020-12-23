class EntityBase {
    app := ""
    configPrefix := "Launcher"
    keyVal := ""
    dataSourcePath := ""
    configObj := ""
    entityData := ""
    requiredConfigKeysVal := []
    originalObj := ""
    children := Map()
    parentEntity := ""

    /**
    * BASE SETTINGS
    * 
    * These are the main pieces of data that is interacted with and that all of the other settings are pulled from.
    */

    ; The ID used to refer to the entity, typically the entity's name, but it should only contain characters valid in a filename.
    ; It will be used for the name of directories and most files related to the entity.
    ; 
    ; If this key matches the DataSourceKey, then a shortcut can be used such that 
    Key {
        get => this.keyVal
        set => this.keyVal := value
    }

    ; Configuration that has often been merged with defaults from external sources.
    ; This is the object that most of the other values in this class come from, but it can contain custom items too.
    Config {
        get => this.entityData.GetMergedData()
    }

    ; The unmodified original configuration from the entity.
    ; When editing the entity, this is where the raw updated configuration is stored before it's actually saved.
    UnmergedConfig {
        get => this.entityData.GetLayer("config")
        set => this.entityData.SetLayer("config", value)
    }
    
    ; The object that was originally passed in. This is left unmodified until modified values are actually "saved" at which point they will be copied back into this object.
    ConfigObject {
        get => this.configObj
        set => this.configObj := value
    }

    ; The data source keys to load defaults from, in order.
    ; The default datasource is "api" which connects to the default api endpoint (Which can be any HTTP location compatible with Launchpad's "LauncherDB" JSON format)
    DataSourceKeys {
        get => this.GetConfigValue("DataSourceKeys", false)
        set => this.SetConfigValue("DataSourceKeys", value, false)
    }

    ; The key that is used to look up the entity's data from configured external datasources.
    ; It defaults to the key which is usually sufficient, but it can be overridden by setting this value.
    ; Addtionally, multiple copies of the same datasource entity can exist by giving them different keys but using the same DataSourceKey
    DataSourceItemKey {
        get => this.GetConfigValue("DataSourceItemKey", false)
        set => this.SetConfigValue("DataSourceItemKey", value, false)
    }

    ; Gets tor sets the configuration keys that are required to have a valid value before this entity is considered valid.
    RequiredConfigKeys {
        get => this.requiredConfigKeysVal
        set => this.requiredConfigKeysVal := value
    }

    ; Wherever the entity's name is displayed, this value will be used.
    ; It defaults to the key if it is not set, which is usually sufficient.
    DisplayName {
        get => this.GetConfigValue("DisplayName", false)
        set => this.SetConfigValue("DisplayName", value, false)
    }

    ; The directory where any required assets for this entity will be saved.
    AssetsDir {
        get => this.GetConfigValue("AssetsDir", false)
        set => this.SetConfigValue("AssetsDir", value, false)
    }

    ; The directory where dependencies which have been installed for this entity can be accessed
    DependenciesDir {
        get => this.GetConfigValue("DependenciesDir", false)
        set => this.SetConfigValue("DependenciesDir", value, false)
    }

    __New(app, key, configObj, requiredConfigKeys := "", parentEntity := "") {
        InvalidParameterException.CheckTypes("EntityBase", "app", app, "Launchpad", "key", key, "String", "configObj", configObj, "Map")
    
        if (parentEntity != "") {
            InvalidParameterException.CheckTypes("EntityBase", "parentEntity", parentEntity, "EntityBase")
        }

        InvalidParameterException.CheckEmpty("EntityBase", "key", key)

        this.app := app
        this.keyVal := key
        this.configObj := configObj
        this.parentEntity := parentEntity

        this.entityData := LayeredEntityData.new(configObj.Clone(), this.InitializeDefaults())
        this.entityData.SetLayer("ds", this.AggregateDataSourceDefaults())
        this.entityData.SetLayer("auto", this.AutoDetectValues())
        this.entityData.StoreOriginal()
        
        this.InitializeRequiredConfigKeys(requiredConfigKeys)
    }

    UpdateDataSourceDefaults() {
        this.entityData.SetLayer("ds", this.AggregateDataSourceDefaults())
    }

    ; NOTICE: Object not yet fully loaded. Might not be safe to call this.entityData
    InitializeDefaults() {
        defaults := Map()
        defaults["DataSourceKeys"] := ["api"]
        defaults["DataSourceItemKey"] := this.keyVal
        defaults["DisplayName"] := this.keyVal
        defaults["AssetsDir"] := this.app.Config.AssetsDir . "\" . this.keyVal
        defaults["DependenciesDir"] := this.app.appDir . "\Vendor"
        return defaults
    }

    AggregateDataSourceDefaults() {
        dataSources := this.GetAllDataSources()
        defaults := this.parentEntity != "" ? this.parentEntity.AggregateDataSourceDefaults() : Map()

        for index, dataSource in dataSources {
            defaults := this.MergeFromObject(defaults, this.GetDataSourceDefaults(dataSource))
        }

        for key, child in this.children {
            child.AggregateDataSourceDefaults()
        }

        return defaults
    }

    GetAllDataSources() {
        dataSources := Map()

        if (this.DataSourceKeys != "") {
            dataSourceKeys := (Type(this.DataSourceKeys) == "Array") ? this.DataSourceKeys : [this.DataSourceKeys]

            for index, dataSourceKey in dataSourceKeys {
                dataSource := this.app.DataSources.GetItem(dataSourceKey)

                if (dataSource != "") {
                    dataSources[dataSourceKey] := dataSource
                }
            }
        }

        return dataSources
    }

    GetDataSourceDefaults(dataSource) {
        defaults := Map()
        dsData := dataSource.ReadJson(this.GetDataSourceItemKey(), this.GetDataSourceItemPath())

        if (dsData != "" and dsData.Has("Defaults")) {
            defaults := this.MergeFromObject(defaults, dsData["Defaults"], false)
            defaults := this.MergeAdditionalDataSourceDefaults(defaults, dsData)
        }

        return defaults
    }

    GetDataSourceItemKey() {
        return this.Key
    }

    GetDataSourceItemPath() {
        return this.dataSourcePath
    }

    MergeAdditionalDataSourceDefaults(defaults, dataSourceData) {
        return defaults
    }

    AutoDetectValues() {
        return Map()
    }

    InitializeRequiredConfigKeys(requiredConfigKeys := "") {
        if (requiredConfigKeys != "") {
            this.AddRequiredConfigKeys(requiredConfigKeys)
        }

        if (this.Config.Has("RequiredConfigKeys")) {
            this.AddRequiredConfigKeys(this.Config["RequiredConfigKeys"])
        }
    }

    AddRequiredConfigKeys(configKeys, addPrefix := false) {
        for index, requiredKey in configKeys {
            if (!this.ConfigKeyIsRequired(requiredKey)) {
                if (addPrefix) {
                    requiredKey := this.configPrefix . requiredKey
                }

                this.requiredConfigKeysVal.push(requiredKey)
            }
        }
    }

    ConfigKeyIsRequired(key, addPrefix := false) {
        isRequired := false

        if (addPrefix) {
            key := this.configPrefix . key
        }

        for index, requiredKey in this.requiredConfigKeysVal {
            if (key == requiredKey) {
                isRequired := true
                break
            }
        }

        return isRequired
    }

    MergeFromObject(mainObject, defaults, overwriteKeys := false) {
        for key, value in defaults {
            if (overwriteKeys or !mainObject.Has(key)) {
                if (value == "true" or value == "false") {
                    mainObject[key] := (value == "true")
                } else {
                    mainObject[key] := value
                }
            }
        }

        return mainObject
    }

    GetConfigValue(key, usePrefix := true, processValue := true) {
        if (usePrefix) {
            key := this.configPrefix . key
        }
        
        return this.entityData.GetValue(key, processValue)
    }

    SetConfigValue(key, value, usePrefix := true) {
        if (usePrefix) {
            key := this.configPrefix . key
        }

        this.entityData.SetValue(key, value, "config")
        return this
    }

    DeleteConfigValue(key, usePrefix := true) {
        if (usePrefix) {
            key := this.configPrefix . key
        }

        this.entityData.DeleteValue(key, "config")
        return this
    }

    /**
    * ENTITY ACTIONS
    */

    Validate() {
        validateResult := Map("success", true, "invalidKeys", Array())

        for index, requiredKey in this.RequiredConfigKeys {
            if (!this.entityData.HasValue(requiredKey, "", false)){
                validateResult["success"] := false
                validateResult["invalidKeys"].push(requiredKey)
            }
        }

        for key, child in this.children {
            childValidateResult := child.Validate()

            if (!childValidateResult["success"]) {
                validateResult["success"] := false

                for index, invalidKey in childValidateResult["invalidKeys"] {
                    validateResult["invalidKeys"].Push(invalidKey)
                }
            }
        }

        return validateResult
    }

    Edit(mode := "config", owner := "MainWindow") {
        this.entityData.StoreOriginal()
        result := this.LaunchEditWindow(mode, owner)

        if (result == "Cancel" || result == "Skip") {
            this.entityData.RestoreFromOriginal()
            return ""
        }

        diff := this.entityData.DiffChanges("config")

        if (mode == "config" and diff.HasChanges()) {
            this.SaveModifiedData()
        }

        return diff
    }

    LaunchEditWindow(mode, owner) {
        return "Cancel"
    }

    SaveModifiedData() {
        diff := this.entityData.DiffChanges("config")

        if (diff != "" and diff.HasChanges()) {
            for key, val in diff.GetAdded() {
                this.configObj[key] := val
            }

            for key, val in diff.GetModified() {
                this.configObj[key] := val
            }

            for key, val in diff.GetDeleted() {
                if (this.configObj.Has(key)) {
                    this.configObj.Delete(key)
                }
            }
        }

        for key, child in this.children {
            child.SaveModifiedData()
        }
    }

    RevertToDefault(field) {
        this.entityData.DeleteValue(field, "config")
    }

    GetAssetPath(filePath) {
        return this.AssetsDir . "\" . filePath
    }

    DereferenceKey(key, map) {
        if (map.Has(key) && Type(map[key]) == "String") {
            key := this.DereferenceKey(map[key], map)
        }

        return key
    }
}
