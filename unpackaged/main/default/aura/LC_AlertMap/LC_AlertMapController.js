({
    /*init: function (cmp, event, helper) {
        cmp.set('v.mapMarkers', [
            {
                
                location: {
                Latitude: '37.790197',
                Longitude: '-122.396879'
                }
             
            }
        ]);
    },*/

    initLocation: function (cmp, event, helper) {
        var path = $A.get("$Label.c.FlowVar_Marker");
        //var lastPosition = $A.get("$Label.c.FlowVar_LastPosition");
        var lastPosition = $A.get("$Label.c.FlowVar_LastPosition");
        var lastPosition2 = $A.get('$Resource.LastPositionMin');
        console.log("lastPosition : " + lastPosition);
        console.log("lastPosition2 : " + lastPosition2);
        console.log('initLocation  -> recordid : '+cmp.get("v.recordId") );
       var rec =cmp.get("v.recordId");
       console.log("rec "+rec);
        cmp.set('v.zoomLevel', 7);
        //cmp.set('v.listView', 'visible');
        var action = cmp.get("c.CurrentLocation");
        action.setParams({ precord : rec});
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state :'+ state);

            if (state === "SUCCESS") {
                
               var res = JSON.parse(response.getReturnValue());

               console.log(res.Latitude);
               console.log(res.Longitude);
               console.log(res.LastLatitude);
               console.log(res.LastLongitude);

                cmp.set('v.center', 
                    {
                        location: {
                        	Latitude: res.Latitude,
                        	Longitude: res.Longitude,                                                                       
                        }                     
                    });
                
                cmp.set('v.mapMarkers', [
                    {
                        location: {
                        	Latitude: res.Latitude,
                        	Longitude: res.Longitude,
                        	icon : path                                                  
                        }                     
                    },
                    {
                        location: {
                        	Latitude: res.LastLatitude,
                        	Longitude: res.LastLongitude,
                        	icon : lastPosition 
                            //'https://greenforce--infra--c.visualforce.com/resource/1649252368000/LastPositionMin?'                                                
                        },
                        //icon : "standard:address"
                    }
                ]);
                                
            }
            else if (state === "INCOMPLETE") {
                alert('INCOMPLETE');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                                 alert(errors[0].message);
                    }
                } else {
                    alert('Erreur inconnue');
                }
            }
        });
        $A.enqueueAction(action);
    },
    

})