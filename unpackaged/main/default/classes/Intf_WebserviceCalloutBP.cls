/**
 * Created by Michael on 06-03-24.
 */

public with sharing class Intf_WebserviceCalloutBP extends Intf_WebserviceCalloutAbstract implements Intf_WebserviceCallout {

    private String setInterfaceType() {
        return 'BusinessPartner';
    }

    private String setNamedCredential() {
        return 'Intf_BP_SAP';
    }

    private String setCaller() {
        return 'Intf_WebserviceCalloutBP';
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
        System.debug('============================== Intf_WebserviceCalloutBP handleResponse rqstMsg: ' + rqstMsg);
        Id businessPartnerId = (Id)rqstMsg.get('salesforceId');

        System.debug('============================== Intf_WebserviceCalloutBP handleResponse businessPartnerId: ' + businessPartnerId);
        System.debug('============================== Intf_WebserviceCalloutBP handleResponse serviceResult: ' + serviceResult);

        String objectAPIName = businessPartnerId.getSObjectType().getDescribe().getName().toLowerCase();
        String queryTable = objectAPIName == 'contact' ? 'Contact' : 'Account';

        String status;
        String message;


        if( technicalError || ((serviceResult.statusCode != 200) && (serviceResult.statusCode != 201))) {

            status = Intf_WebserviceCalloutService.TO_BE_FIXED_STATUS;
            message = serviceResult.body;

        } else {

            status = Intf_WebserviceCalloutService.SYNC_IN_PROGRESS_STATUS;
            message = null;
        }

        String query = 'SELECT Id, Intf_Sync_Status__c, Intf_Synchronisation_Message__c ';
        query += 'FROM ' + queryTable + ' ';
        query += 'WHERE Id = :businessPartnerId FOR UPDATE';

        System.debug('============================== Intf_WebserviceCalloutBP handleResponse query: ' + query);

        List<SObject> sObjects = Database.query(query);

        if (!sObjects.isEmpty()) {
            sObjects[0].put('Intf_Sync_Status__c', status);
            sObjects[0].put('Intf_Synchronisation_Message__c', status);

            update sObjects;
            System.debug('============================== Intf_WebserviceCalloutBP handleResponse sObjects to update: ' + sObjects);
        }
    }

    public void registerMonitoningMessage(String method, String outgoingMessage, String responseMessage, String interfaceName, Integer statusCode, Boolean isError, Boolean isResponse) {

        Map<String, Object> rqstMsg =(Map<String, Object>) JSON.deserializeUntyped(outgoingMessage);
        System.debug('============================== Intf_WebserviceCalloutBP registerMonitoningMessage OUTGOING BP message: ' + rqstMsg);
        String messId = (String)rqstMsg.get('messid');

        System.debug('====================== Intf_WebserviceCalloutBP registerMonitoningMessage OUTGOING messId: ' + messId);

        super.registerMonitoningMessage(method, outgoingMessage, responseMessage, interfaceName, statusCode, isError, messId, isResponse);

    }

}