/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 24-04-2024
 * @last modified by  : Michaël Cabaraux
**/

@IsTest
private class Intf_WebserviceCalloutService_Test {
    @IsTest
    static void testPositiveCallout() {

        String interfaceName = 'TEST';
        String caller = 'Intf_WebserviceCalloutTest';
        String payload = JSON.serialize(new List<String>{'TESTString'});
        String namedCredential = 'testCallout';

        Intf_WebserviceMock.status = 200;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new Intf_WebserviceMock());


        Intf_WebserviceCalloutService.calloutWebservice(payload, namedCredential, caller, interfaceName, new Map<String, String>(), 'POST', new Map<String, String>());
        List<Intf_WebserviceCalloutService.ResponseModel> responses = Intf_WebserviceCalloutService.calloutWebserviceBatch(payload, namedCredential, caller, interfaceName, new Map<String, String>(), 'POST', new Map<String, String>());
        System.debug('============================= TEST TEST responses: ' + responses);

        Intf_WebserviceCalloutService.fireFutureCallout(payload, namedCredential, caller, interfaceName, new Map<String, String>(), 'POST', new Map<String, String>{'TESTString' => 'PAYLOADSTring'});

        Test.stopTest();

        Interface_Monitoring__c interfaceMonitoring = [SELECT Id, ResponseMessage__c FROM Interface_Monitoring__c];
        System.assertEquals('OK', interfaceMonitoring.ResponseMessage__c);

    }

    @IsTest
    static void testNegativeCallout() {

        String interfaceName = 'TEST';
        String caller = 'Intf_WebserviceCalloutTest';
        String payload = JSON.serialize(new List<String>{'TESTString'});
        String namedCredential = 'testCallout';
        Intf_WebserviceMock.status = 403;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new Intf_WebserviceMock());

        try {
            Intf_WebserviceCalloutService.calloutWebservice(payload, namedCredential, caller, interfaceName, new Map<String, String>(), 'POST', new Map<String, String>());
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Unauthorized'));
        }

        Test.stopTest();

    }
}