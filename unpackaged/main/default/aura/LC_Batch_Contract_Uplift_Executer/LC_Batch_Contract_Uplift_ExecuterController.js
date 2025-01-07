({
    doInit : function(component, event, helper) {
		var action = component.get("c.executeBatch");
        action.setParams({
            
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Contract Uplift Batch",
                    "message": $A.get("$Label.c.Batch_Uplift_Message_Success"),
                    "type": "success"
                });
                toastEvent.fire();                
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Contract Uplift Batch",
                    "message": $A.get("$Label.c.Batch_Uplift_Message_Error"),
                    "type": "error"
                });
                toastEvent.fire();  
            }
            // Close the action panel
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        }); 
        
        $A.enqueueAction(action);                 
    }
})