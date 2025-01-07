({
      doInit : function(component, event, helper) {
      var action = component.get("c.IsDisplayWarning");
		action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
            
            component.set("v.DisplayWarning", a.getReturnValue());
        });
        $A.enqueueAction(action); 
        },
    
        onShowInlineEdit: function (component, event, helper) {            
            const myInput = component.find("myInput");
            let value = myInput.get("v.value");
        myInput.set("v.value", value);
		},
})