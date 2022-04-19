class EntityFormEntityFieldWidget extends EntityFieldWidgetBase {
    GetDefaultDefinition(definition) {
        defaults := super.GetDefaultDefinition(definition)
        defaults["controlClass"] := ""
        defaults["referenceFormMode"] := "child"
        return defaults
    }

    RenderWidget(guiControlParams) {
        fieldObj := this.GetEntityField()
        entityTypeId := fieldObj.Definition["entityType"]

        if (entityTypeId) {
            factory := this.container.Get("entity_form_factory." . entityTypeId)
            entityObj := fieldObj.GetValue()
            entityForm := factory.CreateEntityForm(entityObj, this.guiObj, this.Definition["referenceFormMode"])
            entityForm.RenderEntityForm(guiControlParams)
        }
    }
}
