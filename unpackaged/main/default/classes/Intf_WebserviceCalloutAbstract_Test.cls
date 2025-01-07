/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 05-05-2024
 * @last modified by  : Michaël Cabaraux
**/

@IsTest
private class Intf_WebserviceCalloutAbstract_Test {

    @IsTest
    static void testMode1() {

        Intf_WebserviceCalloutTest.mode = 1;

        Test.startTest();

        Test.setMock(HttpCalloutMock.class,new Intf_WebserviceMock());
        Intf_WebserviceCalloutTest webserviceDummyCallout = new Intf_WebserviceCalloutTest();
        webserviceDummyCallout.executeCallout(new List<String>{'Test'});

        Test.stopTest();

        List<Interface_Monitoring__c> interfaceMonitorings = new List<Interface_Monitoring__c>([SELECT Id, MessageId__c, OutgoingMessage__c, ResponseMessage__c FROM Interface_Monitoring__c]);
        System.assert(!interfaceMonitorings.isEmpty());

    }

    @IsTest
    static void testMode2() {

        Intf_WebserviceCalloutTest.mode = 2;

        List<String> payload = new List<String>();
        for (Integer i = 0; i < 95 ; i++) {
            payload.add('Test' + 1);
        }

        Test.startTest();

        Test.setMock(HttpCalloutMock.class,new Intf_WebserviceMock());
        Intf_WebserviceCalloutTest webserviceDummyCallout = new Intf_WebserviceCalloutTest();
        webserviceDummyCallout.executeCallout(payload);

        Test.stopTest();

        List<Interface_Monitoring__c> interfaceMonitorings = new List<Interface_Monitoring__c>([SELECT Id, MessageId__c, OutgoingMessage__c, ResponseMessage__c FROM Interface_Monitoring__c]);
        System.assert(!interfaceMonitorings.isEmpty());

    }

    @IsTest
    static void testRegisteringMonitoringMessage() {

        Test.startTest();

        Intf_WebserviceCalloutTest webserviceDummyCallout = new Intf_WebserviceCalloutTest();
        webserviceDummyCallout.registerMonitoningMessage('POST','Test', null, 'TEST', 200, false, '123456789ab', false);

        webserviceDummyCallout.registerMonitoningMessage('POST','Test', 'ResponseOK', 'TEST', 200, false, '123456789ab', true);

        Test.stopTest();

        Interface_Monitoring__c interfaceMonitoring = [SELECT Id, MessageId__c, OutgoingMessage__c, ResponseMessage__c FROM Interface_Monitoring__c WHERE MessageId__c = '123456789ab'];
        System.assertEquals('Test', interfaceMonitoring.OutgoingMessage__c);
        System.assertEquals('ResponseOK', interfaceMonitoring.ResponseMessage__c);

    }
}