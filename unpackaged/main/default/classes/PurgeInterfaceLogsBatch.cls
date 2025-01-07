global class PurgeInterfaceLogsBatch implements Database.Batchable<SObject>, Database.Stateful {
    private Integer currentChain;
    private Integer scopeSize;
    private Boolean isTestRun;

    public PurgeInterfaceLogsBatch(Integer chain, Boolean isTestRun) {
        this.currentChain = chain;
        this.scopeSize = 200; // Default scope size
        this.isTestRun = isTestRun;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String numberOfDays = Label.PurgeInterfaceLogsBatch_NumberOfDays;
        String qry;
        if (currentChain == 1) {
            qry = 'SELECT Id FROM LogInterfaces__c WHERE CreatedDate < LAST_N_DAYS:' + numberOfDays;
        } else if (currentChain == 2) {
            qry = 'SELECT Id FROM Interface_Response__c WHERE CreatedDate < LAST_N_DAYS:' + numberOfDays;
        } else if (currentChain == 3) {
            qry = 'SELECT Id FROM Interface_monitoring__c WHERE CreatedDate < LAST_N_DAYS:' + numberOfDays;
        } else {
            qry = '';
        }
        return Database.getQueryLocator(qry);
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        delete scope;
    }

    global void finish(Database.BatchableContext BC) {
        if (!isTestRun && currentChain < 3) {
            PurgeInterfaceLogsBatch nextBatch = new PurgeInterfaceLogsBatch(currentChain + 1, isTestRun);
            Database.executeBatch(nextBatch, scopeSize);
        } else {
            System.debug('Purge batch job finished for all objects.');
        }
    }
}