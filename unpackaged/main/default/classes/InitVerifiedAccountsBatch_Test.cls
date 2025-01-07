@isTest
private class InitVerifiedAccountsBatch_Test 
{

    static void setupTestData() 
    {
		// Créer des données de test - comptes et enregistrements SalesAreaData__c associés
		
        String recordtypeCLIENT = Label.ACC_RecordTypeId_CompteClient;
        String recordtypePROSPECT = Label.ACC_RecordTypeId_CompteProspect;
        // Création d'un compte GU
        Account guAccount = new Account(Verified__c = true, CodeNACE__c = '1111', RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='PIES');
        // Création des comptes enfants DU avec différentes empreintes
        Account child1 = new Account(Verified__c = true, CodeNACE__c = '11110',RecordTypeId = recordtypePROSPECT, Name='Child DU 1', DB_DUNS_Number__c='DU1', DB_DUNS_GU__c='GU1', PaysRegionPF__c='PIES',Compte_Parent_legal__c=guAccount.id);
        Account child2 = new Account(Verified__c = true, CodeNACE__c = '11111',RecordTypeId = recordtypeCLIENT, Name='Child DU 2', DB_DUNS_Number__c='DU2', DB_DUNS_GU__c='GU1', PaysRegionPF__c='PITA',Compte_Parent_legal__c=guAccount.id);
        Account child3 = new Account(Verified__c = true, CodeNACE__c = '11112',RecordTypeId = recordtypePROSPECT, Name='Child DU 3', DB_DUNS_Number__c='DU3',  DB_DUNS_DU__c='DU1', DB_DUNS_GU__c='GU1', PaysRegionPF__c='PFUK',Compte_Parent_legal__c=guAccount.id);
        insert new List<Account>{child1, child2, child3, guAccount};

    }
    
    @isTest
    static void testBatchExecution() 
    {
        // Créer des données de test pour Segmentation__c et SalesAreaData__c
        // Démarrer le test en appelant la méthode setupTestData
        setupTestData();
        
        
        // Démarrer le batch
        Test.startTest();
        InitVerifiedAccountsBatch batchInstance = new InitVerifiedAccountsBatch();
        Database.executeBatch(batchInstance);
        Test.stopTest();

        // Vérifier que les enregistrements SalesAreaData__c ont été mis à jour comme prévu
        List<Account> updatedSadRecords = [SELECT Id, Verified__c, Last_Batch_Update__c FROM Account WHERE Verified__c = false];
        System.assertEquals(4, updatedSadRecords.size(), 'All verified records should have been updated');
        for (Account acc : updatedSadRecords) 
        {
			System.assertEquals(false, acc.Verified__c, 'Verified__c should be false');
            System.assertNotEquals(null, acc.Last_Batch_Update__c, 'Last_Batch_Update__c should not be null');
        }
    }
}