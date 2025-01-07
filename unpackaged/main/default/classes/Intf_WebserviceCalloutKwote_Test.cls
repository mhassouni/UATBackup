/**
 * Created by Michael on 04-04-24.
 */

@IsTest
private class Intf_WebserviceCalloutKwote_Test {

    @TestSetup
    static void setupData() {

        SalesArea__c sa = new SalesArea__c(
                Name = 'test'
        );
        insert sa;

        Id acRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();

        Account account = new Account(
                Name = 'Agence Test',
                Tech_SAP_Id__c = 'SAP1234',
                RecordTypeId = acRecTypeId,
                DB_Valeur_ID_Prefere__c = 'BE0547562822'
        );
        insert account;

        SalesAreaData__c sad = new SalesAreaData__c(
                Account__c = account.Id,
                SalesArea__c = sa.Id,
                PFRegion__c = 'PIBE'
        );
        insert sad;

        Id coRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Particulier_B2C').getRecordTypeId();

        Contact contact = new Contact(
                FirstName = 'Monsieur',
                LastName = 'Test',
                MobilePhone = '063456884',
                AccountId = account.Id,
                RecordTypeId = coRecTypeId,
                Fonction__c = 'Particulier'
        );
        insert contact;

    }
    @IsTest
    static void testBehavior() {

        Intf_Kwote_Access_Mapping__mdt kwoteAccessMapping = [SELECT Id, api_key__c, api_access__c, Legal_Entity__c FROM Intf_Kwote_Access_Mapping__mdt WHERE DeveloperName = 'PIBE'];

        Map<String, String> headers = new Map<String, String>{
                'X-API-KEY' => kwoteAccessMapping.api_key__c,
                'X-API-PWD' => kwoteAccessMapping.api_access__c,
                'accept' => 'application/json'
        };

        Intf_WebserviceMock.status = 200;
        Intf_WebserviceMock.interfaceToTest = 'KWOTE';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new Intf_WebserviceMock());

        Intf_WebserviceCalloutKwote.headers = headers;

        Intf_WebserviceCalloutKwote intfWebserviceCalloutWO = new Intf_WebserviceCalloutKwote();
        intfWebserviceCalloutWO.executeCallout(new List<Object>{kwoteAccessMapping.Legal_Entity__c});

        Test.stopTest();

        SalesAreaData__c sad = [SELECT Id, Encours__c, LatePayment__c, Score__c FROM SalesAreaData__c LIMIT 1];
        System.debug('========================== TEST Intf_WebserviceCalloutKwote_Test sad: ' + sad);
        System.assertEquals(1, sad.Encours__c);
        System.assertEquals(1, sad.LatePayment__c);

    }
}