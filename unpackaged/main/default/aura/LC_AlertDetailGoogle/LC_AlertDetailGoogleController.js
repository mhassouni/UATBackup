({
    RefreshBatterie : function(cmp, evt, helper) {

            var spinner = cmp.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");

            var action = cmp.get("c.RefreshLowBattery");
            action.setParams({ precord : cmp.get("v.recordId") });
            console.log('refr2');
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var a = cmp.get('c.RefreshDate');
                    $A.enqueueAction(a);
                    $A.util.toggleClass(spinner, "slds-hide");
                    $A.get('e.force:refreshView').fire();
                   //alert('Données mises à jour avec succès');
                }
                else if (state === "INCOMPLETE") {
                    // do something
                   // alert('INCOMPLETE');
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            
                            console.log("Error message: " + 
                                     errors[0].message);
                                     var a = cmp.get('c.RefreshDate');
                                     $A.enqueueAction(a);
                                     $A.util.toggleClass(spinner, "slds-hide");
                                     alert(errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                        $A.enqueueAction(a);
                        $A.util.toggleClass(spinner, "slds-hide");
                        alert('Erreur inconnue');
                    }
                }
            });
            $A.enqueueAction(action);




    },
    RefreshDate: function(cmp, evt, helper) {
        var today = new Date();
        var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
        var time = (today.getHours() ) + ":" + today.getMinutes() + ":" + today.getSeconds();
        var dateTime = date+' '+time;
        console.log(dateTime);
        cmp.set("v.startDatetime", dateTime);
        

    }
    
})