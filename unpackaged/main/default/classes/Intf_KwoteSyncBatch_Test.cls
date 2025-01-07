/**
 * Created by Michael on 04-04-24.
 */

@IsTest
private class Intf_KwoteSyncBatch_Test {

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

    }

    @IsTest
    static void testBatchBehavior() {

        Intf_WebserviceMock.status = 200;
        Intf_WebserviceMock.interfaceToTest = 'KWOTE';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new Intf_WebserviceMock());

        Intf_KwoteSyncBatch batch = new Intf_KwoteSyncBatch();
        Database.executeBatch(batch);

        Test.stopTest();

        SalesAreaData__c sad = [SELECT Id, Encours__c, LatePayment__c, Score__c FROM SalesAreaData__c LIMIT 1];
        System.debug('========================== TEST Intf_WebserviceCalloutKwote_Test sad: ' + sad);
        System.assertEquals(1, sad.Encours__c);
        System.assertEquals(1, sad.LatePayment__c);

    }

    @IsTest
    static void testScheduling() {

        Intf_WebserviceMock.status = 200;
        Intf_WebserviceMock.interfaceToTest = 'KWOTE';

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class,new Intf_WebserviceMock());
        String scheduleId = Intf_KwoteSyncBatch.scheduleThis();

        // GEt the information from the CronTrigger API Object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :scheduleId];

        // Verify the expressions are the same
        System.assertEquals('0 0 10 * * ?', ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        System.Test.stopTest();
    }
}