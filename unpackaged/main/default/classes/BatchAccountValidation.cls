global class BatchAccountValidation implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Statut__c, Statut_du_grade__c, Grade_Request_Date__c FROM Account WHERE Statut_du_grade__c = \'Processing\' AND Grade_Request_Date__c != null';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) {
        List<Account> accountToUpdate = new List<Account>();
        for(Account account : scope) {
            if(account.Grade_Request_Date__c.addMinutes(5) < Datetime.now()) {
                account.Statut__c = 'Attente Validation CM';
                account.Statut_du_grade__c = 'Error';
                accountToUpdate.add(account);
            }
        }
        if(accountToUpdate.size() > 0) {
            update accountToUpdate;
        }
    }

    global void finish(Database.BatchableContext BC) {
    
        System.Debug('>>>> AccountGradesValidation End execute <<<<');
    }
}