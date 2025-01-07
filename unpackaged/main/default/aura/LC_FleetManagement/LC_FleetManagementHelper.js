({
    /************************************** SETTINGS **************************************/
    
    setWorkspace: function (component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Fleet Management"
            });
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "standard:search",
                iconAlt: "Fleet Management"
            });
        });
    },
    
    /************************************** GET DATA **************************************/
    
    //Order getOrder(Id orderId)
    
    /**************** ORDERS ****************/
    
    getOrderDetails: function (component, event, helper) {
        var orderId = component.get("v.refRecordId");
        var action = component.get("c.getOrder");
        action.setParams({ orderId: orderId });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var response = a.getReturnValue();
                component.set("v.order", response);
                if (response) {
                    //RESERVATION
                    var reservation = component.get("v.reservation_filter");
                    
                    const newStartDate =
                        response.StartDate__c &&
                        helper.changeDate(response.StartDate__c, 10, "SUBSTRACT");
                    const newEndDate =
                        response.EndDate__c && helper.changeDate(response.EndDate__c, 10, "ADD");
                    
                    if (!reservation) reservation = {};
                    reservation["Date_de_debut__c"] = newStartDate || null;
                    reservation["Date_de_fin__c"] = newEndDate || null;
                    reservation["Commande__c"] = response.Id;
                    reservation["Client__c"] = response.AccountId;
                    if(response.Type_de_location__c){
                        var codeTypeLocation;
                        switch (response.Type_de_location__c) {
                            case 'Courte Durée':
                                codeTypeLocation = 'CD';
                                break;
                            case 'Moyenne Durée':
                                codeTypeLocation = 'CDM';
                                break;
                            case 'Longue Durée':
                                codeTypeLocation = 'LD';
                                break;
                            default:
                                codeTypeLocation = response.Type_de_location__c;
                        }
                        reservation["Type_de_location__c"] = codeTypeLocation;
                    }
                    
                    component.set("v.reservation_filter", reservation);
                    component.set("v.initReservationInputField", true);
                    
                    //CONTENEUR
                    var container = component.get("v.container_filter");
                    
                    if (!container) container = {};
                    container["Date_de_debut_asset__c"] = newStartDate || null;
                    container["Date_de_fin_asset__c"] = newEndDate || null;
                    container["Status_de_location__c"] = "Disponible;";
                    component.set("v.container_filter", container);
                }
                
                //helper.getReservationRecordTypes(component, event, helper);
                helper.getSearchFields_Reservation(component, event, helper);
                helper.getSearchFields_Container(component, event, helper);
            } else {
                var errors = a.getError();
                var message = "Erreur inconnue";
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                helper.showToast(
                    "error",
                    "ERREUR !",
                    message,
                    component,
                    event,
                    helper
                );
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    changeDate: function (date, days, operation) {
        let newDate = new Date(date);
        if (operation === "ADD") {
            newDate = new Date(newDate.setDate(newDate.getDate() + days));
        } else if (operation === "SUBSTRACT") {
            newDate = new Date(newDate.setDate(newDate.getDate() - days));
        }
        return newDate.toISOString().split("T")[0];
    },
    
    /**************** RESERVATIONS ****************/
    
    getReservationRecordTypes: function (component, event, helper) {
        var action = component.get("c.getRecordTypes");
        action.setParams({ objectName: "Reservation__c" });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var response = a.getReturnValue();
                
                var recordTypes = [];
                recordTypes.push({ value: "--Aucun--", key: null });
                for (var key in response) {
                    recordTypes.push({ value: response[key], key: key });
                }
                component.set("v.reservation_recordTypesById", recordTypes);
            } else {
                var errors = a.getError();
                var message = "Erreur inconnue";
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                helper.showToast(
                    "error",
                    "ERREUR !",
                    message,
                    component,
                    event,
                    helper
                );
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getSearchFields_Reservation: function (component, event, helper) {
        var action = component.get("c.getFieldSet");
        action.setParams({
            objectName: "Reservation__c",
            fieldSetName: "Fleet_Management_Search_Fields"
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var response = a.getReturnValue();
                // Setting the value of Type_de_location__c field of the passed in refRecordId (Order Id)  as the default value
                const reservationFilter = component.get("v.reservation_filter");
                if(reservationFilter.Type_de_location__c){
                    response.forEach(searchField => {
                        if(searchField.apiName === 'Type_de_location__c'){
                            searchField.options.forEach(option => {
                                if(option.value === reservationFilter.Type_de_location__c ){
                                    option.isDefault = true;
                                }
                            })
                        }
                    })
                }
                // /Setting the value of Type_de_location__c field of the passed in refRecordId (Order Id)  as the default value

                /*if(component.get("v.reservation_filter")["Type_de_location__c"]){
                    for(var index in response){
                        if(response[index].apiName == 'Type_de_location__c'){
                            response[index].value = component.get("v.reservation_filter")["Type_de_location__c"];
                            break;
                        }
                    }
                }*/
                component.set("v.searchFields_reservation", response);
                
                helper.getResultFields_Reservation(component, event, helper);
            } else {
                var errors = a.getError();
                var message = "Erreur inconnue";
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                helper.showToast(
                    "error",
                    "ERREUR !",
                    message,
                    component,
                    event,
                    helper
                );
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getResultFields_Reservation: function (component, event, helper) {
        var action = component.get("c.getFieldSet");
        action.setParams({
            objectName: "Reservation__c",
            fieldSetName: "Fleet_Management_Result_Fields"
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var response = a.getReturnValue();
                component.set("v.resultFields_reservation", response);
                helper.getReservations(component, event, helper);
            } else {
                var errors = a.getError();
                var message = "Erreur inconnue";
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                helper.showToast(
                    "error",
                    "ERREUR !",
                    message,
                    component,
                    event,
                    helper
                );
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getReservations: function (component, event, helper) {
        var searchFields = component.get("v.searchFields_reservation");
        var resultFields = component.get("v.resultFields_reservation");
        var order = component.get("v.order");
        var orderId = null;
        if (order) orderId = order.Id;
        var reservation_filter = component.get("v.reservation_filter");
        if (!reservation_filter.RecordTypeId)
            reservation_filter.RecordTypeId = null;
        
        //Update Reservation-RecordEditForm values
        if (component.get("v.initReservationInputField")) {
            var reservation_inputField = component.find("reservation_inputField");
            var filter;
            for (var indexField in searchFields) {
                if (
                    searchFields[indexField].apiName != "Date_debut__c" &&
                    searchFields[indexField].apiName != "Date_fin__c"
                ) {
                    filter = reservation_inputField.filter(
                        (x) => x.get("v.fieldName") === searchFields[indexField].apiName
                    )[0];
                    if (filter)
                        filter.set(
                            "v.value",
                            reservation_filter[searchFields[indexField].apiName]
                        );
                }
            }
        }
        
        //Search Reservations with criteria
        var action = component.get("c.getReservations");
        action.setParams({
            searchFields: searchFields,
            resultFields: resultFields,
            orderId: orderId,
            filter: reservation_filter
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var response = a.getReturnValue();
                component.set("v.reservations", response);
                
                //Build reservations_valuesByField
                //Key ==> ReservationID; Value ==> (List : Key ==> Field; Value ==> Reservation.field.apiName)
                var reservationsById = [];
                var values;
                for (var reservationIndex in response) {
                    values = [];
                    for (var fieldIndex in resultFields) {
                        values.push({
                            field: resultFields[fieldIndex],
                            value:
                            response[reservationIndex][resultFields[fieldIndex].apiName]
                        });
                    }
                    reservationsById.push({
                        id: response[reservationIndex].Id,
                        record: values
                    });
                }
                component.set("v.reservations_valuesMap", reservationsById);
                
                component.set("v.spinner", false);
            } else {
                var errors = a.getError();
                var message = "Erreur inconnue";
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                helper.showToast(
                    "error",
                    "ERREUR !",
                    message,
                    component,
                    event,
                    helper
                );
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    /**************** CONTAINERS ****************/
    
    getOptions: function (component, event, helper) {
        var action = component.get("c.getOptionProducts");
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var response = a.getReturnValue();
                
                var items = [];
                var itemValues = [];
                for(var index in response) {
                    if(!itemValues.includes(response[index].Name.toLowerCase())){
                        var item = {
                            "label": response[index].Name,
                            "value": response[index].Name
                        };
                        items.push(item);
                        itemValues.push(response[index].Name.toLowerCase());
                    }
                }
                component.set("v.options", items);
            } else {
                var errors = a.getError();
                var message = "Erreur inconnue";
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                helper.showToast(
                    "error",
                    "ERREUR !",
                    message,
                    component,
                    event,
                    helper
                );
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getSearchFields_Container: function (component, event, helper) {
        helper.getOptions(component, event, helper);
        
        var action = component.get("c.getFieldSet");
        action.setParams({
            objectName: "Asset",
            fieldSetName: "Fleet_Management_Search_Fields"
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var response = a.getReturnValue();
                component.set("v.searchFields_container", response);
                
                // *********** Setting "Status de location" to "Disponible" when refRecordId exists **********
                if (component.get("v.refRecordId")) {
                    const reservationStatusMultiPickListElement =
                        component.find("reservation_status");
                    let options = [
                        ...reservationStatusMultiPickListElement.get("v.options")
                    ];
                    options.forEach(
                        (option) =>
                        option.label === "Disponible" && (option.isChecked = true)
                    );
                    reservationStatusMultiPickListElement.set("v.options", options);
                    response.forEach(
                        (object) =>
                        object.apiName === "Status_de_location__c" &&
                        (object.value = "Disponible;")
                    );
                    component.set("v.searchFields_container", response);
                    reservationStatusMultiPickListElement.set(
                        "v.selectedOptions_values",
                        "Disponible;"
                    );
                    component.set("v.disponibleDefault", "Disponible");
                }
                // *********** Setting "Status de location" to "Disponible" when refRecordId exists **********
                
                helper.getResultFields_Container(component, event, helper);
            } else {
                var errors = a.getError();
                var message = "Erreur inconnue";
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                helper.showToast(
                    "error",
                    "ERREUR !",
                    message,
                    component,
                    event,
                    helper
                );
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getResultFields_Container: function (component, event, helper) {
        var action = component.get("c.getFieldSet");
        action.setParams({
            objectName: "Asset",
            fieldSetName: "Fleet_Management_Result_Fields"
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var response = a.getReturnValue();
                component.set("v.resultFields_container", response);
                
                helper.getContainers(component, event, helper);
            } else {
                var errors = a.getError();
                var message = "Erreur inconnue";
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                helper.showToast(
                    "error",
                    "ERREUR !",
                    message,
                    component,
                    event,
                    helper
                );
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getContainers: function (component, event, helper) {
        var searchFields = component.get("v.searchFields_container");
        var resultFields = component.get("v.resultFields_container");
        var orderId = component.get("v.refRecordId");
        var container_filter = component.get("v.container_filter");
        
        var action = component.get("c.getAssets");
        action.setParams({
            searchFields: searchFields,
            resultFields: resultFields,
            orderId: orderId,
            filter: container_filter
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var response = a.getReturnValue();
                component.set("v.containers", response);
                
                //Build containers_valuesByField
                //Key ==> ContainerID; Value ==> (List : Key ==> Field; Value ==> Container.field.apiName)
                var containersById = [];
                var values;
                for (var containerIndex in response) {
                    values = [];
                    for (var fieldIndex in resultFields) {
                        if (resultFields[fieldIndex].apiName == "Options__c" &&
                            response[containerIndex][resultFields[fieldIndex].apiName]
                        ) {
                            values.push({
                                field: resultFields[fieldIndex],
                                value: response[containerIndex][
                                    resultFields[fieldIndex].apiName
                                ].replaceAll(";", " - ")
                            });
                        } else {
                            values.push({
                                field: resultFields[fieldIndex],
                                value:
                                response[containerIndex][resultFields[fieldIndex].apiName]
                            });
                        }
                    }
                    
					var equipements = '';
                    if(response[containerIndex]["ChildAssets"] != null){
                        for(var childAssetIndex in response[containerIndex]["ChildAssets"]){
                            equipements += response[containerIndex]["ChildAssets"][childAssetIndex].Name + ' - ';
                        }
                        equipements = equipements.substring(0, equipements.length-3);
                    }
                    values.push({
                        field: 'Equipement',
                        value: equipements
                    });
                    
                    containersById.push({
                        id: response[containerIndex].Id,
                        record: values
                    });
                }
                component.set("v.containers_valuesMap", containersById);
                
                component.set("v.spinner", false);
            } else {
                var errors = a.getError();
                var message = "Erreur inconnue";
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                helper.showToast(
                    "error",
                    "ERREUR !",
                    message,
                    component,
                    event,
                    helper
                );
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    /************************************** VERIFY DATA **************************************/
    
    /************************************** SUBMIT DATA **************************************/
    
    showToast: function (type, title, message, component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: type,
            title: title,
            message: message
        });
        toastEvent.fire();
    }
});