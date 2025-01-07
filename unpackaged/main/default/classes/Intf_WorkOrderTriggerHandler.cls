/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 05-05-2024
 * @last modified by  : Michaël Cabaraux
**/

public with sharing class Intf_WorkOrderTriggerHandler {

    private static final String INTERFACE_NAME = 'WorkOrder_SAP';

    public without sharing class sendWorkOrderToSAP implements Intf_Framework_Triggers.Handler {
        public void handle() {

            List<Intf_Activation__mdt> interfaceActivations = new List<Intf_Activation__mdt>([SELECT Id, Active__c FROM Intf_Activation__mdt WHERE Interface_Name__c = :INTERFACE_NAME]);

            if (!Test.isRunningTest() && (interfaceActivations.isEmpty() || interfaceActivations[0].Active__c == false)) { return; }

            List<WorkOrder> workOrderToSend = new List<WorkOrder>();

            if (Trigger.isInsert) {
                workOrderToSend = (List<WorkOrder>)Trigger.new;

            } else {
                for (WorkOrder wo: (List<WorkOrder>)Trigger.new) {
                    if (wo.Intf_Sync_Status__c == 'Resend') {
                        workOrderToSend.add(wo);
                    }
                }
            }

            System.debug('========================== WorkOrderTriggerHandler sendWorkOrderToSAP workOrderToSend#: ' + workOrderToSend.size());
            if (!workOrderToSend.isEmpty()) {
                sendWorkOrdersToSAP(workOrderToSend);
            }
        }
    }

    private static void sendWorkOrdersToSAP(List<WorkOrder> workOrders) {

        Set<Id> caseIds = new Set<Id>();
        Set<Id> agencesIds = new Set<Id>();

        for (WorkOrder wo : workOrders) {
            if (wo.CaseId != null) { caseIds.add(wo.CaseId); }
            if (wo.Agence_Intervenante__c != null) { agencesIds.add(wo.Agence_Intervenante__c); }
        }
        
        //if(caseIds.isEmpty()) return;

        Map<Id, Case> casesByIds = new Map<Id, Case>([
                SELECT Id, Asset.Name, Contact_Chauffeur__c, Contact_responsable_parc__c, Contact_Chauffeur__r.Name, Contact_Chauffeur__r.Email, Contact_Chauffeur__r.MobilePhone,
                        Contact_Chauffeur__r.Phone, Contact_responsable_parc__r.Name, Contact_responsable_parc__r.Email, Contact_responsable_parc__r.MobilePhone,
                        Contact_responsable_parc__r.Phone, Nom_Chauffeur__c, N_Tel_Chauffeur__c, Precision__c, Priority, Ville__c, Code_postal__c, Pays__c, Rue_Lieu__c, Description_incident_client__c,
                        Account.Tech_SAP_Id__c
                FROM Case WHERE Id = :caseIds
        ]);

        Map<Id, String> agenceSAPIdsByIds = new Map<Id, String>();
        for (Account account : [SELECT Id, Organisation_de_service_SAP__c FROM Account WHERE Id in :agencesIds]) {
            agenceSAPIdsByIds.put(account.Id, account.Organisation_de_service_SAP__c);
        }

        List<Intf_WorkOrderSchemaBuilder.WorkOrderMsg> woMessages = new List<Intf_WorkOrderSchemaBuilder.WorkOrderMsg>();

        for (WorkOrder wo : workOrders) {
            woMessages.add(new Intf_WorkOrderSchemaBuilder.WorkOrderMsg(wo, casesByIds.get(wo.CaseId), agenceSAPIdsByIds.get(wo.Agence_Intervenante__c)));
        }

        if (!woMessages.isEmpty()) {
            Intf_WebserviceCalloutWO intfWebserviceCalloutWO = new Intf_WebserviceCalloutWO();
            intfWebserviceCalloutWO.executeCallout(woMessages);
        }


    }

}