class EntityTypeManager extends ComponentManagerBase {
    __New(container, eventMgr, notifierObj, definitionLoaders) {
        super.__New(container, "entity_type.", eventMgr, notifierObj, EntityTypeBase, definitionLoaders, true, false)
    }

    GetStorage(entityTypeId) {
        if (this.Has(entityTypeId)) {
            return this.container.Get("entity_storage." . entityTypeId)
        } else {
            throw EntityException("Entity type not found: " . entityTypeId)
        }
    }

    GetManager(entityTypeId) {
        if (this.Has(entityTypeId)) {
            return this.container.Get("entity_manager." . entityTypeId)
        } else {
            throw EntityException("Entity type not found: " . entityTypeId)
        }
    }

    GetFactory(entityTypeId) {
        if (this.Has(entityTypeId)) {
            return this.container.Get("factory." . entityTypeId)
        } else {
            throw EntityException("Entity type not found: " . entityTypeId)
        }
    }

    GetDefinitionLoader(entityTypeId) {
        if (this.Has(entityTypeId)) {
            return this.container.Get("definition_loader." . entityTypeId)
        } else {
            throw EntityException("Entity type not found: " . entityTypeId)
        }
    }
}
