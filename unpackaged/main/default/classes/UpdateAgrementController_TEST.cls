@isTest
public class UpdateAgrementController_TEST {

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
        Account guAccount1 = new Account(RecordTypeId = recordtypeCLIENT, Name='Global Ultimate 1', DB_DUNS_Number__c='GU2', DB_DUNS_DU__c='GU2', DB_DUNS_GU__c='GU2',  PaysRegionPF__c='PIBE');
        // Création des comptes enfants DU avec différentes empreintes
        Account child1 = new Account(RecordTypeId = recordtypePROSPECT, Name='Child DU 1', DB_DUNS_Number__c='DU1', DB_DUNS_GU__c='GU1', PaysRegionPF__c='DRO IDF 1',Compte_Parent_legal__c=guAccount.id, IDEulerHermes__c = 'companyIdTest', Pays__c = 'FRANCE');
        Account child2 = new Account(RecordTypeId = recordtypePROSPECT, Name='Child DU 2', DB_DUNS_Number__c='DU2', DB_DUNS_GU__c='GU2', PaysRegionPF__c='PIBE',Compte_Parent_legal__c=guAccount1.id, IDEulerHermes__c = 'companyIdTest', Pays__c = 'BE');
        insert new List<Account>{child1, guAccount, guAccount1, child2};
		LegalEntity__c LegalEntity1 = new LegalEntity__c(Name = 'LegalEntity1');
        insert LegalEntity1;

        SalesArea__c SalesArea1 = new SalesArea__c(Name = 'SalesArea1', BusinessLine__c = 'Containers' , Brand__c ='Petit Forestier' , Country__c ='FRANCE' , LegalEntity__c = LegalEntity1.Id );
        SalesArea__c SalesArea2 = new SalesArea__c(Name = 'SalesArea2', BusinessLine__c = 'Containers' , Brand__c ='Petit Forestier' , Country__c ='BELGIQUE' , LegalEntity__c = LegalEntity1.Id );
		insert new List<SalesArea__c>{SalesArea1, SalesArea2};
            
        SalesAreaData__c sad1 = new SalesAreaData__c(Account__c = child1.Id, SalesArea__c = SalesArea1.Id);
        SalesAreaData__c sad2 = new SalesAreaData__c(Account__c = child2.Id, SalesArea__c = SalesArea2.Id);
        insert new List<SalesAreaData__c>{sad1, sad2};

        Opportunity Opportunity1 = Utils_TestMethods.createOpportunity('Opportunity1', Label.OPP_StageName_PropositionRemise, Date.newInstance(2020,9,1), child1);
        Opportunity Opportunity2 = Utils_TestMethods.createOpportunity('Opportunity2', Label.OPP_StageName_PropositionRemise, Date.newInstance(2020,9,1), child2);
        Opportunity1.AccountId = child1.Id;
        Opportunity1.SalesAreaData__c = sad1.Id;

        Opportunity2.AccountId = child2.Id;
        Opportunity2.SalesAreaData__c = sad2.Id;
        insert new List<Opportunity>{Opportunity1, Opportunity2};

        PolicyId_Legal_Entity__c customTest = new PolicyId_Legal_Entity__c();
        customTest.Name = 'LegalEntity1';
        customTest.Legal_Entity__c = 'LegalEntity1';
        customTest.policyId__c = 'LegalEntity1';
        insert customTest;

    }

    @isTest
    static void UpdateAgrementController_TEST() {
        setupTestData();

        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Opportunity1'];
        Opportunity opp2 = [SELECT Id FROM Opportunity WHERE Name = 'Opportunity2'];
        UpdateAgrementController.updateAgrement(opp.Id);
        UpdateAgrementController.updateAgrement(opp2.Id);
        Test.stopTest();

        SalesAreaData__c sadUpdated = [SELECT Id, Agrement__c, Montant_agrement__c, Date_agrement__c, Account__r.IDEulerHermes__c, Account__r.Policy_Id__c FROM SalesAreaData__c WHERE Account__r.Name = 'Child DU 1'];
        System.assert(sadUpdated.Montant_agrement__c != null && sadUpdated.Agrement__c == true && sadUpdated.Date_agrement__c != null, 'Le montant de l\'agrement ainsi que la date ne devrait pas être vide');

    }
}