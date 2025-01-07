@IsTest
private class Intf_AccountTriggerHandler_Test {
    @TestSetup
    static void setupData() {

        SalesArea__c sa = new SalesArea__c(
          Name = 'test'
        );
        insert sa;

        Id acRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();

        Account account = new Account(
                Name = 'Agence Test',
//                Tech_SAP_Id__c = 'SAP1234',
                RecordTypeId = acRecTypeId
        );
        insert account;

        SalesAreaData__c sad = new SalesAreaData__c(
                Account__c = account.Id,
                SalesArea__c = sa.Id
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

        Opportunity oppy = new Opportunity(
                AccountId = account.Id,
                Name = 'Oppy Test',
                CloseDate = Date.today().addDays(5),
                StageName = '1 - Opportunité créée',
                SalesAreaData__c = sad.Id

        );
        insert oppy;

        InvolvedStakeholder__c involvedStakeholder = new InvolvedStakeholder__c(
                InvolvedAccount__c = account.Id,
                Opportunity__c = oppy.Id,
                Role__c = 'Livré'
        );
        insert involvedStakeholder;

        RoleContact__c roleContact = new RoleContact__c(
                Contact__c = contact.Id,
                CompteOpportunite__c = account.Id,
                Opportunite__c = oppy.Id,
                Role__c = 'Payeur'

        );
        insert roleContact;

    }

    @IsTest
    static void testB2BBehavior() {

        Test.startTest();
        Intf_WebserviceMock.status = 200;
        Test.setMock(HttpCalloutMock.class, new Intf_WebserviceMock());

        Opportunity oppy = [SELECT Id, StageName FROM Opportunity];
        oppy.StageName = System.Label.Intf_Default_Oppy_BP_Status_Sync;

        update oppy;

        Account acc = [SELECT Id, Ville__c FROM Account];
        acc.Ville__c = 'Test';

        update acc;

        Test.stopTest();

        List<Interface_monitoring__c> interfaceMonitorings = new List<Interface_monitoring__c>([SELECT Id, Status__c, Status_Code__c, OutgoingMessage__c, ResponseMessage__c, CreatedDate FROM Interface_monitoring__c]);
        System.debug('============== TEST TEST TEST interfaceMonitorings: ' + interfaceMonitorings);
        System.assertEquals(2, interfaceMonitorings.size());
    }

    @IsTest
    static void testB2CBehavior() {

        Contact contact = [SELECT FirstName, LastName, MobilePhone, Phone, Salutation FROM Contact];

        Test.startTest();
        Intf_WebserviceMock.status = 200;
        Test.setMock(HttpCalloutMock.class, new Intf_WebserviceMock());

        Opportunity oppy = [SELECT Id, StageName FROM Opportunity];
        oppy.StageName = System.Label.Intf_Default_Oppy_BP_Status_Sync;
        oppy.Contact_B2C__c = contact.Id;

        update oppy;

        Account acc = [SELECT Id, Ville__c FROM Account];
        acc.Ville__c = 'Test';

        update acc;

        Test.stopTest();

        List<Interface_monitoring__c> interfaceMonitorings = new List<Interface_monitoring__c>([SELECT Id, Status__c, Status_Code__c, OutgoingMessage__c, ResponseMessage__c, CreatedDate FROM Interface_monitoring__c]);
        System.debug('============== TEST TEST TEST interfaceMonitorings: ' + interfaceMonitorings);
        System.assertEquals(2, interfaceMonitorings.size());
    }
}