@isTest
private class NotePoidsCABatch_TEST 
{
     static void setupTestData() 
    {
		// Créer des données de test - comptes et enregistrements SalesAreaData__c associés
		
        String recordtypeCLIENT = Label.ACC_RecordTypeId_CompteClient;
        String recordtypePROSPECT = Label.ACC_RecordTypeId_CompteProspect;
        // Création d'un compte GU
        Account Account01 = new Account(Poids_CA__c = -1, DB_Code_Activite_NACE__c = '9104', CodeNACE__c = '9104', Pourcentage_effectif__c = 0.3, RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='PIES');
        Account Account02 = new Account(Poids_CA__c = 1, DB_Code_Activite_NACE__c = '9104', CodeNACE__c = '9104', Pourcentage_effectif__c = 0.3, RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='PIES');
        Account Account03 = new Account(Poids_CA__c = 3, DB_Code_Activite_NACE__c = '9104', CodeNACE__c = '9104', Pourcentage_effectif__c = 0.3, RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='PIES');
        Account Account04 = new Account(Poids_CA__c = 6, DB_Code_Activite_NACE__c = '9104', CodeNACE__c = '9104', Pourcentage_effectif__c = 0.3, RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='PIES');
        Account Account05 = new Account(Poids_CA__c = 11, DB_Code_Activite_NACE__c = '9104', CodeNACE__c = '9104', Pourcentage_effectif__c = 0.3, RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='PIES');
        Account Account06 = new Account(Poids_CA__c = 16, DB_Code_Activite_NACE__c = '9104', CodeNACE__c = '9104', Pourcentage_effectif__c = 0.3, RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='PIES');
        Account Account07 = new Account(Poids_CA__c = 27, DB_Code_Activite_NACE__c = '9104', CodeNACE__c = '9104', Pourcentage_effectif__c = 0.3, RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='PIES');
        Account Account08 = new Account(Poids_CA__c = 38, DB_Code_Activite_NACE__c = '9104', CodeNACE__c = '9104', Pourcentage_effectif__c = 0.3, RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='PIES');
        Account Account09 = new Account(Poids_CA__c = 55, DB_Code_Activite_NACE__c = '9104', CodeNACE__c = '9104', Pourcentage_effectif__c = 0.3, RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='PIES');
        Account Account10 = new Account(Poids_CA__c = 80, DB_Code_Activite_NACE__c = '9104', CodeNACE__c = '9104', Pourcentage_effectif__c = 0.3, RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='PIES');
        // Création des comptes enfants DU avec différentes empreintes
        insert new List<Account>{Account01, Account02, Account03, Account04, Account05, Account06, Account07, Account08, Account09, Account10};
    }
 
    @isTest
    static void testBatchExecution() 
    {
        
        // Démarrer le test en appelant la méthode setupTestData
        setupTestData();
        
        Test.startTest();

        // Instancier et exécuter le lot
        NotePoidsCABatch batch = new NotePoidsCABatch();
        Database.executeBatch(batch);

        Test.stopTest();

        // Vérifier que les comptes ont été mis à jour avec les bonnes notes de poids de CA
        List<Account> updatedAccounts = [SELECT Id, Note_Poids_CA__c FROM Account];
        /*System.assertEquals(1, updatedAccounts[0].Note_Poids_CA__c);
        System.assertEquals(2, updatedAccounts[1].Note_Poids_CA__c);
        System.assertEquals(3, updatedAccounts[2].Note_Poids_CA__c);
        System.assertEquals(4, updatedAccounts[3].Note_Poids_CA__c);
        System.assertEquals(7, updatedAccounts[4].Note_Poids_CA__c);
        System.assertEquals(10, updatedAccounts[5].Note_Poids_CA__c);
        System.assertEquals(15, updatedAccounts[6].Note_Poids_CA__c);*/
    }
}