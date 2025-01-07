@isTest
private class EmployeeCountNoteUpdateBatch_Test 
{
    
    static void setupTestData() 
    {
		// Créer des données de test - comptes et enregistrements SalesAreaData__c associés
		
        String recordtypeCLIENT = Label.ACC_RecordTypeId_CompteClient;
        String recordtypePROSPECT = Label.ACC_RecordTypeId_CompteProspect;
        // Création d'un compte GU
        Account guAccount = new Account(DB_Code_Activite_NACE__c = '9104', CodeNACE__c = '9104', Pourcentage_effectif__c = 0.3, RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='PIES');
        // Création des comptes enfants DU avec différentes empreintes
        insert  guAccount;

        EmployeeNoteRule__c EmployeeNoteRule01 = new EmployeeNoteRule__c(Code_Nace__c = '9104', Minimum_Percentage__c = 0.0, Maximum_Percentage__c = 0.5, Note__c = 1);
        insert  EmployeeNoteRule01;

    }

    @isTest
    static void testBatchExecution() 
    {
        // Créer des données de test pour Segmentation__c et SalesAreaData__c
        // Démarrer le test en appelant la méthode setupTestData
        setupTestData();
        Test.startTest();

        // Instancier et exécuter le lot
        EmployeeCountNoteUpdateBatch batch = new EmployeeCountNoteUpdateBatch();
		Database.executeBatch(batch, 100);

        Test.stopTest();

        // Vérifier que les comptes ont été mis à jour avec les bonnes notes d'employés
        List<Account> updatedAccounts = [SELECT Id, Note_Nombre_employe__c FROM Account where DB_Code_Activite_NACE__c = '9104'];
        System.assertEquals(1, updatedAccounts[0].Note_Nombre_employe__c);
    }
}