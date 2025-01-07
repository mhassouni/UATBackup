({

    doInit : function(cmp,evt,helper) {
        var action = cmp.get("c.listWeeks");
        action.setParams({
            Id : cmp.get('v.agencePf')
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            var checkboxes = [];
            if(state === "SUCCESS") {
                var returnedVal = response.getReturnValue();
                console.log(returnedVal);

                for(var i = 0 ; i <  returnedVal.length ; i++){
                    checkboxes.push({'label' : returnedVal[i].Numero_semaine_dates__c,
                                     'value' : returnedVal[i].Id
                    });
                }
                
                cmp.set('v.weeks', checkboxes);


            } else if (state === "ERROR") {
                console.log("Error message: " + message);
            }
        });
        $A.enqueueAction(action);
    }

})