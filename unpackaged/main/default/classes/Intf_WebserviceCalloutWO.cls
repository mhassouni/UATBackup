/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 03-01-2024
 * @last modified by  : Michaël Cabaraux
**/

public with sharing class Intf_WebserviceCalloutWO extends Intf_WebserviceCalloutAbstract implements Intf_WebserviceCallout {

    private String setInterfaceType() {
        return 'WorkOrder';
    }

    private String setNamedCredential() {
        return 'Intf_Workorder_SAP';
    }

    private String setCaller() {
        return 'Intf_WebserviceCalloutWO';
    }

    private Boolean setQueueing() {
        return false;
    }

    private Integer setMode() {

        if (System.isBatch() || System.isFuture()) {
            return intf_WebserviceCalloutAbstract.MODE_DIRECT;
        } else {
            return Intf_WebserviceCalloutAbstract.MODE_FUTURE;
        }

    }

    private String setMethod() {
        return 'POST';
    }

    private Map<String, String> setHeaders() {
        
        Map<String, String> headers = new Map<String, String>{'Content-Type' => 'application/json'};
        return headers;
        //return new Map<String, String>();
    }

    private Map<String, String> setTagRemap() {
        return new Map<String, String>();
    }

    public void executeCallout(List<Object> payloadObjects) {

        super.doCallout(payloadObjects);
    }

    public void handleResponse(Intf_ServiceResult serviceResult, String payload, Boolean technicalError) {

        Map<String, Object> rqstMsg =(Map<String, Object>) JSON.deserializeUntyped(payload);
        System.debug('============================== Intf_WebserviceCalloutWO handleResponse rqstMsg: ' + rqstMsg);
        String workOrderId = (String)rqstMsg.get('salesforceId');

        System.debug('============================== Intf_WebserviceCalloutWO handleResponse workOrderId: ' + workOrderId);
        System.debug('============================== Intf_WebserviceCalloutWO handleResponse serviceResult: ' + serviceResult);

        List<WorkOrder> workOdersToUpdate = [SELECT Id, Intf_Sync_Status__c FROM WorkOrder WHERE Id = :workOrderId FOR UPDATE];

        System.debug('============================== Intf_WebserviceCalloutWO handleResponse workOdersToUpdate: ' + workOdersToUpdate);

        if (!workOdersToUpdate.isEmpty() && serviceResult != null) {

            if( technicalError || ((serviceResult.statusCode != 200) && (serviceResult.statusCode != 201))) {

                workOdersToUpdate[0].Intf_Sync_Status__c = Intf_WebserviceCalloutService.TO_BE_FIXED_STATUS;
                workOdersToUpdate[0].Intf_Synchronisation_Message__c = serviceResult.body;

            } else {

                workOdersToUpdate[0].Intf_Sync_Status__c = Intf_WebserviceCalloutService.SYNC_IN_PROGRESS_STATUS;
                workOdersToUpdate[0].Intf_Synchronisation_Message__c = null;

            }

            System.debug('============================== Intf_WebserviceCalloutWO handleResponse workOdersToUpdate: ' + workOdersToUpdate);
            update workOdersToUpdate;
        }

    }

    public void registerMonitoningMessage(String method, String outgoingMessage, String responseMessage, String interfaceName, Integer statusCode, Boolean isError, Boolean isResponse) {

        Map<String, Object> rqstMsg =(Map<String, Object>) JSON.deserializeUntyped(outgoingMessage);
        System.debug('============================== Intf_WebserviceCalloutWO registerMonitoningMessage OUTGOING workorder message: ' + rqstMsg);
        String messId = (String)rqstMsg.get('messid');

        System.debug('====================== Intf_WebserviceCalloutWO registerMonitoningMessage OUTGOING messId: ' + messId);

        super.registerMonitoningMessage(method, outgoingMessage, responseMessage, interfaceName, statusCode, isError, messId, isResponse);

    }
}