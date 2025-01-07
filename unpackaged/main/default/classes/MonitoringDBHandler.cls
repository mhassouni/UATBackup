public class MonitoringDBHandler {
    public static void handleUpdatedAccounts(Map<Id, Account> oldMap, Map<Id, Account> newMap) {
        List<MonitoringDB__c> monitoringRecords = new List<MonitoringDB__c>();
        List<MonitoringDB__c> monitoringRecordsToUpdate = new List<MonitoringDB__c>();
        Map<Id, Set<String>> accountToModifiedFields = new Map<Id, Set<String>>();
        
        // Vérifier chaque Account pour les champs modifiés et créer des MonitoringDB__c records
        for (Account newAcc : newMap.values()) {
            Account oldAcc = oldMap.get(newAcc.Id);
            Set<String> modifiedFields = new Set<String>();
            
            // Liste des champs à surveiller
            String fieldsToCheckStr = System.Label.MonitoringDB_Fields; 
    		List<String> fieldsToCheck = fieldsToCheckStr.split(',');
            
         for (String field : fieldsToCheck) {
    		if (newAcc.get(field) != oldAcc.get(field)) {
        		// Vérification du duplicata
       		 List<MonitoringDB__c> duplicates = [SELECT Id, Account__c, FieldName__c, OldValue__c, NewValue__c 
                                            FROM MonitoringDB__c 
                                            WHERE Account__c = :newAcc.Id 
                                            AND FieldName__c = :field 
                                            LIMIT 1];

        // Créer un nouvel enregistrement si aucun duplicata n'existe
        if (duplicates.isEmpty()) {
            monitoringRecords.add(new MonitoringDB__c(
                Account__c = newAcc.Id,
                FieldName__c = field,
                ModificationDate__c = System.now(),
                OldValue__c = String.valueOf(oldAcc.get(field)),
                NewValue__c = String.valueOf(newAcc.get(field))
            ));
            modifiedFields.add(field);
        } 
        // Mettre à jour le champ existant s'il existe un duplicata
        else {
            MonitoringDB__c duplicate = duplicates[0];
            duplicate.OldValue__c = String.valueOf(oldAcc.get(field));
            duplicate.NewValue__c = String.valueOf(newAcc.get(field));
            duplicate.ModificationDate__c = System.now();
            monitoringRecordsToUpdate.add(duplicate);
            modifiedFields.add(field);
        }
    }
}//End for
            
            if (!modifiedFields.isEmpty()) {
                accountToModifiedFields.put(newAcc.Id, modifiedFields);
            }
        }
        
        if (!monitoringRecords.isEmpty()) {
            insert monitoringRecords;
        }
        if(!monitoringRecordsToUpdate.isEmpty())
        {
            Update monitoringRecordsToUpdate;
        }
        
        // Envoi des e-mails après la création des enregistrements MonitoringDB__c
        if (!accountToModifiedFields.isEmpty()) {
            EmailDBManager.sendModificationEmails(accountToModifiedFields, oldMap, newMap);
        }
    }
    
    //GC
    public static void handleUpdatedAccountsGC(Map<Id, Account> oldMap, Map<Id, Account> newMap) {
        List<MonitoringDB__c> monitoringRecords = new List<MonitoringDB__c>();
        List<MonitoringDB__c> monitoringRecordsToUpdate = new List<MonitoringDB__c>();
        Map<Id, Set<String>> accountToModifiedFields = new Map<Id, Set<String>>();
        
        // Vérifier chaque Account pour les champs modifiés et créer des MonitoringDB__c records
        for (Account newAcc : newMap.values()) {
            Account oldAcc = oldMap.get(newAcc.Id);
            Set<String> modifiedFields = new Set<String>();
            
            // Liste des champs à surveiller
            String fieldsToCheckStr = System.Label.MonitoringDB_Fields_GC; 
    		List<String> fieldsToCheck = fieldsToCheckStr.split(',');
            
         for (String field : fieldsToCheck) {
    		if (newAcc.get(field) != oldAcc.get(field)) {
        		// Vérification du duplicata
       		 List<MonitoringDB__c> duplicates = [SELECT Id, Account__c, FieldName__c, OldValue__c, NewValue__c 
                                            FROM MonitoringDB__c 
                                            WHERE Account__c = :newAcc.Id 
                                            AND FieldName__c = :field 
                                            LIMIT 1];

        // Créer un nouvel enregistrement si aucun duplicata n'existe
        if (duplicates.isEmpty()) {
            monitoringRecords.add(new MonitoringDB__c(
                Account__c = newAcc.Id,
                FieldName__c = field,
                ModificationDate__c = System.now(),
                OldValue__c = String.valueOf(oldAcc.get(field)),
                NewValue__c = String.valueOf(newAcc.get(field))
            ));
            modifiedFields.add(field);
        } 
        // Mettre à jour le champ existant s'il existe un duplicata
        else {
            MonitoringDB__c duplicate = duplicates[0];
            duplicate.OldValue__c = String.valueOf(oldAcc.get(field));
            duplicate.NewValue__c = String.valueOf(newAcc.get(field));
            duplicate.ModificationDate__c = System.now();
            monitoringRecordsToUpdate.add(duplicate);
            modifiedFields.add(field);
        }
    }
}//End for
            
            if (!modifiedFields.isEmpty()) {
                accountToModifiedFields.put(newAcc.Id, modifiedFields);
            }
        }
        
        if (!monitoringRecords.isEmpty()) {
            insert monitoringRecords;
        }
        if(!monitoringRecordsToUpdate.isEmpty())
        {
            Update monitoringRecordsToUpdate;
        }
        
        // Envoi des e-mails après la création des enregistrements MonitoringDB__c
        //if (!accountToModifiedFields.isEmpty()) {
           // EmailDBManager.sendModificationEmails(accountToModifiedFields, oldMap, newMap);
       // }
    }
}