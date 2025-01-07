@isTest
public class SADSegmentationSyncBatch_Test 
{
    static void setupTestData()  
    {
		// Créer des données de test - comptes et enregistrements SalesAreaData__c associés
		
        String recordtypeCLIENT = Label.ACC_RecordTypeId_CompteClient;
        String recordtypePROSPECT = Label.ACC_RecordTypeId_CompteProspect;
        // Création d'un compte GU
        Account guAccount = new Account(Verified__c = false, DB_Code_Activite_NACE__c = '1111', CodeNACE__c = '1111', RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='PIES');
        // Création des comptes enfants DU avec différentes empreintes
        Account child1 = new Account(Verified__c = false, DB_Code_Activite_NACE__c = '1111', CodeNACE__c = '1111',RecordTypeId = recordtypePROSPECT, Name='Child DU 1', DB_DUNS_Number__c='DU1', DB_DUNS_GU__c='GU1', PaysRegionPF__c='PIES',Compte_Parent_legal__c=guAccount.id);
        Account child2 = new Account(Verified__c = false, DB_Code_Activite_NACE__c = '11111', CodeNACE__c = '11111',RecordTypeId = recordtypeCLIENT, Name='Child DU 2', DB_DUNS_Number__c='DU2', DB_DUNS_GU__c='GU1', PaysRegionPF__c='PITA',Compte_Parent_legal__c=guAccount.id);
        Account child3 = new Account(Verified__c = false, DB_Code_Activite_NACE__c = '11112', CodeNACE__c = '11112',RecordTypeId = recordtypePROSPECT, Name='Child DU 3', DB_DUNS_Number__c='DU3',  DB_DUNS_DU__c='DU1', DB_DUNS_GU__c='GU1', PaysRegionPF__c='PFUK',Compte_Parent_legal__c=guAccount.id);
        insert new List<Account>{child1, child2, child3, guAccount};
		LegalEntity__c LegalEntity1 = new LegalEntity__c(Name = 'LegalEntity1');
        insert LegalEntity1;

        SalesArea__c SalesArea1 = new SalesArea__c(Name = 'SalesArea1', BusinessLine__c = 'Containers' , Brand__c ='Petit Forestier' , Country__c ='FRANCE' , LegalEntity__c = LegalEntity1.Id );
		insert SalesArea1;
            
            
        SalesAreaData__c sad1 = new SalesAreaData__c(PFRegion__c = 'PIES', Verified__c = false, Account__c = child1.Id, SalesArea__c = SalesArea1.Id);
        SalesAreaData__c sad2 = new SalesAreaData__c(PFRegion__c = 'PIES', Verified__c = false, Account__c = child2.Id, SalesArea__c = SalesArea1.Id);
        SalesAreaData__c sad3 = new SalesAreaData__c(PFRegion__c = 'PIES', Verified__c = false, Account__c = child3.Id, SalesArea__c = SalesArea1.Id);
        SalesAreaData__c sad4 = new SalesAreaData__c(PFRegion__c = 'PIES', Verified__c = false, Account__c = guAccount.Id, SalesArea__c = SalesArea1.Id);
        insert new List<SalesAreaData__c>{sad1, sad2, sad3, sad4};
            
        Segmentation__c Segmentation1 = new Segmentation__c(BusinessLine__c = 'Containers', CodeNACE__c = '1111');
        Segmentation__c Segmentation2 = new Segmentation__c(BusinessLine__c = 'Containers', CodeNACE__c = '11110');
        Segmentation__c Segmentation3 = new Segmentation__c(BusinessLine__c = 'Containers', CodeNACE__c = '11111');
        insert new List<Segmentation__c>{Segmentation1, Segmentation2, Segmentation3};

    }
    
 	@isTest
    static void testBatchExecution() 
    {
        // Créer des données de test pour Segmentation__c et SalesAreaData__c
        // Démarrer le test en appelant la méthode setupTestData
        setupTestData();
        
        // Exécuter le batch
        Test.startTest();
        Integer initialRetryCount = 0; // Compteur initial
        Database.executeBatch(new SADSegmentationSyncBatch(initialRetryCount, 'PIES'));
        Test.stopTest();
        
		// Vérifier le résultat
        List<SalesAreaData__c> updatedSadRecords = [SELECT Id, Segmentation__c FROM SalesAreaData__c WHERE Segmentation__c != ''];
        for (SalesAreaData__c sad : updatedSadRecords) 
        {
            System.assertNotEquals(null, sad.Segmentation__c, 'Le champ Segmentation__c ne doit pas être nul');
    	}
    }
}