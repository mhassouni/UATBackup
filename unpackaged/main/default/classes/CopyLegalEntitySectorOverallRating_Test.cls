@isTest
public class CopyLegalEntitySectorOverallRating_Test 
{

     static void setupTestData() 
    {
		// Créer des données de test - comptes et enregistrements SalesAreaData__c associés
		
        String recordtypeCLIENT = Label.ACC_RecordTypeId_CompteClient;
        String recordtypePROSPECT = Label.ACC_RecordTypeId_CompteProspect;
        // Création d'un compte GU
        Account guAccount = new Account(RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1',  DB_DUNS_GU__c='GU1',  PaysRegionPF__c='PIES', Note_globale_secteur__c = 5);
        insert guAccount;
        // Création des comptes enfants DU avec différentes empreintes
        Account child1 = new Account(RecordTypeId = recordtypePROSPECT, Name='Child DU 1', DB_DUNS_Number__c='DU1', DB_DUNS_GU__c='GU1',DB_DUNS_DU__c='GU1', PaysRegionPF__c='PIES',Compte_Parent_legal__c=guAccount.id);
        Account child2 = new Account(RecordTypeId = recordtypeCLIENT, Name='Child DU 2', DB_DUNS_Number__c='DU2', DB_DUNS_GU__c='GU1', PaysRegionPF__c='PITA',Compte_Parent_legal__c=guAccount.id);
        Account child3 = new Account(RecordTypeId = recordtypePROSPECT, Name='Child DU 3', DB_DUNS_Number__c='DU3',  DB_DUNS_DU__c='DU1', DB_DUNS_GU__c='GU1', PaysRegionPF__c='PFUK',Compte_Parent_legal__c=guAccount.id);
        insert new List<Account>{child1, child2, child3};

    }
    
    @isTest
    // Méthode de test pour vérifier le bon fonctionnement du lot (batch)
    static void testBatchExecution() 
    {
        // Démarrer le test en appelant la méthode setupTestData
        setupTestData();
        
        // Démarrer le lot (batch)
        Test.startTest();
        Database.executeBatch(new CopyLegalEntitySectorOverallRatingBatch());
        Test.stopTest();
        
        // Vérifier que le champ Note_globale_secteur__c a été mis à jour
        Account testAccount = [SELECT Id, Name, Note_globale_secteur__c, Legal_Entity_Sector_Overall_Rating__c FROM Account WHERE Name = 'Child DU 1'];
        System.assertEquals(testAccount.Legal_Entity_Sector_Overall_Rating__c, testAccount.Note_globale_secteur__c, 'Sector overall rating was not copied correctly.');
    }
}