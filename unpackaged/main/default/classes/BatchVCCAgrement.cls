global class BatchVCCAgrement implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {

    Map<String, Map<String, Object>> coversByIdEuler = new Map<String, Map<String, Object>>();

    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.Debug('>>>> VCC agrement Batch Start start <<<<');
        
        String query = 'SELECT policyId__c FROM PolicyId_Legal_Entity__c';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<PolicyId_Legal_Entity__c> scope) {
        System.Debug('>>>> VCC agrement Batch Start Execute <<<<');
        List<String> policiesId = new List<String>();
        for(PolicyId_Legal_Entity__c policy : scope) {
            policiesId.add(policy.policyId__c.substringAfter('A'));
        }
        List<PolicyId_Legal_Entity__c> policies = PolicyId_Legal_Entity__c.getAll().values();
        coversByIdEuler.putAll(AllianzWebServiceRest.getLastUpdatedAgrement(AllianzWebServiceRest.getNewAccessToken(), policies));
    }

    global void finish(Database.BatchableContext BC) {
        System.Debug('>>>> VCC agrement Batch Start Finish <<<<');
        Map<String, String> legalEntityToPolicyIdMap = new Map<String,String>();
        List<PolicyId_Legal_Entity__c> policies = PolicyId_Legal_Entity__c.getAll().values();
        for(PolicyId_Legal_Entity__c ple : policies) {
            legalEntityToPolicyIdMap.put(ple.Legal_Entity__c, ple.policyId__c.substringAfter('A'));
        }
        if(coversByIdEuler.size() > 0) {
            List<SalesAreaData__c> sadsToUpdate = new List<SalesAreaData__c>();
            List<SalesAreaData__c> sads = [SELECT Id, Agrement__c, Montant_agrement__c, Date_agrement__c, Account__r.IDEulerHermes__c, Account__r.Policy_Id__c, SalesArea__r.LegalEntity__r.Name, CurrencyIsoCode FROM SalesAreaData__c WHERE  Account__r.IDEulerHermes__c IN: coversByIdEuler.keySet()];
            for(SalesAreaData__c sad : sads) {
                if(coversByIdEuler.containsKey(sad.Account__r.IDEulerHermes__c)){
                    Map<String, Object> coverInformationMap = ((Map<String, Map<String, Object>>)coversByIdEuler.get(sad.Account__r.IDEulerHermes__c)).get(legalEntityToPolicyIdMap.get(sad.SalesArea__r.LegalEntity__r.Name));
                    if(coverInformationMap !=null) {
                        sad.Agrement__c = true;
                        sad.Montant_agrement__c = sad.CurrencyIsoCode != 'EUR' ? AllianzWebServiceRest.convertCurrencyWithApexCode(sad.CurrencyIsoCode,(Decimal)coverInformationMap.get('totalAmount')) : (Decimal)coverInformationMap.get('totalAmount');
                        sad.Date_agrement__c = Date.valueOf((String)coverInformationMap.get('lastUpdateDate'));
                        sadsToUpdate.add(sad);
                    }
                }
            }
            if(sadsToUpdate.size() > 0) {
                update sadsToUpdate;
            }
        }
    }
}