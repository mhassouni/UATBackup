// Batch pour vider le champ Ancestor__c des enregistrements Account
global class ClearAncestorFieldBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //return Database.getQueryLocator([SELECT Id, Ancestor__c, Is_Parent__c FROM Account ]);
        return Database.getQueryLocator([SELECT Id, Is_Parent__c,Ancestor__c, Empreinte_Geographique__c,Last_Flow_Update__c FROM Account ]);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) {
                    List<Account> ancestors = new List<Account>();

        for(Account acc : scope) {
            acc.Ancestor__c = '';
            acc.Is_Parent__c = false;
            acc.Empreinte_Geographique__c = '';
            acc.Last_Flow_Update__c = '';
            
            
            ancestors.add(acc);
        }
        update ancestors;
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('Champ Ancestor__c vidé pour tous les enregistrements Account.');
    }
}