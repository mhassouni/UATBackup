/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 06-07-2023
 * @last modified by  : Michaël Cabaraux
**/

trigger Intf_InterfaceResponseTrigger on Interface_Response__c (before insert, before update, after insert, after update) {

    new Intf_Framework_Triggers()
        .bind(Intf_Framework_Triggers.Evt.afterinsert, new Intf_InterfaceResponseTriggerHandler.UpdateRecordStatusFromInterface())
        .manage();
}