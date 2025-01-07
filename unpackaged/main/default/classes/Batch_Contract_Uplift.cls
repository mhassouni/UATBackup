global class Batch_Contract_Uplift implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{
    

    Date todayDate; //Variable to store today's date
    Boolean sendEmail; //If set to true -> send logs files in email
    List<String> logs; // Variable to store logs

    public Batch_Contract_Uplift(Boolean doSendEmail){
        sendEmail = doSendEmail;
        logs = new List<String> ();
        todayDate = Date.Today();
    }
    
	global Database.QueryLocator start(Database.BatchableContext bc) {
        //Get contracts where nextdateuplift is today (Batch starts everyday) and eligible for uplift
        String notEligibile = 'Pas d\'indexation';
        return Database.getQueryLocator('SELECT Id , Legal_Entity__c , Legal_Entity__r.Update_Rate_Frequency__c , Uplift_Mode__c , Next_Date_Uplift__c , Negociated_Rate__c, SBQQ__Order__c FROM Contract Where Next_Date_Uplift__c =: todayDate and Uplift_Mode__c != :notEligibile order by Legal_Entity__r.name , contract.Legal_Entity__r.Update_Rate_Frequency__c');
    }

    global void execute(Database.BatchableContext bc, List<SObject> scope){
        
        List<Contract> contracts = (List<Contract>) scope; //current scope contracts
        Map<Id , Decimal> RTAByOrder = new Map<Id , Decimal>(); // Rate To Apply By Order
        Set<String> entities = new Set<String>(); //List of entities of contracts in scope
        Map<Id , List<Uplift_Rate__c>>  upliftRatesByEntity = new Map<Id , List<Uplift_Rate__c>>(); // Map rate To Apply With Entity
        Decimal actualRateToApply; // Temp variable
        Decimal previousRateToApply; // Temp variable
        Decimal rateToApply; // Temp variable
        List<SBQQ__Quote__c> quotes; // Temp variable
        List<Date> startDates = new List<Date>();//List to store start dates of periods that concern contracts in scope: Example: if contracts has as legal entity mensuelle with M3 so this list must contains the date 01/03/2020 et 01/03/2021

        if(sendEmail) logs.add('*** , Processing...');
        system.debug('*** Batch_Contract_Uplift >> Processing...');

        try{
        //Get UpliftRates By Entities
        	//Get all related legal entities
            for(Contract contract : contracts){
                entities.add(contract.Legal_Entity__c);
            }

            //Get Start Dates of Each leganEntity 
            AggregateResult[] groupedRates = [Select max(TECH_Period_Date__c) maxDate From Uplift_Rate__c Where Legal_Entity__c In :entities And TECH_Period_Date__c <= :todayDate group by Legal_Entity__c , Legal_Entity__r.Update_Rate_Frequency__c];
            
            for (AggregateResult ar : groupedRates)  {
                startDates.add(Date.valueOf(ar.get('maxDate')));
                startDates.add((Date.valueOf(ar.get('maxDate'))).addYears(-1));
            }
            	
			if(sendEmail) logs.add('*** , startDates: '+startDates);            
            system.debug('*** Batch_Contract_Uplift >> startDates: '+startDates);
            
            //Get associated upliftRates
            List<Uplift_Rate__c> upliftRates = [Select Id , Index__c , Index_Year__c , Index_Period__c , Legal_Entity__c From Uplift_Rate__c Where Legal_Entity__c In :entities And TECH_Period_Date__c In :startDates order by TECH_Period_Date__c desc];
            //Set upliftRatesByEntity Map : 
            for(Uplift_Rate__c upliftRate : upliftRates){
                if(!upliftRatesByEntity.containskey(upliftRate.Legal_Entity__c)){
                    upliftRatesByEntity.put(upliftRate.Legal_Entity__c , new List<Uplift_Rate__c>());
                }
                upliftRatesByEntity.get(upliftRate.Legal_Entity__c).add(upliftRate);
            }
            
            if(sendEmail) logs.add('*** , upliftRatesByEntity: '+upliftRatesByEntity);
            system.debug('*** Batch_Contract_Uplift >> upliftRatesByEntity: '+upliftRatesByEntity);

        }catch(Exception exc){
            if(sendEmail) logs.add('An exception is thrown while getting UpliftRates : , '+exc.getMessage());
            system.debug('An exception is thrown: '+exc.getMessage());
        }
        
        for(Contract contract : contracts){
            try{
                //1. Calculate actual & previous rate to apply
                actualRateToApply = null;
                previousRateToApply = null;
                rateToApply = null; 

                if(upliftRatesByEntity.get(contract.Legal_Entity__c) != null){
                    for(Uplift_Rate__c upliftRate : upliftRatesByEntity.get(contract.Legal_Entity__c)){
                        //for each legal entity we have only 2 rates, first is for year N, second for year N-1
                        if(actualRateToApply == null ){
                            actualRateToApply = upliftRate.Index__c;
                        }
                        else if(previousRateToApply == null){
                            previousRateToApply = upliftRate.Index__c;
                        }
                    }
                }
                
                if(sendEmail) logs.add(contract.Id + ' , previousRateToApply: '+previousRateToApply);
                if(sendEmail) logs.add(contract.Id + ' , actualRateToApply: '+actualRateToApply);

                system.debug('*** Batch_Contract_Uplift >> previousRateToApply: '+previousRateToApply);
                system.debug('*** Batch_Contract_Uplift >> actualRateToApply: '+actualRateToApply);

                if(previousRateToApply != null && actualRateToApply != null && previousRateToApply < actualRateToApply){
                    //2. Calculate rate to apply
                    rateToApply = actualRateToApply / previousRateToApply;
                    
                    if(contract.Uplift_Mode__c == 'Pourcentage fixe négocié'){
                        rateToApply = (rateToApply - 1) < (contract.Negociated_Rate__c / 100) ? rateToApply : (contract.Negociated_Rate__c / 100) + 1;
                    }
                    else if(contract.Uplift_Mode__c == 'Pourcentage de l\'indice négocié'){
                        rateToApply = ((rateToApply - 1) * (contract.Negociated_Rate__c  / 100)) + 1 ;
                    }

                    logs.add(contract.Id + ' , rateToApply: '+rateToApply);
                    system.debug('*** Batch_Contract_Uplift >> rateToApply: '+rateToApply);

                    RTAByOrder.put(contract.SBQQ__Order__c , rateToApply);
                }
            }
            catch(Exception exc){
                if(sendEmail) logs.add('An exception is thrown while calculating uplift for '+ contract.Id +': , '+exc.getMessage());
                system.debug('An exception is thrown while calculating uplift for '+ contract.Id +': , '+exc.getMessage()); 
            }    
        } 
        
        try{
            Map<Id , Decimal> priceTiersByOrderItem = new Map<Id , Decimal>();
            
            //Get related orderProducts to current contract that are eligible to uplift
            Map<Id , OrderItem> orderProducts = new Map<Id , OrderItem> ([Select Id From OrderItem Where OrderId In :RTAByOrder.keySet() And Uplift_Eligible__c = true]);
			
            if(sendEmail) logs.add(orderProducts.keySet().size() + ' orderProducts are retreived: ' + orderProducts.keySet());
            system.debug('*** Batch_Contract_Uplift >> '+ orderProducts.keySet().size() +' orderProducts are retreived: ' + orderProducts.keySet());
            
            
            //Get usageSummaries related to orderProducts and blng__SummaryStartDate__c > todayDate
            List<blng__UsageSummary__c> usageSummaries = [
                    SELECT
                            Id ,
                            blng__AppliedUnitPrice__c ,
                            blng__UnitPrice__c ,
                            blng__OrderProduct__r.OrderId,
                            blng__OrderProduct__r.SBQQ__Subscription__c
                    FROM blng__UsageSummary__c
                    WHERE blng__OrderProduct__c IN :orderProducts.keySet()
                    AND blng__SummaryStartDate__c >= :todayDate
            ];
            
            if(sendEmail) logs.add(usageSummaries.size() + ' usageSummaries are retreived ');
            system.debug('*** Batch_Contract_Uplift >> '+ usageSummaries.size() +' usageSummaries are retreived ');
			
            //Get related priceTiers
            List<SBQQ__PriceTier__c> priceTiers = [Select Id , SBQQ__PriceSchedule__r.SBQQ__OrderProduct__c , SBQQ__Price__c from SBQQ__PriceTier__c where SBQQ__PriceSchedule__r.SBQQ__OrderProduct__c IN :orderProducts.keySet()];
			
            if(sendEmail) logs.add(priceTiers.size() + ' priceTiers are retreived ');
            system.debug('*** Batch_Contract_Uplift >> '+ priceTiers.size() +' priceTiers are retreived ');
            
            //build priceTiersByOrderItem Map
            for(SBQQ__PriceTier__c priceTier : priceTiers){
                
                if(!priceTiersByOrderItem.containsKey(priceTier.SBQQ__PriceSchedule__r.SBQQ__OrderProduct__c) && priceTier.SBQQ__Price__c != null && priceTier.SBQQ__Price__c != 0){
                    priceTiersByOrderItem.put(priceTier.SBQQ__PriceSchedule__r.SBQQ__OrderProduct__c , priceTier.SBQQ__Price__c);
                    
                    if(sendEmail) logs.add('(' + priceTier.SBQQ__PriceSchedule__r.SBQQ__OrderProduct__c+ ' , ' + priceTier.SBQQ__Price__c + ') is added to priceTiersByOrderItem');
                    system.debug('*** Batch_Contract_Uplift >> ('+ priceTier.SBQQ__PriceSchedule__r.SBQQ__OrderProduct__c+ ' , ' + priceTier.SBQQ__Price__c + ') is added to priceTiersByOrderItem');
                }
                	
            }

            Map<Id, SBQQ__Subscription__c> subsToUpdate = new Map<Id, SBQQ__Subscription__c>();
            //calculate blng__AppliedUnitPrice__c of each usageSummary
            for(blng__UsageSummary__c usageSummary : usageSummaries){
                if(priceTiersByOrderItem.containsKey(usageSummary.blng__OrderProduct__c)){
                    usageSummary.blng__AppliedUnitPrice__c = (usageSummary.blng__AppliedUnitPrice__c == null || usageSummary.blng__AppliedUnitPrice__c == 0) ? priceTiersByOrderItem.get(usageSummary.blng__OrderProduct__c) * RTAByOrder.get(usageSummary.blng__OrderProduct__r.OrderId) : usageSummary.blng__AppliedUnitPrice__c * RTAByOrder.get(usageSummary.blng__OrderProduct__r.OrderId); 
                }
                else{
                    usageSummary.blng__AppliedUnitPrice__c = (usageSummary.blng__AppliedUnitPrice__c == null || usageSummary.blng__AppliedUnitPrice__c == 0) ? usageSummary.blng__UnitPrice__c * RTAByOrder.get(usageSummary.blng__OrderProduct__r.OrderId) : usageSummary.blng__AppliedUnitPrice__c * RTAByOrder.get(usageSummary.blng__OrderProduct__r.OrderId);
                }

                //Update du renewal Price sur la sub
                System.debug('Will now update subsription ' + usageSummary.blng__OrderProduct__r.SBQQ__Subscription__c);
                if (usageSummary.blng__OrderProduct__r.SBQQ__Subscription__c != null) {
                    System.debug('with renewal value ' + usageSummary.blng__AppliedUnitPrice__c);
                    if (!subsToUpdate.containsKey(usageSummary.blng__OrderProduct__r.SBQQ__Subscription__c)) {
                        SBQQ__Subscription__c sub = new SBQQ__Subscription__c(Id = usageSummary.blng__OrderProduct__r.SBQQ__Subscription__c, SBQQ__RenewalPrice__c = usageSummary.blng__AppliedUnitPrice__c);
                        subsToUpdate.put(usageSummary.blng__OrderProduct__r.SBQQ__Subscription__c, sub);
                    } else {
                        SBQQ__Subscription__c sub = subsToUpdate.get(usageSummary.blng__OrderProduct__r.SBQQ__Subscription__c);
                        sub.SBQQ__RenewalPrice__c = usageSummary.blng__AppliedUnitPrice__c;
                        subsToUpdate.put(usageSummary.blng__OrderProduct__r.SBQQ__Subscription__c, sub);
                    }
                }

                if(sendEmail) logs.add('blng__AppliedUnitPrice__c of record ' + usageSummary.Id + ' is updated with ' + usageSummary.blng__AppliedUnitPrice__c + ' : usageSummary.blng__AppliedUnitPrice__c = ' + usageSummary.blng__AppliedUnitPrice__c + ' and priceTier.SBQQ__Price__c = ' + priceTiersByOrderItem.get(usageSummary.blng__OrderProduct__c) + ' and RTA = ' +  RTAByOrder.get(usageSummary.blng__OrderProduct__r.OrderId) + ' usageSummary.blng__AppliedUnitPrice__c = '+usageSummary.blng__AppliedUnitPrice__c );
                system.debug('*** Batch_Contract_Uplift >> blng__AppliedUnitPrice__c of record '  + usageSummary.Id + ' is updated with ' + usageSummary.blng__AppliedUnitPrice__c + ' : usageSummary.blng__AppliedUnitPrice__c = ' + usageSummary.blng__AppliedUnitPrice__c + ' and priceTier.SBQQ__Price__c = ' + priceTiersByOrderItem.get(usageSummary.blng__OrderProduct__c) + ' and RTA = ' +  RTAByOrder.get(usageSummary.blng__OrderProduct__r.OrderId) + ' usageSummary.blng__AppliedUnitPrice__c = '+usageSummary.blng__AppliedUnitPrice__c );
            }
            update usageSummaries;
            if (!subsToUpdate.isEmpty()) {
                update subsToUpdate.values();
            }
            
            if(sendEmail) logs.add(usageSummaries.size() +' usageSummaries are updated');            
            system.debug(usageSummaries.size() +' usageSummaries are updated');
            
            //Update next date uplift
            Date nextDate = todayDate.addYears(1); 
            for(Contract contract : contracts){
                //nextDate = contract.Legal_Entity__r.Update_Rate_Frequency__c == 'Mensuelle' ? contract.Next_Date_Uplift__c.addMonths(1) : ( contract.Legal_Entity__r.Update_Rate_Frequency__c == 'Trimestrielle' ? contract.Next_Date_Uplift__c.addMonths(3) : 
                contract.Next_Date_Uplift__c = nextDate;
            }
            update contracts;
            
            if(sendEmail) logs.add(contracts.size() +' contracts are updated');            
            system.debug(contracts.size() +' contracts are updated');

        }
        catch(Exception exc){
            if(sendEmail) logs.add('An exception is thrown while updating Contracts / UsageSummaries: , '+exc.getMessage());
            system.debug('An exception is thrown while updating Contracts / UsageSummaries: , '+exc.getMessage());
        }
              
    }

    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [SELECT id, ApexClassId,
                       JobItemsProcessed, TotalJobItems,
                       NumberOfErrors, CreatedBy.Email
                       FROM AsyncApexJob
                       WHERE id = :bc.getJobId()];
        if(sendEmail) {
            String body = 'Your batch job '
             + 'Batch_Contract_Uplift '
             + 'has finished. \n' 
             + 'Here is your logs ';
            
            // Creating the CSV file
            String finalstr = 'Context , Log \n';
            String subject = 'Batch_Contract_Uplift - Logs';
            String attName = 'Batch_Contract_Uplift Logs.csv';
            for(String line  : logs){
                finalstr = finalstr +line+'\n';
            } 
 
            // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
            
            // Create the email attachment    
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(attName);
            efa.setBody(Blob.valueOf(finalstr));
            
            // Sets the paramaters of the email
            email.setSubject( subject ); 
            //email.setToAddresses( new String[] {a.CreatedBy.Email} );

            email.setToAddresses( new String[] {Label.Master_Email_Logs_For_Contract_Uplift_Batch } );
            
            if(!String.isEmpty(Label.Email_Logs_For_Contract_Uplift_Batch))
            email.setCcAddresses(Label.Email_Logs_For_Contract_Uplift_Batch.split(','));
            
            email.setPlainTextBody( body );
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
 
            // Sends the email
            Messaging.SendEmailResult [] r = 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
        
    }

    
}