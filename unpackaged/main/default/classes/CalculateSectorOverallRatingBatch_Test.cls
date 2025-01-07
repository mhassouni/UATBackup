@isTest
public class CalculateSectorOverallRatingBatch_Test 
{
    static void setupTestData() 
    {
		// Créer des données de test - comptes et enregistrements SalesAreaData__c associés
		Segmentation__c Segmentation1 = new Segmentation__c(BusinessLine__c = 'Containers', CodeNACE__c = '1111', Notation__c=6 );
        Segmentation__c Segmentation2 = new Segmentation__c(BusinessLine__c = 'Containers', CodeNACE__c = '11110');
        Segmentation__c Segmentation3 = new Segmentation__c(BusinessLine__c = 'Containers', CodeNACE__c = '11111');
        insert new List<Segmentation__c>{Segmentation1, Segmentation2, Segmentation3};
        String recordtypeCLIENT = Label.ACC_RecordTypeId_CompteClient;
        String recordtypePROSPECT = Label.ACC_RecordTypeId_CompteProspect;
        // Création d'un compte GU
        Account guAccount = new Account(RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='PIES', CodeNACE__c='1111', DB_Code_Activite_NACE__c ='1111');
        // Création des comptes enfants DU avec différentes empreintes
        Account child1 = new Account(RecordTypeId = recordtypePROSPECT, Name='Child DU 1', DB_DUNS_Number__c='DU1', DB_DUNS_GU__c='GU1', PaysRegionPF__c='PIES',Compte_Parent_legal__c=guAccount.id, CodeNACE__c='1111', DB_Code_Activite_NACE__c ='1111');
        Account child2 = new Account(RecordTypeId = recordtypeCLIENT, Name='Child DU 2', DB_DUNS_Number__c='DU2', DB_DUNS_GU__c='GU1', PaysRegionPF__c='PITA',Compte_Parent_legal__c=guAccount.id, CodeNACE__c='1111', DB_Code_Activite_NACE__c ='1111');
        Account child3 = new Account(RecordTypeId = recordtypePROSPECT, Name='Child DU 3', DB_DUNS_Number__c='DU3',  DB_DUNS_DU__c='DU1', DB_DUNS_GU__c='GU1', PaysRegionPF__c='PFUK',Compte_Parent_legal__c=guAccount.id);
        insert new List<Account>{child1, child2, child3, guAccount};
		LegalEntity__c LegalEntity1 = new LegalEntity__c(Name = 'LegalEntity1');
        insert LegalEntity1;

        SalesArea__c SalesArea1 = new SalesArea__c(Name = 'SalesArea1', BusinessLine__c = 'Containers' , Brand__c ='Petit Forestier' , Country__c ='FRANCE' , LegalEntity__c = LegalEntity1.Id );
		insert SalesArea1;
            
            
        SalesAreaData__c sad1 = new SalesAreaData__c(Account__c = child1.Id, SalesArea__c = SalesArea1.Id, Segmentation__c=Segmentation1.Id );
        SalesAreaData__c sad2 = new SalesAreaData__c(Account__c = child1.Id, SalesArea__c = SalesArea1.Id, Segmentation__c=Segmentation1.Id );
        SalesAreaData__c sad3 = new SalesAreaData__c(Account__c = child3.Id, SalesArea__c = SalesArea1.Id, Segmentation__c=Segmentation1.Id );
        insert new List<SalesAreaData__c>{sad1, sad2, sad3};
    }
    

    @isTest
    static void testBatchExecution() 
    {
        // Démarrer le test en appelant la méthode setupTestData
        setupTestData();
        
        
        // Démarrer le batch
        Test.startTest();
        CalculateSectorOverallRatingBatch batch = new CalculateSectorOverallRatingBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        
        // Vérifier que la note globale du secteur a été mise à jour sur le compte
        Account updatedAcc = [SELECT Id, Note_globale_secteur__c FROM Account WHERE Name = 'Child DU 1'];
        System.assertEquals(6, updatedAcc.Note_globale_secteur__c, 'La note globale du secteur n\'a pas été correctement mise à jour.');
    }
}