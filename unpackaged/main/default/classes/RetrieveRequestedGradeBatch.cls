global class RetrieveRequestedGradeBatch implements Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts {

    Map<String, Map<String, String>> gradeByCompanyId = new Map<String, Map<String, String>>();
    global Iterable<String> start(Database.BatchableContext BC) {
        System.Debug('>>>> VCC agrement Batch Start start <<<<');
        gradeByCompanyId.putAll(AllianzWebServiceRest.getLastUpdatedGrade(AllianzWebServiceRest.getNewAccessToken(), System.Label.Business_Unit_Code, System.Label.PolicyId));
        List<String> companyIdList = new List<String>(gradeByCompanyId.keySet());
        return companyIdList;
    }

    global void execute(Database.BatchableContext BC, List<String> scope) {
        System.Debug('>>>> Retrieve requested grade Batch Start Execute <<<<');
        System.debug(scope);
        if(gradeByCompanyId.size() > 0) {
            List<Account> accsToUpdate = new List<Account>();
            List<Account> accs = [SELECT CotationPF__c, DateCotationPF__c, IDEulerHermes__c, Statut_du_grade__c FROM Account WHERE IDEulerHermes__c IN: scope];

            for(Account acc : accs) {
                if(gradeByCompanyId.containsKey(acc.IDEulerHermes__c)){
                    Map<String, String> gradeInformationMap = (Map<String, String>)gradeByCompanyId.get(acc.IDEulerHermes__c);
                    acc.CotationPF__c = Decimal.valueOf(gradeInformationMap.get('grade'));
                    acc.DateCotationPF__c = Date.valueOf(gradeInformationMap.get('lastUpdateDate'));
                    acc.Statut_du_grade__c = 'Processed';
                    accsToUpdate.add(acc);
                }
            }
            if(accsToUpdate.size() > 0) {
                update accsToUpdate;
            }
        }
    }

    global void finish(Database.BatchableContext BC) {
    
    }
}