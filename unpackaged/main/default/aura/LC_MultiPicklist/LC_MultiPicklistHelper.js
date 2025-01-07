({
	setDefaultValue : function(component, event, helper){
        var options = component.get("v.options");
        
        var selectedOptions_values = "";
        var selectedOptions_labels = "";
        for(var index in options){
            if(options[index].isDefault){
                options[index].isChecked = true;
                selectedOptions_values = options[index].value;
                selectedOptions_labels = options[index].label;
                break;
            }
        }
        component.set("v.selectedOptions_values", selectedOptions_values);
        component.set("v.selectedOptions_labels", selectedOptions_labels);
    },

    selectOption : function(component, label, isCheck) {
        var options = component.get("v.options");
        
        var selectedOptions_values = "";
        var selectedOptions_labels = "";
        var count = 0;

        for(var i = 0; i < options.length; i++){ 
            if(options[i].label == label){ 
                if(isCheck == 'true'){ 
                    options[i].isChecked = false; 
                }
                else{ 
                    options[i].isChecked = true;
                } 
            } 
            if(options[i].isChecked){ 
                selectedOptions_values += options[i].value + ';';
                selectedOptions_labels += options[i].label;
                count++;
            } 
        } 

        if(count > 1){
            selectedOptions_labels  = count + ' valeurs sélectionnées';
        }

        component.set("v.selectedOptions_values", selectedOptions_values);
        component.set("v.selectedOptions_labels", selectedOptions_labels);
        component.set("v.options", options);
    }
})