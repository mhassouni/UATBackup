({
      doInit : function(component, event, helper) {
      var action = component.get("c.IsDisplayWarning");
		action.setParams({
            "AssetId": component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
            
            component.set("v.DisplayWarning", a.getReturnValue());
            console.log(a.getReturnValue());
        });
          
        var action2 = component.get("c.setDisplayWarningMessage");
		action2.setParams({
            "AssetId": component.get("v.recordId")
        });

        action2.setCallback(this, function(a) {
            
            component.set("v.WarningMessage", a.getReturnValue());
        });
        
        var action3 = component.get("c.IsLastKmCompteurOK");
		action3.setParams({
            "AssetId": component.get("v.recordId")
        });

        action3.setCallback(this, function(a) {
            
            component.set("v.LastKmCompteurOK", a.getReturnValue());
        });
    	
          
        $A.enqueueAction(action); 
        $A.enqueueAction(action2);
        $A.enqueueAction(action3);
      },
    refresh:function(component, event,helper)
    {
                var action=component.get("c.TransmitKmToIgloo");
        console.log(component.find("KmConstate").get("v.value"));
        action.setParams({
            "AssetId" :component.get("v.recordId"),
            "KmConstate":component.find("KmConstate").get("v.value")
        });
        action.setCallback(this, function(response) {
            
        	var state = response.getState();
        	if(state == "SUCCESS") {
                window.setTimeout(function(){
                var sobjectEvent = $A.get("e.force:navigateToSObject");
                sobjectEvent.setParams({
                    "recordId": component.get("v.recordId")
                });
                sobjectEvent.fire();
                $A.get('e.force:refreshView').fire();
                component.set("v.WarningMessage",response.getReturnValue());
                component.set("v.DisplayWarning",response.getReturnValue()!="");
                component.find("KmConstate").set("v.value","0");
                },3000);
                
            }
            
        });
        $A.enqueueAction(action); 
        var action3 = component.get("c.IsLastKmCompteurOK");
		action3.setParams({
            "AssetId": component.get("v.recordId")
        });

        action3.setCallback(this, function(a) {
            
            component.set("v.LastKmCompteurOK", a.getReturnValue());
        }); 
        $A.enqueueAction(action3); 

    }
})