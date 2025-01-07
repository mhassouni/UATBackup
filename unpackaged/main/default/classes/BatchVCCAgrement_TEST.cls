@isTest
public class BatchVCCAgrement_TEST {

    static void setupTestData() {

        List<allianz_api__c> customList = new List<allianz_api__c>();
        allianz_api__c customTest = new allianz_api__c();
        customTest.Name = 'Company grade';
        customTest.Endpoint__c = 'test';
        customTest.Method__c = 'test';
        customTest.API_KEY__c = 'test';
        customList.add(customTest);

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

        allianz_api__c customTest5 = new allianz_api__c();
        customTest5.Name = 'Get jobId';
        customTest5.Endpoint__c = 'test';
        customTest5.Method__c = 'test';
        customTest5.API_KEY__c = 'test';
        customList.add(customTest5);

        allianz_api__c customTest6 = new allianz_api__c();
        customTest6.Name = 'Request grade';
        customTest6.Endpoint__c = 'test';
        customTest6.Method__c = 'test';
        customTest6.API_KEY__c = 'test';
        customList.add(customTest6);

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
		LegalEntity__c LegalEntity1 = new LegalEntity__c(Name = 'LegalEntity1');
        insert LegalEntity1;

        SalesArea__c SalesArea1 = new SalesArea__c(Name = 'SalesArea1', BusinessLine__c = 'Containers' , Brand__c ='Petit Forestier' , Country__c ='FRANCE' , LegalEntity__c = LegalEntity1.Id );
		insert SalesArea1;
            
            
        SalesAreaData__c sad1 = new SalesAreaData__c(Account__c = child1.Id, SalesArea__c = SalesArea1.Id);
        
        insert sad1;
    }

    @isTest
    static void testBatchExecution() {
        // Démarrer le test en appelant la méthode setupTestData
        setupTestData();
        
        
        // Démarrer le batch
        Test.startTest();
        BatchVCCAgrementScheduler batch = new BatchVCCAgrementScheduler();
        batch.execute(null);
        Test.stopTest();

        SalesAreaData__c sadUpdated = [SELECT Id, Agrement__c, Montant_agrement__c, Date_agrement__c, Account__r.IDEulerHermes__c, Account__r.Policy_Id__c, SalesArea__r.LegalEntity__r.Name FROM SalesAreaData__c WHERE Account__r.Name = 'Child DU 1'];
        System.debug('sadUpdated :' + sadUpdated);
        System.assert(sadUpdated.Montant_agrement__c != null && sadUpdated.Agrement__c == true && sadUpdated.Date_agrement__c != null, 'Le montant de l\'agrement ainsi que la date ne devraient pas être vide');
    }
}