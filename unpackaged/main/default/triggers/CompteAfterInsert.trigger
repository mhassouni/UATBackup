trigger CompteAfterInsert on Account (after insert) {

    System.debug('### Trigger CompteAfterInsert fired');
    System.debug('### Trigger.newMap.keySet(): ' + trigger.newMap.keySet());

    Set<Id> recordTypeOkAccountsIdSet = new Set<Id>();

    for (Account a : trigger.new) {
        System.debug('### Checking account Id: ' + a.Id);
        System.debug('### RecordTypeId: ' + a.RecordTypeId);
        System.debug('### TypeIdentifiantNational__c: ' + a.TypeIdentifiantNational__c);
        System.debug('### DB_DUNS_Number__c: ' + a.DB_DUNS_Number__c);
        System.debug('### IdentifiantNational__c: ' + a.IdentifiantNational__c);

        if (
            (a.RecordTypeId == Label.CPT_RecordTypeId_CompteClient || a.RecordTypeId == Label.ACC_RecordTypeId_CompteProspect) &&
            (a.TypeIdentifiantNational__c != Label.CPT_TypeIdentifiantNational_Creation) &&
            (!String.isBlank(a.DB_DUNS_Number__c)) &&
            (!String.isBlank(a.IdentifiantNational__c))
        ) {
            System.debug('### Account Id ' + a.Id + ' matches all conditions');
            recordTypeOkAccountsIdSet.add(a.Id);
        } else {
            System.debug('### Account Id ' + a.Id + ' does not match conditions');
            System.debug('### Condition 1 (RecordTypeId): ' + 
                (a.RecordTypeId == Label.CPT_RecordTypeId_CompteClient || a.RecordTypeId == Label.ACC_RecordTypeId_CompteProspect));
            System.debug('### Condition 2 (TypeIdentifiantNational__c): ' + 
                (a.TypeIdentifiantNational__c != Label.CPT_TypeIdentifiantNational_Creation));
            System.debug('### Condition 3 (DB_DUNS_Number__c): ' + 
                (!String.isBlank(a.DB_DUNS_Number__c)));
            System.debug('### Condition 4 (IdentifiantNational__c): ' + 
                (!String.isBlank(a.IdentifiantNational__c)));
        }
    }

    System.debug('### recordTypeOkAccountsIdSet size: ' + recordTypeOkAccountsIdSet.size());
    System.debug('### recordTypeOkAccountsIdSet contents: ' + recordTypeOkAccountsIdSet);

    if (recordTypeOkAccountsIdSet.size() > 0) {
        System.debug('### After Insert - Calling AllianzWebServiceRest.validateCompanyForTrigger');
        AllianzWebServiceRest.validateCompanyForTrigger(recordTypeOkAccountsIdSet);
    } else {
        System.debug('### No accounts met the conditions for AllianzWebServiceRest.validateCompanyForTrigger');
    }
}