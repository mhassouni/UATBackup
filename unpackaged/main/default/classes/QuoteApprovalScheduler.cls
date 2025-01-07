/**
 * Created by 4C on 18/03/2022.
 */

global class QuoteApprovalScheduler implements Schedulable {

    public QuoteRenewer.QuoteRenewerOutputContext approvalContext;

    public QuoteApprovalScheduler(QuoteRenewer.QuoteRenewerOutputContext ctx) {
        this.approvalContext = ctx;
    }

    global void execute(SchedulableContext sc) {
        if (approvalContext != null && !approvalContext.quoteIds.isEmpty()) {
            String quoteIds = '';
            String quoteContractIds = '';
            String ct2notify = '';

            for (String qid : approvalContext.quoteIds) {
                quoteIds += qid + ',';
            }
            if (quoteIds.endsWith(',')) quoteIds = quoteIds.substring(0,quoteIds.length() - 1);

            for (String qId : approvalContext.quoteIdOldContractIdMap.keySet()) {
                quoteContractIds += qId + '#' + approvalContext.quoteIdOldContractIdMap.get(qId) + ',';
                if (approvalContext.contractToNotify.containsKey(approvalContext.quoteIdOldContractIdMap.get(qId))) {
                    ct2notify += approvalContext.quoteIdOldContractIdMap.get(qId) + '#' +
                            approvalContext.contractToNotify.get(approvalContext.quoteIdOldContractIdMap.get(qId)) + ',';
                }
            }
            if (quoteContractIds.endsWith(',')) quoteContractIds = quoteContractIds.substring(0,quoteContractIds.length() - 1);
            if (ct2notify.endsWith(',')) ct2notify = ct2notify.substring(0,ct2notify.length() - 1);

            //publish platform event to approve quotes and generate orders
            List<ContractRenewerEvent__e> events = new List<ContractRenewerEvent__e>();
            events.add(new ContractRenewerEvent__e(quoteIds__c = quoteIds,
                    quoteContractIdsMap__c = quoteContractIds,
                    contractsToNotify__c = ct2notify));
            List<Database.SaveResult> pubResults = EventBus.publish(events);

            for (Database.SaveResult sr : pubResults) {
                if (sr.isSuccess()) {
                    System.debug('Successfully published event.');
                } else {
                    String message = 'Contract Renewer Event error: ';
                    for(Database.Error err : sr.getErrors()) {
                        message += '\\r' + err.message;
                    }
                    QuoteRenewer.RenewerException ex = new QuoteRenewer.RenewerException();
                    ex.setMessage(message);
                    throw ex;
                }
            }
        }
    }
}