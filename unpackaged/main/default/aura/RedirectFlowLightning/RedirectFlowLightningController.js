({
init : function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
navEvt.setParams({
  "recordId": component.get("v.recId"),
});
navEvt.fire(); 
}
})