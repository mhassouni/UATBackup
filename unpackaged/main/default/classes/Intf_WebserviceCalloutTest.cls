/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 03-01-2024
 * @last modified by  : Michaël Cabaraux
**/

public with sharing class Intf_WebserviceCalloutTest extends Intf_WebserviceCalloutAbstract implements Intf_WebserviceCallout {

    @TestVisible
    private static Integer mode = 1;

    private String setInterfaceType() {
        return 'TEST';
    }

    private String setNamedCredential() {
        return 'testCallout';
    }

    private String setCaller() {
        return 'Intf_WebserviceCalloutTest';
    }

    private Boolean setQueueing() {
        return false;
    }

    private Integer setMode() {
        return mode;
    }

    private String setMethod() {
        return 'POST';
    }
    private Map<String, String> setHeaders() {
        return new Map<String, String>();
    }
    private Map<String, String> setTagRemap() {
        return new Map<String, String>();
    }

    public void executeCallout(List<Object> payloadObjects) {

        super.doCallout(payloadObjects);
    }

    public void handleResponse(Intf_ServiceResult serviceResult, String payload, Boolean technicalError) {
    }

    public void registerMonitoningMessage(String method, String outgoingMessage, String responseMessage, String interfaceName, Integer statusCode, Boolean isError, Boolean isResponse) {
        super.registerMonitoningMessage(method, outgoingMessage, responseMessage, interfaceName, statusCode, isError, '12456454arekzlhjvhieiedfffhesds', true);
    }

}