({
invoke : function(component, event, helper) {
var redirectToNewRecord = $A.get( "e.force:navigateToSObject" );

redirectToNewRecord.setParams({
"recordId": component.get( "v.leadId" ),
"slideDevName": "detail"
});
redirectToNewRecord.fire();
}
})