@isTest
public class RetrieveRequestedGradeBatch_TEST {
    static void setupTestData() {

        List<allianz_api__c> customList = new List<allianz_api__c>();
        allianz_api__c customTest2 = new allianz_api__c();
        customTest2.Name = 'New access token';
        customTest2.Endpoint__c = 'test';
        customTest2.Method__c = 'test';
        customTest2.API_KEY__c = 'test';
        customList.add(customTest2);

        allianz_api__c customTest3 = new allianz_api__c();
        customTest3.Name = 'Company search';
        customTest3.Endpoint__c = 'test';
        customTest3.Method__c = 'test';
        customTest3.API_KEY__c = 'test';
        customList.add(customTest3);

        allianz_api__c customTest4 = new allianz_api__c();
        customTest4.Name = 'Covers search';
        customTest4.Endpoint__c = 'test';
        customTest4.Method__c = 'test';
        customTest4.API_KEY__c = 'test';
        customList.add(customTest4);

        insert customList;

        PolicyId_Legal_Entity__c customPolicy = new PolicyId_Legal_Entity__c();
        customPolicy.Name = 'Test';
        customPolicy.Legal_Entity__c = 'LegalEntity1';
        customPolicy.policyId__c = 'A0028307201';
        customPolicy.Business_Unit_Code__c = 'SFAC';
        insert customPolicy;

        // Créer des données de test - comptes et enregistrements SalesAreaData__c associés
		
        String recordtypeCLIENT = Label.ACC_RecordTypeId_CompteClient;
        String recordtypePROSPECT = Label.ACC_RecordTypeId_CompteProspect;
        // Création d'un compte GU
        Account guAccount = new Account(RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='DRO IDF 1');
        // Création des comptes enfants DU avec différentes empreintes
        Account child1 = new Account(RecordTypeId = recordtypePROSPECT, Name='Child DU 1', DB_DUNS_Number__c='DU1', DB_DUNS_GU__c='GU1', PaysRegionPF__c='DRO IDF 1',Compte_Parent_legal__c=guAccount.id, IDEulerHermes__c = 'companyIdTest');
        insert new List<Account>{child1, guAccount};
    }

    @isTest
    static void testBatchExecution() {
        // Démarrer le test en appelant la méthode setupTestData
        setupTestData();
        
        // Démarrer le batch
        Test.startTest();
        RetrieveRequestedGradeBatch batch = new RetrieveRequestedGradeBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        Account accUpdated = [SELECT CotationPF__c, DateCotationPF__c FROM Account WHERE Name = 'Child DU 1'];
        System.assert(accUpdated.CotationPF__c != null && accUpdated.DateCotationPF__c != null , 'Le grade ainsi que la date de mise à jour ne devraientt pas être vide');
    }
}