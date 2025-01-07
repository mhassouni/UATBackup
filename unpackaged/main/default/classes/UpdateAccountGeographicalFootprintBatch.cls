global class UpdateAccountGeographicalFootprintBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Empreinte_Geographique__c FROM Account');
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) {
        String newValue = '';
        
        for (Account acc : scope) {
            acc.Empreinte_Geographique__c = newValue;
        }

        update scope;
    }
 
    global void finish(Database.BatchableContext BC) {
        // Logique facultative à exécuter une fois le lot terminé
    }
}