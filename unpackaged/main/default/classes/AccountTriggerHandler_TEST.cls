@isTest
public class AccountTriggerHandler_TEST {
    @TestSetup
    static void setupTestData() {
        String recordtypeCLIENT = Label.CPT_RecordTypeId_CompteClient;
        String recordtypeSITE = Label.CPT_RecordTypeId_CompteSite;
        // Création d'un compte GU
        Account clientAccount = new Account(RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='DRO IDF 1');
        Account siteAccount = new Account(RecordTypeId = recordtypeSITE, Name='Global Ultimate - SITE', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='DRO IDF 1', ParentId=clientAccount.Id);
        System.debug('clientAccount : ' + clientAccount.Id);
        System.debug('siteAccount : ' + siteAccount.Id);
        insert new List<Account>{clientAccount, siteAccount};
        siteAccount.ParentId=clientAccount.Id;
        update siteAccount;
        
    }

    @isTest
    public static void updateSAPIdOfSiteAccountTEST() {
        
        // This code runs as the system user
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='PF Administrateur Système'];
        User u = new User(Alias = 'standt', Email='PFTestTalend.integration@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='PFTestTalend.integration@testorg.com');
        //User u = [SELECT Id FROM User WHERE UserName = 'talend.integration@testorg.com'];
        System.runAs(u) {
            System.debug([SELECT Id, Name, RecordType.Name FROM Account]);
            Account siteAccount = [SELECT Id, Tech_SAP_Id__c FROM Account WHERE Name='Global Ultimate - SITE' LIMIT 1];
            siteAccount.Tech_SAP_Id__c = '123456789';
            update siteAccount;
            System.debug([SELECT Id, Name, RecordType.Name FROM Account WHERE Name='Global Ultimate - SITE']);
        }
        Test.stopTest();
        Account clientAccount = [SELECT Id, Tech_SAP_Id__c FROM Account WHERE Name='Global Ultimate' LIMIT 1];
        System.assert(clientAccount.Tech_SAP_Id__c == '123456789');
    }

    @IsTest
    public static void updateSAPIdOfClientAccountTEST() {
        
        // This code runs as the system user
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='PF Administrateur Système'];
        User u = new User(Alias = 'standt', Email='PFTestTalend.integration@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='PFTestTalend.integration@testorg.com');
        //User u = [SELECT Id FROM User WHERE UserName = 'talend.integration@testorg.com'];
        System.runAs(u) {
            System.debug([SELECT Id, Name, RecordType.Name FROM Account]);
            Account clientAccount = [SELECT Id, Tech_SAP_Id__c FROM Account WHERE Name='Global Ultimate' LIMIT 1];
            clientAccount.Tech_SAP_Id__c = '123456789';
            update clientAccount;
            System.debug([SELECT Id, Name, RecordType.Name FROM Account WHERE Name='Global Ultimate']);
        }
        Test.stopTest();
        Account siteAccount = [SELECT Id, Tech_SAP_Id__c FROM Account WHERE Name='Global Ultimate - SITE' LIMIT 1];
        System.assert(siteAccount.Tech_SAP_Id__c == '123456789');
    }
}