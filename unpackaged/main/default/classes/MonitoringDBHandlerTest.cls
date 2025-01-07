@IsTest
private class MonitoringDBHandlerTest {

    @IsTest
    static void testHandleUpdatedAccounts() {
        Test.startTest();
       
        
        // Simuler la mise à jour de l'Account
        Map<Id, Account> oldMap = new Map<Id, Account>();
  
        Account updatedAccount = new Account(Name='Test Account 2', DB_Statut_Activite__c='Old Value');
        insert updatedAccount;
        updatedAccount.DB_Statut_Activite__c = 'New Value'; // Modification d'un champ surveillé
        update updatedAccount;

        Map<Id, Account> newMap = new Map<Id, Account>();
        newMap.put(updatedAccount.Id , updatedAccount);
        
  
        
        // Invocation de la méthode handleUpdatedAccounts
       // MonitoringDBHandler.handleUpdatedAccounts(oldMap, newMap);
        
        Test.stopTest();
        
        // Vérification que le record MonitoringDB__c a été créé
        List<MonitoringDB__c> monitoringRecords = [SELECT Account__c, FieldName__c, OldValue__c, NewValue__c FROM MonitoringDB__c];
        System.assertEquals(2, monitoringRecords.size(), 'Un record MonitoringDB__c doit être créé.');
        MonitoringDB__c record = monitoringRecords[0];
        System.assertEquals(updatedAccount.Id, record.Account__c, 'Le record MonitoringDB__c doit être lié au bon Account.');
        System.assertEquals('DB_Statut_Activite__c', record.FieldName__c, 'Le champ modifié doit être correct.');
        System.assertEquals('Old Value', record.OldValue__c, 'La vieille valeur doit être correcte.');
        System.assertEquals('New Value', record.NewValue__c, 'La nouvelle valeur doit être correcte.');
    }
}