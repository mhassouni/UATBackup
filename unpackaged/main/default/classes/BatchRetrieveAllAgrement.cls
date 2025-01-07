global class BatchRetrieveAllAgrement implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {

    
    //List<SalesAreaData__c> sadsToUpdate = new List<SalesAreaData__c>();

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, IDEulerHermes__c FROM Account WHERE IDEulerHermes__c != null AND (NOT IDEulerHermes__c LIKE \'%.%\')';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) {
        Map<String, Object> agrementByIdEuler = new Map<String, Object>();
        // List<PolicyId_Legal_Entity__c> policies = [SELECT policyId__c FROM PolicyId_Legal_Entity__c];
        List<String> policiesId = new List<String>();
        List<String> idEulerList = new List<String>();
        for(Account account : scope) {
            idEulerList.add(account.IDEulerHermes__c);
        }
        System.debug('<< IDEULER >> ' + idEulerList);
        // for(PolicyId_Legal_Entity__c policy : policies) {
        //     policiesId.add(policy.policyId__c.substringAfter('A'));
        // }
        // System.debug('<< policiesId >> ' + policiesId);
        Map<String, String> legalEntityToPolicyIdMap = new Map<String,String>();
        List<PolicyId_Legal_Entity__c> policies = PolicyId_Legal_Entity__c.getAll().values();
        for(PolicyId_Legal_Entity__c ple : policies) {
            legalEntityToPolicyIdMap.put(ple.Legal_Entity__c, ple.policyId__c.substringAfter('A'));
        }
        agrementByIdEuler.putAll(AllianzWebServiceRest.getAllAgrement(AllianzWebServiceRest.getNewAccessToken(), policies, idEulerList));
        if(agrementByIdEuler.size() > 0) {
            List<SalesAreaData__c> sadsToUpdate = new List<SalesAreaData__c>();
            Set<String> idEulerSet = agrementByIdEuler.keySet();
            
            System.debug('#Yecard idEulerSet size left : '+ idEulerSet.size());
            List<SalesAreaData__c> sads = [SELECT Id, Agrement__c, Montant_agrement__c, Date_agrement__c, Account__r.IDEulerHermes__c, Account__r.Policy_Id__c, SalesArea__r.LegalEntity__r.Name, CurrencyIsoCode FROM SalesAreaData__c WHERE Account__r.IDEulerHermes__c IN:idEulerSet Order By Account__r.IDEulerHermes__c];
            System.debug('sads size fetched : ' + sads.size());
            if(sads.size()> 0) {
                System.debug('last sad.Account__r.IDEulerHermes__c fetched : ' + sads[0].Account__r.IDEulerHermes__c);
                System.debug('last sad.Account__r.IDEulerHermes__c fetched : ' + sads[sads.size()-1].Account__r.IDEulerHermes__c);
            }
            for(SalesAreaData__c sad : sads) {
                if(agrementByIdEuler.containsKey(sad.Account__r.IDEulerHermes__c)){
                    Map<String, Object> coverInformationMap = ((Map<String, Map<String, Object>>)agrementByIdEuler.get(sad.Account__r.IDEulerHermes__c)).get(legalEntityToPolicyIdMap.get(sad.SalesArea__r.LegalEntity__r.Name));
                    if(coverInformationMap !=null) {
                        sad.Agrement__c = true;
                        sad.Montant_agrement__c = sad.CurrencyIsoCode != 'EUR' ? AllianzWebServiceRest.convertCurrencyWithApexCode(sad.CurrencyIsoCode,(Decimal)coverInformationMap.get('totalAmount')) : (Decimal)coverInformationMap.get('totalAmount');
                        sad.Date_agrement__c = coverInformationMap.get('lastUpdateDate') != null ? Date.valueOf((String)coverInformationMap.get('lastUpdateDate')) : null;
                        sadsToUpdate.add(sad);
                    }
                }
            }
            if(sadsToUpdate.size() > 0) {
                update sadsToUpdate;
            }
        }
    }

    global void finish(Database.BatchableContext BC) {
        System.Debug('>>>> VCC agrement Batch Start Finish <<<<');
    }
}