/**
 * Created by 4C on 28/02/2022.
 */

global class QuoteRenewer {

    /**
     * @description Invocable method to use in flows for processing contract renewal
     *
     * @param contracts List of contracts to renew (Id is enough as the method query the needed data)
     */
    @InvocableMethod(Label='Renew contract' Description='Launch renew contract')
    public static void renewContractAction(List<List<Contract>> contracts) {
        System.debug('Renew contract Action start');

        List<String> ctIds = new List<String>();
        List<Contract> ct2Update = new List<Contract>();
        for (Contract c : contracts.get(0)) {
            c.TypeOpportunite__c = 'PRG';
            ct2Update.add(c);
            ctIds.add(c.Id);
        }

        //Set TypeOpportunite__c to PRG for price rules to work on renewal
        update ct2Update;

        //call future method to renew contracts
        futureRenewQuotes(ctIds, true);
        System.debug('Contract renew future in queue');
    }



    /**
     * @description future method to give hand back to user immediately after action started
     * because renew contract process can take long time
     *
     * @param contracts List of contract Ids
     * @param sendNotif True to send user notification at the end of the process
     */
    @Future(Callout=true)
    public static void futureRenewQuotes(List<String> contracts, Boolean sendNotif) {
        System.debug('Quote renewer batch scheduler start');

        List<Contract> cts = [
                SELECT Id,
                        ContractNumber,
                        EndDate,
                        Extension_Date__c,
                        SBQQ__Opportunity__r.RecordTypeId,
                        SBQQ__Quote__r.RecordTypeId,
                        SBQQ__Quote__r.Type_de_location__c,
                        TypeOpportunite__c
                FROM Contract
                WHERE Id IN :contracts
                AND Tech_RenewedContract__c = FALSE
        ];

        runRenewalCalloutAndScheduleEvent(cts, sendNotif);
    }


    /**
     * @description Method usable i batch or quick action to do callouts and publish platform event
     *
     * @param cts List of contracts to renew
     * @param sendNotif True if notification have to be sent after renewal
     */
    public static void runRenewalCalloutAndScheduleEvent(List<Contract> cts, Boolean sendNotif) {
        System.debug('renewalCallOuts start');

        System.debug('launch renew for contracts ');
        System.debug(cts);

        // Process all contracts ending today
        QuoteRenewer.QuoteRenewerOutputContext out = QuoteRenewer.renewContracts(cts);

        //publish event to process quote approval
        if (out != null && !out.quoteIds.isEmpty()) {

            if (sendNotif) {
                for (String qId : out.quoteIdOldContractIdMap.keySet()) {
                    out.contractToNotify.put(out.quoteIdOldContractIdMap.get(qId), UserInfo.getUserId());
                }
            }

            //schedule first event to let enough time to CPQ to calculate the quote
            QuoteApprovalScheduler sc = new QuoteApprovalScheduler(out);

            //reschedule event in 30sec to let CPQ calculate the quote
            Datetime sysTime = System.now().addSeconds(10);
            String cronStr = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
            String jobID = System.schedule('Schedulable Quote Approval processor ' + out.quoteIds.get(0) + ' ' + System.currentTimeMillis(), cronStr, sc);

            System.debug('First platform event batch processing scheduled ' + jobID);
        }
    }


    /**
     * @description Method that renew contract(s) and updates end dates if needed
     * This method can be used by the daily batch or the triggered flow independently
     *
     * @param inputs List of contracts to process. Contracts mandatory data are:
     *  - Id
     *  - EndDate
     *  - ExtensionDate
     *  - SBQQ_Opportunity__r.RecordTypeId
     *  - SBQQ__Quote__r.RecordTypeId
     *
     * @return List of renewed CPQ Quotes
     */
    public static QuoteRenewerOutputContext renewContracts(List<Contract> inputs) {
        System.debug('Renew contracts for inputs:');
        System.debug(inputs);

        QuoteRenewerOutputContext outCtx = new QuoteRenewerOutputContext();
        outCtx.quoteIds = new List<String>();
        outCtx.quoteIdOldContractIdMap = new Map<String, String>();
        outCtx.quoteIdUserIdMap = new Map<String, String>();
        outCtx.contractToNotify = new Map<String, String>();

        for (Contract ct : inputs) {
            QuoteRenewerContext ctx = new QuoteRenewerContext();
            ctx.renewedContracts = new Contract[]{ct};
            ctx.returnOnlyQuoteId = true;
            String jsonContext = JSON.serialize(ctx);

            System.debug('Renew json context: ');
            System.debug(jsonContext);

            try {
                String quotesJSON = SBQQ.ServiceRouter.load('SBQQ.ContractManipulationAPI.ContractRenewer', null, jsonContext);

                System.debug('Service router json result:');
                System.debug(quotesJSON);

                SBQQ__Quote__c[] renewed = (SBQQ__Quote__c[]) JSON.deserialize(quotesJSON, List<SBQQ__Quote__c>.class);
                System.debug('Deserialized quotemodel:');
                System.debug(renewed);

                if (renewed.isEmpty()) {
                    RenewerException ex = new RenewerException();
                    ex.setMessage('Service router has not returned any results');
                    throw ex;
                } else {
                    outCtx.quoteIds.add(renewed[0].Id);
                    outCtx.quoteIdOldContractIdMap.put(renewed[0].Id, ct.Id);
                }
            } catch (Exception e) {
                System.debug('Failed to renew contract: ' + e.getMessage());
                throw e;
            }
        }

        return outCtx;
    }

    /**
     * SBQQ Contract renewer context
     */
    private class QuoteRenewerContext {
        public Id masterContractId;
        public Contract[] renewedContracts;
        public Boolean returnOnlyQuoteId;
    }

    public class QuoteRenewerOutputContext {
        public List<String> quoteIds;
        public Map<String, String> quoteIdOldContractIdMap;
        public Map<String, String> quoteIdUserIdMap;
        public Map<String, String> contractToNotify;
    }

    public class RenewerException extends Exception {}

}