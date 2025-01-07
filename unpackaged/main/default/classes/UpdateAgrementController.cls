public class UpdateAgrementController {

    @AuraEnabled
    public static String updateAgrement(String recordId){
        String successfulUpdate = '';
        String policyId;
        String businessUnitCode;
        Map<String, Object> coversByIdEuler = new Map<String, Object>();
        Map<String, String> legalEntityToPolicyIdMap = new Map<String,String>();
        Map<String, string> businessUnitCodeByLegalEntityMap = new Map<String, String>();
        List<SalesAreaData__c> sadToUpdate = new List<SalesAreaData__c>();

        try {
            Opportunity opp = [SELECT Id, SalesAreaData__c, AccountId FROM Opportunity WHERE Id =: recordId];
            Account acc = [SELECT Id, Pays__c FROM Account WHERE Id =: opp.AccountId];
            if(acc.Pays__c != 'FRANCE') {
                List<SalesAreaData__c> sadList = [SELECT Id, Agrement__c, Montant_agrement__c, Date_agrement__c, Account__r.IDEulerHermes__c, SalesArea__r.LegalEntity__r.Name, CurrencyIsoCode FROM SalesAreaData__c WHERE Account__c =:opp.AccountId];
                List<PolicyId_Legal_Entity__c> tempList = PolicyId_Legal_Entity__c.getAll().values();
                for(PolicyId_Legal_Entity__c ple : tempList) {
                    legalEntityToPolicyIdMap.put(ple.Legal_Entity__c, ple.policyId__c);
                    businessUnitCodeByLegalEntityMap.put(ple.Legal_Entity__c, ple.Business_Unit_Code__c);
                }
                policyId = legalEntityToPolicyIdMap.get(sadList[0].SalesArea__r.LegalEntity__r.Name);
                businessUnitCode = businessUnitCodeByLegalEntityMap.get(sadList[0].SalesArea__r.LegalEntity__r.Name);

                if(policyId != null && policyId != '') {
                    coversByIdEuler.putAll(AllianzWebServiceRest.getCoverInformation(businessUnitCode, policyId.substringAfter('A'), new List<String>{sadList[0].Account__r.IDEulerHermes__c}));
                    if(coversByIdEuler.containsKey(sadList[0].Account__r.IDEulerHermes__c)) {
                        Map<String, Object> coverInformationMap = (Map<String, Object>)coversByIdEuler.get(sadList[0].Account__r.IDEulerHermes__c);
                        for(SalesAreaData__c sad : sadList){
                            if(Date.valueOf((String)coverInformationMap.get('lastUpdateDate')) != sad.Date_agrement__c) {
                                sad.Agrement__c = true;
                                sad.Montant_agrement__c = sad.CurrencyIsoCode != 'EUR' ? AllianzWebServiceRest.convertCurrencyWithApexCode(sad.CurrencyIsoCode,(Decimal)coverInformationMap.get('totalAmount')) : (Decimal)coverInformationMap.get('totalAmount');
                                sad.Date_agrement__c = Date.valueOf((String)coverInformationMap.get('lastUpdateDate'));
                                sadToUpdate.add(sad);
                            } else {
                                successfulUpdate = 'No change';
                            }
                        }
                    } else {
                            successfulUpdate = 'Agrement not found';
                        }
                    } else {
                        successfulUpdate = 'Problem with policyId';
                    }
                    if(!sadToUpdate.isEmpty()) {
                        update sadToUpdate;
                        successfulUpdate = 'Done';
                    }
                return successfulUpdate;
            }
            else {
                SalesAreaData__c sad = [SELECT Id, Agrement__c, Montant_agrement__c, Date_agrement__c, Account__r.IDEulerHermes__c, SalesArea__r.LegalEntity__r.Name, CurrencyIsoCode FROM SalesAreaData__c WHERE Id =:opp.SalesAreaData__c];
                List<PolicyId_Legal_Entity__c> tempList = PolicyId_Legal_Entity__c.getAll().values();
                for(PolicyId_Legal_Entity__c ple : tempList) {
                    legalEntityToPolicyIdMap.put(ple.Legal_Entity__c, ple.policyId__c);
                    businessUnitCodeByLegalEntityMap.put(ple.Legal_Entity__c, ple.Business_Unit_Code__c);
                }
                policyId = legalEntityToPolicyIdMap.get(sad.SalesArea__r.LegalEntity__r.Name);
                businessUnitCode = businessUnitCodeByLegalEntityMap.get(sad.SalesArea__r.LegalEntity__r.Name);

                if(policyId != null && policyId != '') {
                    coversByIdEuler.putAll(AllianzWebServiceRest.getCoverInformation(businessUnitCode, policyId.substringAfter('A'), new List<String>{sad.Account__r.IDEulerHermes__c}));
                    if(coversByIdEuler.containsKey(sad.Account__r.IDEulerHermes__c)) {
                        Map<String, Object> coverInformationMap = (Map<String, Object>)coversByIdEuler.get(sad.Account__r.IDEulerHermes__c);
                        if(Date.valueOf((String)coverInformationMap.get('lastUpdateDate')) != sad.Date_agrement__c) {
                            sad.Agrement__c = true;
                            sad.Montant_agrement__c = sad.CurrencyIsoCode != 'EUR' ? AllianzWebServiceRest.convertCurrencyWithApexCode(sad.CurrencyIsoCode,(Decimal)coverInformationMap.get('totalAmount')) : (Decimal)coverInformationMap.get('totalAmount');
                            sad.Date_agrement__c = Date.valueOf((String)coverInformationMap.get('lastUpdateDate'));
                            update sad;
                            successfulUpdate = 'Done';
                        } else {
                            successfulUpdate = 'No change';
                        }
                    } else {
                        successfulUpdate = 'Agrement not found';
                    }
                } else {
                    successfulUpdate = 'Problem with policyId';
                }
                return successfulUpdate;
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            
            successfulUpdate = 'No Sales Area Data';
            return successfulUpdate;
        }
    }
}