@isTest
private class TestUpdateLegalParentBatch {
    
    static void setupTestData() {
        // Création des comptes pour le test
        Account guAccount = new Account(Name='Global Ultimate', DB_DUNS_Number__c='GU123', DB_DUNS_DU__c='GU123',DB_DUNS_GU__c='GU123');
	
        Account duAccount = new Account(Name='Domestic Ultimate', DB_DUNS_Number__c='DU123', DB_DUNS_DU__c='DU123', DB_DUNS_GU__c='GU123');
        Account ordinaryAccount = new Account(Name='Ordinary Account', DB_DUNS_Number__c='Ord123', DB_DUNS_DU__c='DU123', DB_DUNS_GU__c='GU123');
        guAccount.RecordTypeId=Label.ACC_RecordTypeId_CompteClient;
	duAccount.RecordTypeId=Label.ACC_RecordTypeId_CompteClient;
      ordinaryAccount.RecordTypeId=Label.ACC_RecordTypeId_CompteClient;
        insert new List<Account>{guAccount, duAccount, ordinaryAccount};
    }
    
    static testMethod void testBatch() {
        setupTestData();
        
        // Démarrage du test
        Test.startTest();
        
        // Exécution du batch
        UpdateLegalParentBatch batch = new UpdateLegalParentBatch();
        Database.executeBatch(batch);
        
        // Fin du test
        Test.stopTest();
        
        // Vérifications
        Account updatedOrdinaryAcc = [SELECT Compte_Parent_legal__c FROM Account WHERE Name='Ordinary Account'];
        Account updatedDuAcc = [SELECT Compte_Parent_legal__c FROM Account WHERE Name='Domestic Ultimate'];
        
        // Récupérer les ID des comptes référencés pour vérification
        Account duAccount = [SELECT Id FROM Account WHERE Name='Domestic Ultimate'];
        Account guAccount = [SELECT Id FROM Account WHERE Name='Global Ultimate'];
        
        // Vérifie que le compte ordinaire a bien pour parent légal le DU
        System.assertEquals(duAccount.Id, updatedOrdinaryAcc.Compte_Parent_legal__c, 'The ordinary account should have the DU account as its legal parent.');
        
        // Vérifie que le compte DU a bien pour parent légal le GU
        System.assertEquals(guAccount.Id, updatedDuAcc.Compte_Parent_legal__c, 'The DU account should have the GU account as its legal parent.');
    }
}