trigger CompteAfterUpdate on Account (after update) {

    
    
    // Monitoring DB Logic
    String fieldsToCheckStr = System.Label.MonitoringDB_Fields; 
    String fieldsToCheckGCStr = System.Label.MonitoringDB_Fields_GC; 
    List<String> fieldsToCheck = fieldsToCheckStr.split(',');
    List<String> FieldsGCToCheck = fieldsToCheckGCStr.split(',');

    Boolean isRelevantChangeDetected = false;
    Boolean isGCRelevantChangeDetected = false;

    for (Account newAccount : Trigger.new) {
        Account oldAccount = Trigger.oldMap.get(newAccount.Id);
        System.debug('### Checking MonitoringDB for Account Id: ' + newAccount.Id);

        for (String field : fieldsToCheck) {
            if (newAccount.get(field) != oldAccount.get(field)) {
                isRelevantChangeDetected = true;
                break;
            }
        }

        if (isRelevantChangeDetected) {
            break;
        }
    }

    if (isRelevantChangeDetected) {
        System.debug('### Relevant changes detected for MonitoringDBHandler');
        MonitoringDBHandler.handleUpdatedAccounts(Trigger.oldMap, Trigger.newMap);
    }

    for (Account newAccount : Trigger.new) {
        Account oldAccount = Trigger.oldMap.get(newAccount.Id);
        System.debug('### Checking MonitoringDBGC for Account Id: ' + newAccount.Id);

        for (String field : FieldsGCToCheck) {
            if (newAccount.get(field) != oldAccount.get(field)) {
                isGCRelevantChangeDetected = true;
                break;
            }
        }

        if (isGCRelevantChangeDetected) {
            break;
        }
    }

    if (isGCRelevantChangeDetected) {
        System.debug('### Relevant changes detected for MonitoringDBHandler GC');
        MonitoringDBHandler.handleUpdatedAccountsGC(Trigger.oldMap, Trigger.newMap);
    }
}