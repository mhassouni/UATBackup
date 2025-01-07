public class UpdateAncestors 
{
	public void executeUpdateAncestors() 
    {
           
        List<Account> scope =   [SELECT Id, DB_DUNS_GU__c, DB_DUNS_DU__c, DB_DUNS_Number__c, ParentId, Ancestor__c, Is_Parent__c FROM Account];

        Map<Id, String> ancestorMap = new Map<Id, String>();
        List<Account> accountsToUpdate = new List<Account>();

        Set<Id> guParentAccountIds = new Set<Id>();
        Set<Id> duParentAccountIds = new Set<Id>();
        Set<Id> parentAccountIds = new Set<Id>();

        // Traitement des ancêtres pour Global Ultimate
        for (Account accA : scope) {
            String ancestors = '';
            for (Account accB : scope) {
                if (accB.DB_DUNS_GU__c != null && accA.DB_DUNS_Number__c != null && accB.DB_DUNS_GU__c == accA.DB_DUNS_Number__c) {
                    ancestors += 'GU: ChildId => ' + accB.Id + ';';
                    guParentAccountIds.add(accA.Id);
                    if(accA.Id =='0017T00000XsIM5QAN')
                    System.debug('0017T00000XsIM5QAN  Account :'+ ancestors);

                }
            }
            if (guParentAccountIds.contains(accA.Id)) {
                ancestorMap.put(accA.Id, ancestors);
            }
        }

        // Traitement des ancêtres pour Domestic Ultimate
        for (Account accA : scope) {
            String ancestors = '';
            for (Account accB : scope) {
                if (accB.DB_DUNS_DU__c != null && accA.DB_DUNS_Number__c != null && accB.DB_DUNS_DU__c == accA.DB_DUNS_Number__c) {
                    ancestors += 'DU: ChildId => ' + accB.Id + ';';
                    duParentAccountIds.add(accA.Id);
                }
            }
            if (duParentAccountIds.contains(accA.Id)) {
                ancestorMap.put(accA.Id, ancestors);
            }
        }

        // Traitement des ancêtres pour Parent
        for (Account accA : scope) {
            String ancestors = '';
            for (Account accB : scope) {
                if (accB.ParentId == accA.Id) {
                    ancestors += 'P: ChildId => ' + accB.Id + ';';
                    parentAccountIds.add(accA.Id);
                }
            }
            if (parentAccountIds.contains(accA.Id)) {
                ancestorMap.put(accA.Id, ancestors);
            }
        }

        // Mise à jour des champs Ancestor__c pour chaque compte
        for (Account acc : scope) {
            if (ancestorMap.containsKey(acc.Id)) {
                acc.Ancestor__c = ancestorMap.get(acc.Id);
                acc.Is_Parent__c = true;
                accountsToUpdate.add(acc);
            }
        }

        update accountsToUpdate;
    }

    
}