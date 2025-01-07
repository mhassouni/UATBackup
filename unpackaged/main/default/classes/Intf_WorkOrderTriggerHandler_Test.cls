/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 24-04-2024
 * @last modified by  : Michaël Cabaraux
**/

@IsTest
private class Intf_WorkOrderTriggerHandler_Test {

    @TestSetup
    static void setupData() {

        Asset asset = new Asset(
                Name = 'PF-123456'
        );
        insert asset;

        Account account = new Account(
                Name = 'Agence Test',
                Tech_SAP_Id__c = 'SAP1234'
        );
        insert account;

        Id coRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact_Chauffeur').getRecordTypeId();

        Contact contact = new Contact(
                FirstName = 'Monsieur',
                LastName = 'Test',
                MobilePhone = '063456884',
                AccountId = account.Id,
                RecordTypeId = coRecTypeId
        );
        insert contact;

        Case caseInfo = new Case(
                Asset = asset,
                Account = account,
                Pays__c = 'France',
                Rue_Lieu__c = 'Rue du test 1',
                Code_postal__c = '34566',
                Ville__c = 'TestVile',
                Nom_Chauffeur__c = 'Chauffeur Test',
                N_Tel_Chauffeur__c = '0634567789',
                Priority = 'Moyenne',
                Description_incident_client__c = 'Je suis en panne',
                Contact_Chauffeur__c = contact.Id
        );
        insert caseInfo;

    }

    @IsTest
    static void testBreakdown() {

        Id woRecTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Depannage_Vehicule').getRecordTypeId();

        Case caseInfo = [
                SELECT Id, AssetId, AccountId, Account.Tech_SAP_Id__c, Asset.Name, Pays__c, Rue_Lieu__c, Code_postal__c, Ville__c, Nom_Chauffeur__c, N_Tel_Chauffeur__c, Priority,
                    Description_incident_client__c, Contact_Chauffeur__r.FirstName, Contact_Chauffeur__r.LastName, Contact_Chauffeur__r.Email, Contact_Chauffeur__r.MobilePhone, Contact_Chauffeur__r.Phone
                FROM Case
                ];
        Account account = [SELECT Id FROM Account];

        Test.startTest();
        Intf_WebserviceMock.status = 200;
        Test.setMock(HttpCalloutMock.class, new Intf_WebserviceMock());

        WorkOrder wo = new WorkOrder(
                CaseId = caseInfo.Id,
                Organe_controler__c = 'Caisse',
                Agence_Intervenante__c = account.Id,
                Earliest_Start_Permitted__c = Datetime.now().addDays(1),
                RecordTypeId = woRecTypeId,
                AccountId = account.Id
        );
        insert wo;

        Test.stopTest();

        List<Interface_monitoring__c> interfaceMonitorings = new List<Interface_monitoring__c>([SELECT Id, Status__c, Status_Code__c, OutgoingMessage__c, ResponseMessage__c FROM Interface_monitoring__c]);
        System.assertEquals(1, interfaceMonitorings.size());

    }

    @IsTest
    static void testService() {

        Id woRecTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Demande_de_service').getRecordTypeId();

        Case caseInfo = [SELECT Id, AssetId, AccountId, Account.Tech_SAP_Id__c, Asset.Name, Pays__c, Rue_Lieu__c, Code_postal__c, Ville__c, Nom_Chauffeur__c, N_Tel_Chauffeur__c, Priority, Description_incident_client__c FROM Case];
        Account account = [SELECT Id FROM Account];

        Test.startTest();
        Intf_WebserviceMock.status = 200;
        Test.setMock(HttpCalloutMock.class, new Intf_WebserviceMock());

        WorkOrder wo = new WorkOrder(
                CaseId = caseInfo.Id,
                Organe_controler__c = 'Caisse',
                Agence_Intervenante__c = account.Id,
                Earliest_Start_Permitted__c = Datetime.now().addDays(1),
                RecordTypeId = woRecTypeId,
                AccountId = account.Id
        );
        insert wo;

        Test.stopTest();

        List<Interface_monitoring__c> interfaceMonitorings = new List<Interface_monitoring__c>([SELECT Id, Status__c, Status_Code__c, OutgoingMessage__c, ResponseMessage__c FROM Interface_monitoring__c]);
        System.assertEquals(1, interfaceMonitorings.size());

    }

}