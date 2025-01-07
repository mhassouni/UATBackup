/**
 * Created by 4C on 06/04/2022.
 */

/**
 * @description Preprocessing batch that ensure renewing contracte have TypeOpportunite__c set to 'PRG'
 * before chaining to the effective renew processing
 */
global class BatchQuoteRenewerPreprocessor implements Database.Batchable<SObject>, Database.Stateful {

    //data for batch job by date
    public Date renewDate;
    //data for unique contract processing
    public String contractId;
    public String ctNumber;
    public String userId;

    global BatchQuoteRenewerPreprocessor(Date searchDate) {
        this.renewDate = searchDate;
    }

    global BatchQuoteRenewerPreprocessor() {
        this.renewDate = Date.today();
    }

    global BatchQuoteRenewerPreprocessor(String contractId, String ctNumber, String userId) {
        this.contractId = contractId;
        this.ctNumber = ctNumber;
        this.userId = userId;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('Batch Contract renew check start');

        //Query to select contracts matching conditions with related records RT
        String query;

        //Can be used for a batch of contracts or a specific contract
        if (String.isBlank(contractId) && renewDate != null) {
            query = 'SELECT Id, ContractNumber, EndDate, Extension_Date__c, TypeOpportunite__c, ' +
                    'SBQQ__Opportunity__r.RecordTypeId, SBQQ__Quote__r.RecordTypeId, SBQQ__Quote__r.Type_de_location__c ' +
                    'FROM Contract WHERE EndDate = ' + String.valueOf(this.renewDate).substring(0, 10) +
                    ' AND Status <> \'Résilié\' AND SBQQ__Opportunity__r.Type_de_Location__c = \'Longue durée\' ' +
                    'AND Tech_RenewedContract__c = FALSE';
        } else if (String.isNotBlank(contractId)) {
            query = 'SELECT Id, ContractNumber, ownerId, EndDate, Extension_Date__c, TypeOpportunite__c, ' +
                    'SBQQ__Opportunity__r.RecordTypeId, SBQQ__Quote__r.RecordTypeId, SBQQ__Quote__r.Type_de_location__c ' +
                    'FROM Contract WHERE Id = \'' + this.contractId + '\'';
//                    ' AND Status <> \'Résilié\' AND SBQQ__Opportunity__r.Type_de_Location__c = \'Longue durée\' ' +
//                    'AND Tech_RenewedContract__c = FALSE';
        }

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Contract> scope) {
        System.debug('Batch Contract renew execute');

        //update Contracts TypeOpportunite__c to PRG (needed for the price rules to work)
        List<Contract> ct2Update = new List<Contract>();
        for (Contract c : scope) {
            if (c.TypeOpportunite__c != 'PRG') {
                c.TypeOpportunite__c = 'PRG';
                ct2Update.add(c);
            }
        }

        if (!ct2Update.isEmpty()) {
            //update contracts before processing callouts
            update ct2Update;
        }
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('Batch Contract renew check end, run batch process');

        BatchQuoteRenewerProcessor br;
        if (String.isBlank(contractId) && renewDate != null) {
            br = new BatchQuoteRenewerProcessor(renewDate);
        } else {
            br = new BatchQuoteRenewerProcessor(contractId, ctNumber, userId);
        }

        Database.executeBatch(br, 10);
    }
}