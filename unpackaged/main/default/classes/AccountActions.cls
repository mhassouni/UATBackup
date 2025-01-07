public with sharing class AccountActions {
    public static boolean isFirstRun = TRUE;
    public static void updateContact(List<Account> newAccountList, List<Account> oldAccountList, Map<ID, Account> newAccountsMap , Map<ID, Account> oldAccountsMap) {
        List<Account> accountSAPIdToUpdateList = new List<Account>();
        Set<Id> accountChildIdsToQuery = new Set<Id>();
        Set<Id> accountParentIdsToQuery = new Set<Id>();
        for (Account newAccount : newAccountList) {
            if(newAccount.Tech_SAP_Id__c != (oldAccountsMap.get(newAccount.Id)).Tech_SAP_Id__c) {
                if(newAccount.RecordTypeId == Label.CPT_RecordTypeId_CompteClient) {
                    accountChildIdsToQuery.add(newAccount.Id);
                    System.debug('accountChildIdsToQuery : ' + accountChildIdsToQuery);
                } else if(newAccount.RecordTypeId == Label.CPT_RecordTypeId_CompteSite) {
                    accountParentIdsToQuery.add(newAccount.ParentId);
                    System.debug('accountParentIdsToQuery : ' + accountParentIdsToQuery);
                }
            }
        }
        if(!accountChildIdsToQuery.isEmpty()) {
            Map<Id, Account> AccountsChildToUpdateMap = new Map<Id, Account>();
            for (Account acc : [SELECT Id, Tech_SAP_Id__c, ParentId FROM Account WHERE ParentId IN :accountChildIdsToQuery]) {
                AccountsChildToUpdateMap.put(acc.ParentId, acc);
            }

            for (Account newAccount : newAccountList) {
                Account acc = AccountsChildToUpdateMap.get(newAccount.Id);
                if(acc != null) {
                    acc.Tech_SAP_Id__c = newAccount.Tech_SAP_Id__c;
                    accountSAPIdToUpdateList.add(acc);
                }
            }
        }

        if(!accountParentIdsToQuery.isEmpty()) {
            Map<Id, Account> AccountsParentToUpdateMap = new Map<Id, Account>();
            for (Account acc : [SELECT Id, Tech_SAP_Id__c FROM Account WHERE Id IN :accountParentIdsToQuery]) {
                AccountsParentToUpdateMap.put(acc.Id, acc);
            }

            for (Account newAccount : newAccountList) {
                Account acc = AccountsParentToUpdateMap.get(newAccount.ParentId);
                if(acc != null) {
                    acc.Tech_SAP_Id__c = newAccount.Tech_SAP_Id__c;
                    accountSAPIdToUpdateList.add(acc);
                }
            }
        }
        if(accountSAPIdToUpdateList.size() > 0) {
            isFirstRun = FALSE;
            update accountSAPIdToUpdateList;
        }
    }
}