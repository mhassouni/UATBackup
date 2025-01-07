global class UpdateAncestorsBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
            return Database.getQueryLocator('SELECT Id, DB_DUNS_GU__c, DB_DUNS_DU__c, DB_DUNS_Number__c, ParentId, Ancestor__c, Is_Parent__c FROM Account');
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) 
    {
        // Filtrer les comptes qui sont à la fois parents et enfants
        Set<Account> AccountsSetToUpdate = new Set<Account>();
        Map<Id, String> ancestorMap = new Map<Id, String>();
        List<Account> accountsToUpdate = new List<Account>();
        Set<Id> parentAccountIds = new Set<Id>();

        // Récupérer tous les comptes de la base
        for (Account accA : scope) {
            String ancestors = '';
        
            // Traitement des ancêtres pour Global Ultimate
            for (Account accB : scope) {
                if ((accB.DB_DUNS_GU__c != null && accA.DB_DUNS_Number__c != null) && (accB.DB_DUNS_GU__c == accA.DB_DUNS_Number__c)) {
                    ancestors += 'GU: ChildId => ' + accB.Id + ';';
                    AccountsSetToUpdate.add(accA);
                    parentAccountIds.add(accA.Id);
                }
            }
        
            // Traitement des ancêtres pour Domestic Ultimate
            for (Account accB : scope) {
                if ((accB.DB_DUNS_DU__c != null && accA.DB_DUNS_Number__c != null) && (accB.DB_DUNS_DU__c == accA.DB_DUNS_Number__c)) {
                    ancestors += 'DU: ChildId => ' + accB.Id + ';';
                    AccountsSetToUpdate.add(accA);
                    parentAccountIds.add(accA.Id);
                }
            }
        
            // Traitement des ancêtres pour Parent
            for (Account accB : scope) {
                if (accB.ParentId == accA.Id) {
                    ancestors += 'P: ChildId => ' + accB.Id + ';';
                    AccountsSetToUpdate.add(accA);
                    parentAccountIds.add(accA.Id);
                }
            }
        
            if (parentAccountIds.contains(accA.Id)) {
                ancestorMap.put(accA.Id, ancestors);
            }
        }

        // Mise à jour des champs Ancestor__c pour chaque compte
       // for (Account acc : scope) 
        //{
          //  if (ancestorMap.containsKey(acc.Id)) 
           // {
            //    acc.Ancestor__c = ancestorMap.get(acc.Id);
            //}
        //}
        
        
        for (Account acc : AccountsSetToUpdate) 
        {
            if (ancestorMap.containsKey(acc.Id)) {
                acc.Ancestor__c = ancestorMap.get(acc.Id);
                acc.Is_Parent__c = true;
                accountsToUpdate.add(acc);
            }
        }
         
        //List<Account> AccountsListToUpdate = new List<Account>(AccountsSetToUpdate);
       // update AccountsListToUpdate;
        update accountsToUpdate;
    }

    global void finish(Database.BatchableContext BC) 
    {
        // Actions à effectuer après l'exécution du lot
    }
}