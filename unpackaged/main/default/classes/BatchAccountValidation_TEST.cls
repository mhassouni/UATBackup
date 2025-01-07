@isTest
public class BatchAccountValidation_TEST {
    static void setupTestData() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='Test Account 1', Statut_du_grade__c='Processing', Grade_Request_Date__c=System.now().addMinutes(-1)));
        accounts.add(new Account(Name='Test Account 2', Statut_du_grade__c='Processing', Grade_Request_Date__c=System.now().addMinutes(-10)));
        insert accounts;
    }

    @isTest
    static void testBatchExecution() {
        // Démarrer le test en appelant la méthode setupTestData
        setupTestData();
        
        
        // Démarrer le batch
        Test.startTest();
        BatchAccountValidation batch = new BatchAccountValidation();
        Database.executeBatch(batch);
        Test.stopTest();

        List<Account> updatedAccounts = [SELECT Id, Statut__c, Statut_du_grade__c, Grade_Request_Date__c FROM Account WHERE Statut_du_grade__c = 'Error'];
        System.assert(updatedAccounts.size() == 1, 'Il devrait y avoir un seul account avec la valeur du statut du grade = Error');
    }
}