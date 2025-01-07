({
	doInit : function(component, event, helper){
        if(component.get("v.takeDefault")){
            helper.setDefaultValue(component, event, helper);
        }
    },
    openDropdown : function(component, event, helper){
        $A.util.addClass(component.find('dropdown'), 'slds-is-open');
        $A.util.removeClass(component.find('dropdown'), 'slds-is-close');
    },
    closeDropDown : function(component, event, helper){
        $A.util.addClass(component.find('dropdown'), 'slds-is-close');
        $A.util.removeClass(component.find('dropdown'), 'slds-is-open');
    },
	
    selectOption : function(component, event, helper){   
        try{  
            var label = event.currentTarget.id.split("#BP#")[0];
            var isCheck = event.currentTarget.id.split("#BP#")[1];
            
            helper.selectOption(component, label, isCheck);
        }
        catch(error){
            console.error(error);
        }
    },

    resetOptions : function(component, event, helper){ 
        var selectedOptions_values = component.get("v.selectedOptions_values");
        if(!selectedOptions_values){
            var options = component.get("v.options");
            
            var selectedOptions_labels = "";
            var count = 0;

            for(var i = 0; i < options.length; i++){ 
                options[i].isChecked = false;
            } 

            component.set("v.selectedOptions_labels", selectedOptions_labels);
            component.set("v.options", options); 
        }
    }


})