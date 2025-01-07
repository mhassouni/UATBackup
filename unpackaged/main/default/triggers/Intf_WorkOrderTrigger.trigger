/**
 * Created by Michael on 04-03-24.
 */

trigger Intf_WorkOrderTrigger on WorkOrder (after insert, after update) {

    new Intf_Framework_Triggers()
            .bind(Intf_Framework_Triggers.Evt.afterinsert, new Intf_WorkOrderTriggerHandler.sendWorkOrderToSAP())
            .bind(Intf_Framework_Triggers.Evt.afterupdate, new Intf_WorkOrderTriggerHandler.sendWorkOrderToSAP())
            .manage();
}