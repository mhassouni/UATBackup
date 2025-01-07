/**
 * Created by 4C on 18/03/2022.
 */

trigger ContractRenewerEventTrigger on ContractRenewerEvent__e (after insert) {

    System.debug('Event trigger for renewed quote approval');

    List<Contract> ctsToUpdate = new List<Contract>();
    List<Opportunity> oppToUpdate = new List<Opportunity>();
    List<SBQQ__Quote__c> quoteToUpdate = new List<SBQQ__Quote__c>();
    Map<Contract, String> ctNotif = new Map<Contract, String>();

    //Replay context to reschedule quotes not calculated
    QuoteRenewer.QuoteRenewerOutputContext replayCtx = new QuoteRenewer.QuoteRenewerOutputContext();
    replayCtx.quoteIds = new List<String>();
    replayCtx.quoteIdOldContractIdMap = new Map<String, String>();
    replayCtx.quoteIdUserIdMap = new Map<String, String>();
    replayCtx.contractToNotify = new Map<String, String>();
    String[] ids;

    //Loop on platform events
    for (ContractRenewerEvent__e event : Trigger.new) {
        List<String> result = event.quoteIds__c.split(',');
        Map<String, String> contractIdUserIdMap = new Map<String, String>();

        if (String.isNotBlank(event.contractsToNotify__c)) {
            for (String pair : event.contractsToNotify__c.split(',')) {
                String[] kp = pair.split('#');
                contractIdUserIdMap.put(kp[0], kp[1]);
            }
        }
        //Extract quote Ids and quote-contract Ids map from platform event fields
        Map<Id, Id> newQuoteIdOldContractIdMap = new Map<Id, Id>();
        for (String quotContratPair : event.quoteContractIdsMap__c.split(',')) {
             ids = quotContratPair.split('#');
            newQuoteIdOldContractIdMap.put(ids[0], ids[1]);
        }
        //Load event contracts
        Map<Id, Contract> contractsMap = new Map<Id, Contract>([
                SELECT
                        Id,
                        Tech_RenewedContract__c,
                        Status,
                        SBQQ__Opportunity__r.RecordTypeId,
                        ContractNumber,
                        Extension_Date__c,
                        EndDate,
                        Effective_Start_Date__c,
                        Effective_End_Date__c,
                        SBQQ__Quote__r.Type_de_location__c,
                        SBQQ__Quote__r.RecordTypeId,
                        SBQQ__Opportunity__r.PaysRegionPF__c,
                        SBQQ__Opportunity__r.AgencePF__c,
                        SBQQ__Opportunity__r.Type_Location__c,
                        SBQQ__Opportunity__r.TypeProduits__c,
                        OwnerId
                FROM Contract
                WHERE Id IN :newQuoteIdOldContractIdMap.values()]
        );
        
       
        //Contract ContractRecord = [SELECT Id, SBQQ__Quote__r.RecordTypeId FROM Contract WHERE Id = :ids[1] ];

        //Loop over event quotes
        for (SBQQ__Quote__c q : [
                SELECT Id,
                        SBQQ__StartDate__c,
                        SBQQ__EndDate__c,
                        SBQQ__Status__c,
                        SBQQ__Ordered__c,
                        SBQQ__Opportunity2__c,
                        SBQQ__Account__r.Name,
                        SBQQ__Uncalculated__c,
                        Tech_After_Calculate__c,
                        RecordTypeId,
                        Si_autres_precisez__c,
                        Champs_obligatoires__c,
            			//Quote_Type__c,
            			//Type_de_location__c,
            			Autres_observations__c
                FROM SBQQ__Quote__c
                WHERE Id IN :result 
        ]) {
            System.debug('Quote data: ');
            System.debug('    startdate: ' + q.SBQQ__StartDate__c);
            System.debug('    enddate: ' + q.SBQQ__EndDate__c);
            System.debug('    status: ' + q.SBQQ__Status__c);
            System.debug('    ordered: ' + q.SBQQ__Ordered__c);
            System.debug('    uncalculated: ' + q.SBQQ__Uncalculated__c);
            System.debug('    techaftercalculate: ' + q.Tech_After_Calculate__c);
            //q.RecordTypeId = '0120Q0000006F7eQAE';
            //q.Si_autres_precisez__c	= 1;
           //q.Champs_obligatoires__c = 	'ContractRecord ID ' + ids[0] + ' SBQQ__Quote__r RecordTypeId ' + ContractRecord.SBQQ__Quote__r.RecordTypeId  + ' result[0] ' + result[0] ;
           //q.Champs_obligatoires__c = 	'ID 1 ' + ids[0] + 'ids 2 '  + ids[1] ;
           //q.RecordTypeId = ContractRecord.SBQQ__Quote__r.RecordTypeId;
           //quoteToUpdate.add(q);

           //update quoteToUpdate;
            Contract c = contractsMap.containsKey(newQuoteIdOldContractIdMap.get(q.Id)) ? contractsMap.get(newQuoteIdOldContractIdMap.get(q.Id)) : null;

            //If contract is not found, skip the quote
            if (c == null) {
                System.debug('Contract not found skip the quote');
                continue;
            }

            System.debug('    ct effective startdate: ' + c.Effective_Start_Date__c);
            System.debug('    ct effective enddate: ' + c.Effective_End_Date__c);

            //If quote is uncalculated, enqueue it for next batch and skip it from current process
//            if (!q.Tech_After_Calculate__c || q.SBQQ__Uncalculated__c) {
            if (!q.Tech_After_Calculate__c || (!Test.isRunningTest() && q.SBQQ__Uncalculated__c)) {
                System.debug('Quote not calculated yet, enqueue for further process');
                replayCtx.quoteIds.add(q.Id);
                replayCtx.quoteIdOldContractIdMap.put(q.Id, c.Id);
                if (contractIdUserIdMap.keySet().contains(c.Id)) replayCtx.contractToNotify.put(c.Id, contractIdUserIdMap.get(c.Id));
                continue;
            }

            //If quote status is 'Quote Sent', we can approved the quote with Ordered to true to generate Order
            if (q.SBQQ__Status__c == 'Quote Sent') {
                System.debug('Set quote to approved');
                if (!Test.isRunningTest()) {
                    q.SBQQ__Status__c = 'Approved';
                    q.SBQQ__Ordered__c = true;
                }
                //q.RecordTypeId = ContractRecord.SBQQ__Quote__r.RecordTypeId;
                //q.Champs_obligatoires__c = 	'ID 1 ' + ids[0] + 'ids 2 '  + ids[1] ;

                quoteToUpdate.add(q);

                c.Tech_RenewedContract__c = true;
                c.Status = 'Contrat Prolongé';
                ctsToUpdate.add(c);

                if (contractIdUserIdMap.keySet().contains(c.Id)) 
                {
                    ctNotif.put(c, contractIdUserIdMap.get(c.Id));
                }
            } else {
                //Quote status was draft, pass it to 'Quote Sent' and update start/end dates to fire price rules
                System.debug('Update opty ' + q.SBQQ__Opportunity2__c + ' type to PRG');
                //HMS
                Opportunity op = new Opportunity(
                        Id = q.SBQQ__Opportunity2__c,
                        TypeOpportunite__c = 'PRG',
                        RecordTypeId = c.SBQQ__Opportunity__r.RecordTypeId,
                    	PaysRegionPF__c	 = c.SBQQ__Opportunity__r.PaysRegionPF__c,
                    	AgencePF__c	= c.SBQQ__Opportunity__r.AgencePF__c,
                    	Type_Location__c = c.SBQQ__Opportunity__r.Type_Location__c,
                    	TypeProduits__c	 = c.SBQQ__Opportunity__r.TypeProduits__c,
                        Name = 'PRG_' + q.SBQQ__Account__r.Name + '_' + c.ContractNumber
                );
                oppToUpdate.add(op);

                System.debug('Update quote ' + q.Id + ' dates and status with ct ');
                System.debug(c);
                if (c.Extension_Date__c != null) {
                    q.SBQQ__EndDate__c = c.Extension_Date__c;
                } else {
                    q.SBQQ__EndDate__c = c.Effective_End_Date__c != null ? c.Effective_End_Date__c.addMonths(12) : c.EndDate.addMonths(12);
                }
                //HMS
                //q.Type_de_location__c = c.SBQQ__Quote__r.Type_de_location__c;
                //q.Quote_Type__c = c.SBQQ__Quote__r.Quote_Type__c;
                q.SBQQ__StartDate__c = c.Effective_End_Date__c != null ? c.Effective_End_Date__c.addDays(1) : c.EndDate.addDays(1);
                //q.RecordTypeId = ContractRecord.SBQQ__Quote__r.RecordTypeId;
                //q.Champs_obligatoires__c = 	'ID 1 ' + ids[0] + 'ids 2 '  + ids[1] ;

                
               

                if (!Test.isRunningTest()) {
                    System.debug('Status to Quote Sent');
                    q.Tech_approval_unlock__c = true;
                    q.SBQQ__Status__c = 'Quote Sent';
                }
                q.RecordTypeId = c.SBQQ__Quote__r.RecordTypeId;
                quoteToUpdate.add(q);

                //set quote to reschedule event for last update (Approved)
                replayCtx.quoteIds.add(q.Id);
                replayCtx.quoteIdOldContractIdMap.put(q.Id, c.Id);
                if (contractIdUserIdMap.keySet().contains(c.Id)) replayCtx.contractToNotify.put(c.Id, contractIdUserIdMap.get(c.Id));
            }

        }
    }

    if (!oppToUpdate.isEmpty()) {
        update oppToUpdate;
    }
    if (!quoteToUpdate.isEmpty()) {
        update quoteToUpdate;
    }
    if (!ctsToUpdate.isEmpty()) {
        update ctsToUpdate;
    }


    //Send notification to contract owner if needed
    if (!ctNotif.isEmpty()) {
        CustomNotificationType notifType = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'QuoteRenewNotification'];
        System.debug('End of work notification');

        for (Contract c : ctNotif.keySet()) {
            Messaging.CustomNotification n = new Messaging.CustomNotification();

            // Set the contents for the notification
            n.setTitle(Label.QuoteRenewNotification_Title);
            n.setBody(Label.QuoteRenewNotification_End_Body);

            // Set the notification type and target
            n.setNotificationTypeId(notifType.Id);
            n.setTargetId(c.Id);
            n.send(new Set<String>{
                    ctNotif.get(c)
            });
        }
    }

    //reschedule uncalculated quotes
    if (replayCtx != null && !replayCtx.quoteIds.isEmpty()) {
        QuoteApprovalScheduler sc = new QuoteApprovalScheduler(replayCtx);

        //reschedule event in 30sec to let CPQ calculate the quote
        Datetime sysTime = System.now().addSeconds(30);
        String cronStr = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        String jobID = System.schedule('Schedulable Quote Approval processor ' + replayCtx.quoteIds.get(0) + ' ' + System.currentTimeMillis(), cronStr, sc);

        System.debug('Next batch processing scheduled ' + jobID);
    }

}