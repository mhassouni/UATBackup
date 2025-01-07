({
	/************************************** GET DATA **************************************/

	getOptions : function(component, event, helper) {
		var action = component.get("c.getOptionProducts");
        action.setCallback(this, function(a){
            var state = a.getState();
            if(state === "SUCCESS"){
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
            }
            else{
                var errors = a.getError();
                var message = 'Erreur inconnue';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                component.set("v.spinner", false);
                helper.showToast('error', 'ERREUR !', "Une erreur s'est produite lors de la récupération des options.", component, event, helper);
            }
        });
        $A.enqueueAction(action);
	},

	getSelectedOptions : function(component, event, helper) {
		var assetId = component.get("v.recordId");

		var action = component.get("c.getOptionInstallees");
		action.setParams({assetId:assetId});
        action.setCallback(this, function(a){
            var state = a.getState();
            if(state === "SUCCESS"){
                var response = a.getReturnValue();
				
				var values = [];
				if(response && response.Options__c){
					var options = response.Options__c.split(';');
					for(var index in options){
						values.push(options[index]);
					}
				}
				component.set("v.selectedOptions", values);
            }
            else{
                var errors = a.getError();
                var message = 'Erreur inconnue';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                component.set("v.spinner", false);
                helper.showToast('error', 'ERREUR !', "Une erreur s'est produite lors de la récupération des options installées.", component, event, helper);
            }
        });
        $A.enqueueAction(action);
	},

   
	/************************************** VERIFY DATA **************************************/



    /************************************** SUBMIT DATA **************************************/

    
    showToast : function(type, title, message, component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : type, 
            "title": title,
            "message": message
        });
        toastEvent.fire();
	}


})