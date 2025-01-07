@isTest
private class InitUpdateSalesAreaTerritoryData_Test 
{

    static void setupTestData() 
    {
		// Créer des données de test - comptes et enregistrements SalesAreaData__c associés
		
        String recordtypeCLIENT = Label.ACC_RecordTypeId_CompteClient;
        String recordtypePROSPECT = Label.ACC_RecordTypeId_CompteProspect;
        // Création d'un compte GU
        Account guAccount = new Account(CodeNACE__c = '1111', RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='PIES');
        // Création des comptes enfants DU avec différentes empreintes
        Account child1 = new Account(CodeNACE__c = '11110',RecordTypeId = recordtypePROSPECT, Name='Child DU 1', DB_DUNS_Number__c='DU1', DB_DUNS_GU__c='GU1', PaysRegionPF__c='PIES',Compte_Parent_legal__c=guAccount.id);
        Account child2 = new Account(CodeNACE__c = '11111',RecordTypeId = recordtypeCLIENT, Name='Child DU 2', DB_DUNS_Number__c='DU2', DB_DUNS_GU__c='GU1', PaysRegionPF__c='PITA',Compte_Parent_legal__c=guAccount.id);
        Account child3 = new Account(CodeNACE__c = '11112',RecordTypeId = recordtypePROSPECT, Name='Child DU 3', DB_DUNS_Number__c='DU3',  DB_DUNS_DU__c='DU1', DB_DUNS_GU__c='GU1', PaysRegionPF__c='PFUK',Compte_Parent_legal__c=guAccount.id);
        insert new List<Account>{child1, child2, child3, guAccount};
		LegalEntity__c LegalEntity1 = new LegalEntity__c(Name = 'LegalEntity1');
        insert LegalEntity1;

        SalesArea__c SalesArea1 = new SalesArea__c(Name = 'SalesArea1', BusinessLine__c = 'Containers' , Brand__c ='Petit Forestier' , Country__c ='FRANCE' , LegalEntity__c = LegalEntity1.Id );
		insert SalesArea1;
            
            
        SalesAreaData__c sad1 = new SalesAreaData__c(Account__c = child1.Id, SalesArea__c = SalesArea1.Id, Verified__c= true);
        SalesAreaData__c sad2 = new SalesAreaData__c(Account__c = child1.Id, SalesArea__c = SalesArea1.Id, Verified__c= true);
        SalesAreaData__c sad3 = new SalesAreaData__c(Account__c = child3.Id, SalesArea__c = SalesArea1.Id, Verified__c= true);
        insert new List<SalesAreaData__c>{sad1, sad2, sad3};
            

    }
    
    @isTest
    static void testBatchExecution() 
    {
        // Créer des données de test pour Segmentation__c et SalesAreaData__c
        // Démarrer le test en appelant la méthode setupTestData
        setupTestData();
        
        
        // Démarrer le batch
        Test.startTest();
        InitUpdateSalesAreaTerritoryDataBatch batchInstance = new InitUpdateSalesAreaTerritoryDataBatch();
        Database.executeBatch(batchInstance);
        Test.stopTest();

        // Vérifier que les enregistrements SalesAreaData__c ont été mis à jour comme prévu
        List<SalesAreaData__c> updatedSadRecords = [SELECT Id, Verified__c, Last_Batch_Update__c FROM SalesAreaData__c WHERE Verified__c = false];
        System.assertEquals(3, updatedSadRecords.size(), 'All verified records should have been updated');
        for (SalesAreaData__c sad : updatedSadRecords) 
        {
			System.assertEquals(false, sad.Verified__c, 'Verified__c should be false');
            System.assertNotEquals(null, sad.Last_Batch_Update__c, 'Last_Batch_Update__c should not be null');
        }
    }
}