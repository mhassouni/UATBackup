({
	/************************************** ON INIT  **************************************/

	doInit : function(component, event, helper) {
		helper.getOptions(component, event, helper);
		helper.getSelectedOptions(component, event, helper);
	},

	/************************************** ON SUBMIT  **************************************/

	handleSubmit : function(component, event, helper) {
		component.set("v.spinner", true);

		event.preventDefault(); 
        var fields = event.getParam("fields");
        component.find('assetOptionsForm').submit(fields);
	},

	handleOptionChange : function(component, event, helper) {
		var selectedOptions = event.getParam("value");
		component.set("v.selectedOptions_string", selectedOptions.join(";"));
	},

	/************************************** ON SUCCESS  **************************************/


	handleSuccess : function(component, event, helper) {
		component.set("v.spinner", false);
        helper.showToast('success', 'SUCCÈS !', 'Options enregistrées', component, event, helper);
    },

	/************************************** ON ERROR  **************************************/

	handleError : function(component, event, helper) {
		component.set("v.spinner", false);
        helper.showToast('error', 'ERREUR !', "Une erreur s'est produite lors de l'enregistrement des options.", component, event, helper);
    },
})