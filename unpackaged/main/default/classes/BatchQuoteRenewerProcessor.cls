/**
 * Created by 4C on 03/03/2022.
 */

global class BatchQuoteRenewerProcessor implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {

    //data for batch job by date
    public Date renewDate;
    //data for unique contract processing
    public String contractId;
    public String ctNumber;
    public String userId;

    global BatchQuoteRenewerProcessor(Date searchDate) {
        this.renewDate = searchDate;
    }

    global BatchQuoteRenewerProcessor() {
        this.renewDate = Date.today();
    }

    global BatchQuoteRenewerProcessor(String contractId, String ctNumber, String userId) {
        this.contractId = contractId;
        this.ctNumber = ctNumber;
        this.userId = userId;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('Batch Contract renew start');

        //Query to select contracts matching conditions with related records RT
        String query;

        for (Contract c : [
                SELECT Id,
                        ContractNumber,
                        StartDate,
                        ContractTerm,
                        EndDate
                FROM Contract
                WHERE Status <> 'Résilié'
                AND SBQQ__Opportunity__r.Type_de_Location__c = 'Longue durée'
                AND Tech_RenewedContract__c = FALSE]) {
            System.debug('contract found for check: ');
            System.debug(c);
        }

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

        QuoteRenewer.runRenewalCalloutAndScheduleEvent(scope, false);
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('Batch Contract renew end');
    }

}