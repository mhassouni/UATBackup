/**
 * Created by Michael on 21-03-24.
 */

trigger Intf_OpportunityTrigger on Opportunity (after update) {

    new Intf_Framework_Triggers()
            .bind(Intf_Framework_Triggers.Evt.afterupdate, new Intf_OpportunityTriggerHandler.sendLikendBPsToSAP())
            .manage();


}