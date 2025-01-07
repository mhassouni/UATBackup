({		
    reloadChart: function(cmp, evt, helper) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        var btnBack = cmp.find("btnBack");
        $A.util.removeClass(btnBack, "gras");
        var btn12h = cmp.find("btn12h");
        $A.util.removeClass(btn12h, "gras");
        var btn6h = cmp.find("btn6h");
        $A.util.removeClass(btn6h, "gras");
        var btn3h = cmp.find("btn3h");
        $A.util.removeClass(btn3h, "gras");
        var btnLive = cmp.find("btnLive");
        $A.util.removeClass(btnLive, "gras");
                               
        var val = evt.getSource().get('v.value');        
        
        if(val === '12h'){
            $A.util.addClass(btn12h, 'gras');
        }else if(val === '6h'){
            $A.util.addClass(btn6h, 'gras');
        }else if(val === '3h'){
            $A.util.addClass(btn3h, 'gras');
        }else if(val === 'live'){
            $A.util.addClass(btnLive, 'gras');
        }else{
            $A.util.addClass(btnBack, 'gras');
        }
                
        //alert("click sr le bouton : "+ val)
        var temp2 = [];
        var action1 = cmp.get("c.NewRefreshLowBatteryEvolution");
        action1.setParams({ precord : cmp.get("v.recordId"), param:val });
        action1.setCallback(this, function(response){        	    	    
            if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                temp2 = JSON.parse(response.getReturnValue());
                helper.createLineGraph(cmp, temp2);
                $A.util.toggleClass(spinner, "slds-hide");
            }else{
                console.log("Unknown error");                
                $A.util.toggleClass(spinner, "slds-hide");
                alert('Erreur inconnue');
            }            
        });  
       $A.enqueueAction(action1);

    }
})