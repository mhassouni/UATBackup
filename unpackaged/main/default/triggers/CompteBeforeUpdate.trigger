trigger CompteBeforeUpdate on Account (before update) {
//Interface 
    AccountTriggerHandler handler = new AccountTriggerHandler(Trigger.isExecuting, Trigger.size);

    System.debug('Test dans le trigger');
    //Mise à jour du SAP Id des comptes C et S
    if(UserInfo.getUserName().contains('talend.integration@') && AccountActions.isFirstRun) {
        handler.OnBeforeUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
    }
    
    //Validation Allianz
    System.debug('### Trigger CompteAfterUpdate fired');
    // Validation Euler Hermes
    if(Bypass.canTrigger('AP09Compte') ) {
        System.debug('### Bypass.canTrigger(\'AP09Compte\') = ' + Bypass.canTrigger('AP09Compte'));
        System.debug('### AP09Compte.isFirstRun = ' + AP09Compte.isFirstRun);

        Map<String, Account> oldAccountsMap = new Map<String, Account>();
        for(Account a : trigger.old) {
            oldAccountsMap.put(a.Id, a);
        }
        System.debug('### Old Accounts Map: ' + oldAccountsMap);

        Set<Id> accountsOkIdSet = new Set<Id>();

        for(Account a : trigger.new) {
            Account oldAccount = oldAccountsMap.get(a.Id);

            System.debug('### Checking account Id: ' + a.Id);
            System.debug('### RecordTypeId: ' + a.RecordTypeId);
            System.debug('### DB_DUNS_Number__c: ' + a.DB_DUNS_Number__c);
            System.debug('### IdentifiantNational__c: ' + a.IdentifiantNational__c);

            if (
                (a.RecordTypeId == Label.CPT_RecordTypeId_CompteClient || a.RecordTypeId == Label.ACC_RecordTypeId_CompteProspect) &&
                (a.TypeIdentifiantNational__c != Label.CPT_TypeIdentifiantNational_Creation) &&
                (!String.isBlank(a.DB_DUNS_Number__c)) && 
                (!String.isBlank(a.IdentifiantNational__c))   &&
                (
                    a.ParentId != oldAccount.ParentId ||
                    a.PaysRegionPF__c != oldAccount.PaysRegionPF__c ||
                    a.DB_DUNS_Number__c != oldAccount.DB_DUNS_Number__c ||
                    a.AgencePF__c != oldAccount.AgencePF__c ||
                    a.TypeIdentifiantNational__c != oldAccount.TypeIdentifiantNational__c ||
                    !(a.IdentifiantNational__c != null ? a.IdentifiantNational__c : '').equals(oldAccount.IdentifiantNational__c != null ? oldAccount.IdentifiantNational__c : '') ||
                    (!(a.Ligne1Exploitation__c != null ? a.Ligne1Exploitation__c : '').equals(oldAccount.Ligne1Exploitation__c != null ? oldAccount.Ligne1Exploitation__c : '') ||
                    !(a.Ligne2Exploitation__c != null ? a.Ligne2Exploitation__c : '').equals(oldAccount.Ligne2Exploitation__c != null ? oldAccount.Ligne2Exploitation__c : '') ||
                    !(a.Ligne3Exploitation__c != null ? a.Ligne3Exploitation__c : '').equals(oldAccount.Ligne3Exploitation__c != null ? oldAccount.Ligne3Exploitation__c : '') ||
                    !(a.Ligne4Exploitation__c != null ? a.Ligne4Exploitation__c : '').equals(oldAccount.Ligne4Exploitation__c != null ? oldAccount.Ligne4Exploitation__c : '') ||
                    !(a.CodePostalExploitation__c != null ? a.CodePostalExploitation__c : '').equals(oldAccount.CodePostalExploitation__c != null ? oldAccount.CodePostalExploitation__c : '') ||
                    !(a.VilleExploitation__c != null ? a.VilleExploitation__c : '').equals(oldAccount.VilleExploitation__c != null ? oldAccount.VilleExploitation__c : '') ||
                    !(a.PaysExploitation__c != null ? a.PaysExploitation__c : '').equals(oldAccount.PaysExploitation__c != null ? oldAccount.PaysExploitation__c : ''))
                ) 
            ) {
                accountsOkIdSet.add(a.Id);
            }
        }

        System.debug('### accountsOkIdSet size: ' + accountsOkIdSet.size());
        System.debug('### accountsOkIdSet contents: ' + accountsOkIdSet);

        if(accountsOkIdSet.size() > 0) {
            System.debug('### Calling AP09Compte.processCreation');
            if(!System.isFuture() && !System.isBatch()){
    		//AP09Compte.processCreation(accountsOkIdSet, FALSE);
            //AP09Compte.isFirstRun = FALSE;
            AllianzWebServiceRest.validateCompanyForTrigger(accountsOkIdSet);
}	
            
           
        } else {
            System.debug('### No accounts meet the criteria for AP09Compte.processCreation');
        }
    } else {
        System.debug('### Trigger bypassed or not the first run');
    }
}