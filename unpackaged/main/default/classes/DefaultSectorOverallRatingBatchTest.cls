@isTest
private class DefaultSectorOverallRatingBatchTest 
{
 	static void setupTestData() 
    {
        
		// Créer des données de test - comptes et enregistrements SalesAreaData__c associés
		
        String recordtypeCLIENT = Label.ACC_RecordTypeId_CompteClient;
        String recordtypePROSPECT = Label.ACC_RecordTypeId_CompteProspect;
        // Création d'un compte GU
        Account guAccount = new Account(RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1',  DB_DUNS_GU__c='GU1',  PaysRegionPF__c='PIES');
        insert guAccount;
        // Création des comptes enfants DU avec différentes empreintes
        Account child1 = new Account(RecordTypeId = recordtypePROSPECT, Name='Child DU 1', DB_DUNS_Number__c='DU1', DB_DUNS_GU__c='GU1',DB_DUNS_DU__c='GU1', PaysRegionPF__c='PIES',Compte_Parent_legal__c=guAccount.id);
        Account child2 = new Account(RecordTypeId = recordtypeCLIENT, Name='Child DU 2', DB_DUNS_Number__c='DU2', DB_DUNS_GU__c='GU1', PaysRegionPF__c='PITA',Compte_Parent_legal__c=guAccount.id);
        Account child3 = new Account(RecordTypeId = recordtypePROSPECT, Name='Child DU 3', DB_DUNS_Number__c='DU3',  DB_DUNS_DU__c='DU1', DB_DUNS_GU__c='GU1', PaysRegionPF__c='PFUK',Compte_Parent_legal__c=guAccount.id);
        insert new List<Account>{child1, child2, child3};

    }
    
    @isTest
    static void testBatchExecution() 
    {
        // Démarrer le test en appelant la méthode setupTestData
        setupTestData();
        
        

        // Vérifier qu'aucun compte n'a de Note_globale_secteur__c définie
        List<Account> accountsBeforeBatch = [SELECT Id, Note_globale_secteur__c FROM Account WHERE Note_globale_secteur__c = null];
        System.assertEquals(200, accountsBeforeBatch.size());

        // Exécuter le batch
        Test.startTest();
        Database.executeBatch(new DefaultSectorOverallRatingBatch(), 200);
        Test.stopTest();

        // Vérifier que tous les comptes ont désormais une Note_globale_secteur__c définie
        List<Account> accountsAfterBatch = [SELECT Id, Note_globale_secteur__c FROM Account WHERE Note_globale_secteur__c = 1];
        System.assertEquals(200, accountsAfterBatch.size());
    }
}