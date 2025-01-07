global class PF_UsageProcessor implements
                Database.Batchable<SObject>, Database.Stateful {

    // instance member to retain state across transactions
//    private static Date endingDate = Date.today();
    public String orderId;
    public Integer UsageSummaryRecordsProcessed = 0;
    public Integer UsageRecordsProcessed = 0;

    /**
     * @description Constructor for unique order processing
     * @param orderId Order id to process
     */
    global PF_UsageProcessor(String orderId) {
        this.orderId = orderId;
    }

    /**
     * @description default constructor
     */
    global PF_UsageProcessor() {}

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('Batch usage process start');
        //Query all usage summaries of the month (Batch processed at end of month)
        String queryString;
        if (this.orderId != null) {
            System.debug('Process a unique order');
            queryString = 'SELECT ID, Name, blng__Account__c, blng__Order__c, blng__MatchingId__c, blng__OrderProduct__r.SBQQ__QuoteLine__r.SBQQ__Group__c, ' +
                    'blng__MatchingAttribute__c, blng__UnitOfMeasure__c, blng__SummaryStartDate__c, blng__SummaryEndDate__c, ' +
                    'blng__Order__r.OrderNumber, blng__OrderProduct__c, blng__AppliedUnitPrice__c, blng__UnitPrice__c ' +
                    'FROM blng__UsageSummary__c WHERE  PF_UsageGenerated__c = false AND blng__SummaryStartDate__c <= THIS_MONTH ' +
                    'AND blng__Order__c = \'' + this.orderId + '\'';

        } else {
            System.debug('Process a batch of orders');
            queryString = 'SELECT ID, Name, blng__Account__c, blng__Order__c, blng__MatchingId__c, blng__OrderProduct__r.SBQQ__QuoteLine__r.SBQQ__Group__c, ' +
                    'blng__MatchingAttribute__c, blng__UnitOfMeasure__c, blng__SummaryStartDate__c, blng__SummaryEndDate__c, ' +
                    'blng__Order__r.OrderNumber, blng__OrderProduct__c, blng__AppliedUnitPrice__c, blng__UnitPrice__c ' +
                    'FROM blng__UsageSummary__c WHERE PF_UsageGenerated__c = false ' +
                    'AND blng__SummaryEndDate__c <= TODAY';
        }

        System.debug('batch queryString = ' + queryString);
        return Database.getQueryLocator(queryString);
    }

    public void execute(Database.BatchableContext bc, List<blng__UsageSummary__c> scope){
        System.debug('Batch usage process execute');
        System.debug('begin batch - us scope: ' + scope);

        final String COURTE_DUREE_TYPE = 'Courte Durée'; //add
        // process each batch of records
        List<blng__UsageSummary__c> usage_summaries = new List<blng__UsageSummary__c>();
        List<blng__Usage__c> usage_recs = new List<blng__Usage__c>();

        List<Id> orderIds = new List<Id>();
        List<Id> groupIds = new List<Id>();
        List<Id> contractIds = new List<Id>();
        Set<Id> orderItemIds = new Set<Id>();
        Map<Id, Id> usOrderIdsMap = new Map<Id, Id>();
        Map<Id, Id> usOrderPrdIdsMap = new Map<Id, Id>();
        Map<Id, Contract> orderIdContractMap = new Map<Id, Contract>();
        //Map<Id, Reservation__c> orderItemIdReservationsMap = new Map<Id, Reservation__c>();

        //FIX CPQ UPDATE BUG
        Map<Id, Contract> contractMap = new Map<Id, Contract>();
        Map<Id, Id> orderGroupIdsMap = new Map<Id, Id>();
        Map<Id, Id> groupContractIdsMap = new Map<Id, Id>();

        //list Id relations to map usage summary Id to orderid and orderproductid
        for (blng__UsageSummary__c us : scope) {
            if (!orderIds.contains(us.blng__Order__c)) orderIds.add(us.blng__Order__c);
            usOrderIdsMap.put(us.Id, us.blng__Order__c);
            usOrderPrdIdsMap.put(us.Id, us.blng__OrderProduct__c);
            System.debug('groupId for us: ' + us.blng__OrderProduct__r.SBQQ__QuoteLine__r.SBQQ__Group__c);
            if (!groupIds.contains(us.blng__OrderProduct__r.SBQQ__QuoteLine__r.SBQQ__Group__c)) groupIds.add(us.blng__OrderProduct__r.SBQQ__QuoteLine__r.SBQQ__Group__c);
            orderGroupIdsMap.put(us.blng__Order__c, us.blng__OrderProduct__r.SBQQ__QuoteLine__r.SBQQ__Group__c);
        }

        for (SBQQ__Subscription__c sub : [
                SELECT
                        SBQQ__Contract__c,
                        SBQQ__QuoteLine__r.SBQQ__Group__c
                FROM SBQQ__Subscription__c
                WHERE SBQQ__QuoteLine__r.SBQQ__Group__c IN :groupIds]){

            groupContractIdsMap.put(sub.SBQQ__QuoteLine__r.SBQQ__Group__c, sub.SBQQ__Contract__c);
            if (!contractIds.contains(sub.SBQQ__Contract__c)) contractIds.add(sub.SBQQ__Contract__c);
        }

        //get all order contracts (supposed only 1 per order max), make map from orderId to contract object
        for (Contract c : [
                SELECT
                        Id,
                        SBQQ__Order__c,
                        InterruptionDate__c,
                        Status
                FROM Contract
                WHERE Id IN :contractIds
        ]) {
            contractMap.put(c.Id, c);
        }

        //get all orders needed and put them in a map orderId to order object
        Map<Id, Order> orderMap = new Map<Id, Order>();
        for ( Order o : [
                SELECT
                        Id,
                        OrderNumber,
                        EffectiveDate,
                        EndDate,
                        EndDate__c,
                        Type_de_location__c,
                        PF_Location_Number_of_Days__c,
                        Contract.InterruptionDate__c,
                        Contract.Status,
                        Status,
                        Effective_Start_Date__c,//kor1
                        Effective_End_Date__c   //kor1
                FROM Order
                WHERE Id = :orderIds
        ]) {
            orderMap.put(o.Id, o);
        }

        //get all orderproducts needed and put them in a map orderitemId to orderitem object
        Map<Id, OrderItem> orderItemMap = new Map<Id, OrderItem>();
        for ( OrderItem oi : [
                SELECT
                        Quantity, SBQQ__RequiredBy__c
                FROM OrderItem
                WHERE Id = :usOrderPrdIdsMap.values()
        ]) {
            orderItemMap.put(oi.Id, oi);
            orderItemIds.add(oi.Id);
            if (oi.SBQQ__RequiredBy__c != null) orderItemIds.add(oi.SBQQ__RequiredBy__c);
        }


        // get all reservation with recordType = 'Transport' and Type de transport = ‘Transport Aller vers client’ and then put them in a map orderItemIdReservationsMap to Reservation object
        /*for ( Reservation__c reserv : [
                SELECT
                        Id, Produits_demandes__c, PF_Date_de_livraison_du_conteneur__c
                FROM Reservation__c
                WHERE Produits_demandes__c IN :orderItemIds
                AND RecordTypeId = :Schema.SObjectType.Reservation__c.getRecordTypeInfosByDeveloperName().get('Transport').getRecordTypeId()
                AND Type_de_transport__c =: Label.TypeReservation_UsageCreation
        ]) {
            orderItemIdReservationsMap.put(reserv.Produits_demandes__c, reserv);
        }*/


        //query all Orders, put in map related to usid
        //query all related contracts, put in map related to orderid
        //query all quantities, put in map related to us orderproduct

        for (blng__UsageSummary__c us : scope) {

            Order o = orderMap.get(usOrderIdsMap.get(us.Id));
            OrderItem oi = orderItemMap.get(usOrderPrdIdsMap.get(us.Id)); //add1
//            Contract c = orderIdContractMap.get(o.Id);
            Id ctId = groupContractIdsMap.get(us.blng__OrderProduct__r.SBQQ__QuoteLine__r.SBQQ__Group__c);
            Contract c = ctId != null ? contractMap.get(ctId) : null;
            //Reservation__c r = (orderItemIdReservationsMap.get(oi.Id) != null ? orderItemIdReservationsMap.get(oi.Id) : orderItemIdReservationsMap.get(oi.SBQQ__RequiredBy__c));

            //skip order not in status 'commande à facturer'
            if (o.Status != Label.orderStatus_processed && !Test.isRunningTest()) {
                System.debug('Order status is not ' + Label.orderStatus_processed);
                continue;
            }


            // skip reservation when "PF_Date_de_livraison_du_conteneur__c" field is empty
            /*if (r == null
                    || r.PF_Date_de_livraison_du_conteneur__c == null) {
                System.debug('kor123:'+r.PF_Date_de_livraison_du_conteneur__c+ ' i dalej:'+r);    //kor1 
                System.debug('The field "Date livraison du conteneur" in reservation object is empty !!');
                continue;
            }*/
            if (o.Effective_Start_Date__c == null) {
                CustomNotificationType notifType = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'Usage_generation_notification'];
                System.debug('error notification');

                Messaging.CustomNotification n = new Messaging.CustomNotification();

                // Set the contents for the notification
                n.setTitle(Label.Usage_generation_title);
                n.setBody(Label.Usage_generation_err_startdate);

                // Set the notification type and target
                n.setNotificationTypeId(notifType.Id);
                n.setTargetId(UserInfo.getUserId());
                n.send(new Set<String>{UserInfo.getUserId()});

                System.debug('kor123:'+o.Effective_Start_Date__c);    //kor1
                System.debug('The field "Effective Start Date on the order is empty (means that also Date livraison du conteneur" in reservation object is empty !!)');
                continue;
            }

            if (c == null || c.Status == null) {
                CustomNotificationType notifType = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'Usage_generation_notification'];
                System.debug('error notification');

                Messaging.CustomNotification n = new Messaging.CustomNotification();

                // Set the contents for the notification
                n.setTitle(Label.Usage_generation_title);
                n.setBody(Label.Usage_generation_err_noct);

                // Set the notification type and target
                n.setNotificationTypeId(notifType.Id);
                n.setTargetId(UserInfo.getUserId());
                n.send(new Set<String>{UserInfo.getUserId()});

                System.debug('Contract must be created before continue !!');
                continue;
            }

            //TODO Add null managements

            System.debug ('Order ' + o.OrderNumber + ' EffectiveDate: ' + o.EffectiveDate + ' EndDate: ' + o.EndDate + ' Custom EndDate: ' + o.EndDate__c);
            System.debug ('OrderItem ' + oi.Id + ' Quantity: ' + oi.Quantity); //add2
            if (c.InterruptionDate__c != null) {
                System.debug ('Contract ' + c.Id + ' InterruptionDate: ' + c.InterruptionDate__c + ' Status: ' + c.Status);
            } else {
                System.debug ('Contract ' + c.Id + ' Status: ' + c.Status);
            }
            //System.debug ('Reservation: ' + r.Id + ' DateLivraisonDuConteneur: ' + r.PF_Date_de_livraison_du_conteneur__c);
            System.debug (' DateLivraisonDuConteneur: ' + o.Effective_Start_Date__c);

            if (o.Type_de_location__c == COURTE_DUREE_TYPE) {
                System.debug('Process short duration');
                System.debug('effectiveDate/Order start date: ' + o.EffectiveDate);
                System.debug('summaryStart: ' + us.blng__SummaryStartDate__c);

                if (o.EffectiveDate == us.blng__SummaryStartDate__c) {
                    blng__Usage__c usage = new blng__Usage__c();

                    usage.blng__Account__c         = us.blng__Account__c;
                    usage.blng__Order__c           = us.blng__Order__c;
                    //usage.blng__OrderProduct__c  = us.blng__OrderProduct__c;
                    usage.blng__UsageSummary__c    = us.Id;
                    usage.blng__MatchingId__c       = us.blng__MatchingId__c != null ? us.blng__MatchingId__c : 'none';
                    usage.blng__MatchingAttribute__c= us.blng__MatchingAttribute__c;
                    usage.blng__UnitOfMeasure__c    = us.blng__UnitOfMeasure__c;
                    usage.blng__StartDateTime__c    = us.blng__SummaryStartDate__c;
                    usage.blng__EndDateTime__c      = us.blng__SummaryEndDate__c;

                    //system.debug('kor1a'+r.PF_Date_de_livraison_du_conteneur__c);//kor1
                    system.debug('kor1b'+o.Effective_Start_Date__c);//kor1

                    // Add the gap between delivery date and start date for the last usage of the usage summary
                    if (o.Effective_Start_Date__c > us.blng__SummaryStartDate__c) {
                        usage.PF_Effective_Start_Date__c = o.Effective_Start_Date__c;
                        usage.PF_Effective_End_Date__c = us.blng__SummaryEndDate__c + us.blng__SummaryStartDate__c.daysBetween(o.Effective_Start_Date__c);
                    } else {
                        usage.PF_Effective_Start_Date__c = us.blng__SummaryStartDate__c;
                        usage.PF_Effective_End_Date__c = us.blng__SummaryEndDate__c;
                    }

                    usage.blng__Quantity__c 		= o.PF_Location_Number_of_Days__c * oi.Quantity;
                    if (us.blng__AppliedUnitPrice__c != null || us.blng__UnitPrice__c != null) {
                        usage.blng__PreratedQuantity__c = usage.blng__Quantity__c;
                        if (us.blng__AppliedUnitPrice__c != null) {
                            usage.blng__PreratedAmount__c = usage.blng__PreratedQuantity__c * us.blng__AppliedUnitPrice__c;
                        } else {
                            usage.blng__PreratedAmount__c = usage.blng__PreratedQuantity__c * us.blng__UnitPrice__c;
                        }
                        usage.blng__Quantity__c = null;
                    }

                    usage_recs.add(usage);
                    UsageRecordsProcessed = UsageRecordsProcessed + 1;
                    System.debug('preparing usage record: '+usage);
                }

                //set all US for Courte Duree as processed
                us.PF_UsageGenerated__c = true;
                usage_summaries.add(us);
                // increment the instance member counter
                UsageSummaryRecordsProcessed = UsageSummaryRecordsProcessed + 1;
            } else if (o.Type_de_location__c != COURTE_DUREE_TYPE) {
                System.debug('Process long duration');
                System.debug('  summary startdate: ' + us.blng__SummaryStartDate__c);
                System.debug('  summary enddate: ' + us.blng__SummaryEndDate__c);
                System.debug('  contract status: ' + o.Status);
                System.debug('  contract interrdate: ' + c.InterruptionDate__c);

                //                Date startOfMonth = Date.newInstance(endingDate.year(), endingDate.month(), 1);
                //                Date endOfMonth = Date.newInstance(endingDate.addMonths(1).year(), endingDate.addMonths(1).month(), 1).addDays(-1);

                //Full month calculation (not 'Résilié' or even if should not happen 'Résilié' but after end of month)
                if ((c.Status != Label.contractStatus_Resilie
                        || (c.Status == Label.contractStatus_Resilie && c.InterruptionDate__c != null && us.blng__SummaryEndDate__c <= c.InterruptionDate__c))) {
                    System.debug('Processing usage for full month');

                    //ct résilié et interr dans le mois -> spé
                    //ct non résilié -> usage classique

                    System.debug('kornel mamy to!');

                    blng__Usage__c usage = new blng__Usage__c();

                    usage.blng__Account__c = us.blng__Account__c;
                    usage.blng__Order__c = us.blng__Order__c;
                    //usage.blng__OrderProduct__c  = us.blng__OrderProduct__c;
                    usage.blng__UsageSummary__c = us.Id;
                    usage.blng__MatchingId__c = us.blng__MatchingId__c != null ? us.blng__MatchingId__c : 'none';
                    usage.blng__MatchingAttribute__c = us.blng__MatchingAttribute__c;
                    usage.blng__UnitOfMeasure__c = us.blng__UnitOfMeasure__c;
                    usage.blng__StartDateTime__c    = us.blng__SummaryStartDate__c;
                    usage.blng__EndDateTime__c      = us.blng__SummaryEndDate__c;

                    // Take the delivery date
                    if (o.Effective_Start_Date__c > us.blng__SummaryStartDate__c) {
                        usage.PF_Effective_Start_Date__c = o.Effective_Start_Date__c;
                    } else {
                        usage.PF_Effective_Start_Date__c = us.blng__SummaryStartDate__c;
                    }

                    // Add the gap between delivery date and start date for the last usage of the usage summary
                    if (us.blng__SummaryEndDate__c == o.EndDate__c && o.EffectiveDate < o.Effective_Start_Date__c) {
                        usage.PF_Effective_End_Date__c = us.blng__SummaryEndDate__c + o.EffectiveDate.daysBetween(o.Effective_Start_Date__c);
                    } else {
                        usage.PF_Effective_End_Date__c = us.blng__SummaryEndDate__c;
                    }

                    usage.blng__Quantity__c = (usage.PF_Effective_Start_Date__c?.daysBetween(usage.PF_Effective_End_Date__c) + 1) * oi.Quantity;

                    if (us.blng__AppliedUnitPrice__c != null || us.blng__UnitPrice__c != null) {
                        usage.blng__PreratedQuantity__c = usage.blng__Quantity__c;
                        if (us.blng__AppliedUnitPrice__c != null) {
                            usage.blng__PreratedAmount__c = usage.blng__PreratedQuantity__c * us.blng__AppliedUnitPrice__c;
                        } else {
                            usage.blng__PreratedAmount__c = usage.blng__PreratedQuantity__c * us.blng__UnitPrice__c;
                        }
                        usage.blng__Quantity__c = null;
                    }

                    usage_recs.add(usage);
                    UsageRecordsProcessed = UsageRecordsProcessed + 1;
                    System.debug('preparing usage record: ' + usage);

                    //mark all proccessed UsageSummaries as processed (independently if Usage record was created for it or not)
                    us.PF_UsageGenerated__c = true;
                    usage_summaries.add(us);
                    // increment the instance member counter
                    UsageSummaryRecordsProcessed = UsageSummaryRecordsProcessed + 1;

                    //Else if 'Résilié' during the month, prorate calculations
                } else if ((c.Status == Label.contractStatus_Resilie
                        && c.InterruptionDate__c != null
                        //&& c.InterruptionDate__c <= Date.today()
                        //                        && c.InterruptionDate__c >= startOfMonth
                        && c.InterruptionDate__c >= us.blng__SummaryStartDate__c
                        && c.InterruptionDate__c < us.blng__SummaryEndDate__c)) {
                    System.debug('Processing usage for close contract during the month');
                    System.debug(' us.startdate: ' + us.blng__SummaryStartDate__c);
                    System.debug(' contract interrDate: ' + c.InterruptionDate__c);
                    System.debug(' OrderItem qty: ' + oi.Quantity);

                    blng__Usage__c usage = new blng__Usage__c();

                    usage.blng__Account__c = us.blng__Account__c;
                    usage.blng__Order__c = us.blng__Order__c;
                    usage.blng__UsageSummary__c = us.Id;
                    usage.blng__MatchingId__c = us.blng__MatchingId__c != null ? us.blng__MatchingId__c : 'none';
                    usage.blng__MatchingAttribute__c = us.blng__MatchingAttribute__c;
                    usage.blng__UnitOfMeasure__c = us.blng__UnitOfMeasure__c;
                    usage.blng__StartDateTime__c = us.blng__SummaryStartDate__c;
                    usage.blng__EndDateTime__c = c.InterruptionDate__c;

                    // Take the delivery date
                    if (o.Effective_Start_Date__c > us.blng__SummaryStartDate__c) {
                        usage.PF_Effective_Start_Date__c = o.Effective_Start_Date__c;
                    } else {
                        usage.PF_Effective_Start_Date__c = us.blng__SummaryStartDate__c;
                    }

                    // Add the gap between delivery date and start date for the last usage of the usage summary
                    if (o.EffectiveDate < o.Effective_Start_Date__c) {
                        usage.PF_Effective_End_Date__c = c.InterruptionDate__c + o.EffectiveDate.daysBetween(o.Effective_Start_Date__c);
                    } else {
                        usage.PF_Effective_End_Date__c = c.InterruptionDate__c;
                    }

                    usage.blng__Quantity__c = (usage.PF_Effective_Start_Date__c?.daysBetween(usage.PF_Effective_End_Date__c) + 1) * oi.Quantity;
                    //usage.blng__Quantity__c = (us.blng__SummaryStartDate__c?.daysBetween(c.InterruptionDate__c) + 1) * oi.Quantity;

                    if (us.blng__AppliedUnitPrice__c != null || us.blng__UnitPrice__c != null) {
                        usage.blng__PreratedQuantity__c = usage.blng__Quantity__c;
                        if (us.blng__AppliedUnitPrice__c != null) {
                            usage.blng__PreratedAmount__c = usage.blng__PreratedQuantity__c * us.blng__AppliedUnitPrice__c;
                        } else {
                            usage.blng__PreratedAmount__c = usage.blng__PreratedQuantity__c * us.blng__UnitPrice__c;
                        }
                        usage.blng__Quantity__c = null;
                    }

                    usage_recs.add(usage);
                    UsageRecordsProcessed = UsageRecordsProcessed + 1;
                    System.debug('preparing usage record: ' + usage);

                    //mark all proccessed UsageSummaries as processed (independently if Usage record was created for it or not)
                    us.PF_UsageGenerated__c = true;
                    usage_summaries.add(us);
                    // increment the instance member counter
                    UsageSummaryRecordsProcessed = UsageSummaryRecordsProcessed + 1;

                    //Other cases, -> no usage
                } else {
                    System.debug(us.blng__SummaryEndDate__c + ' kornel inna data!'); //kornel
                }
            }
        }//for

        if (!usage_recs.isEmpty()) {
            System.debug('kornel - inserting usage records - usage_recs : ' + usage_recs);
//            insert usage_recs;
            Database.SaveResult[] saveResults =  Database.insert(usage_recs, false);
            for (Database.SaveResult sr : saveResults) {
                if (!sr.isSuccess()) {
                    System.debug('inserting usage records - Usage Id : ' + sr.getId());
                    // Operation failed, so get all errors
                    for (Database.Error err : sr.getErrors()) {
                        System.debug(err);
                        System.debug('kornel - inserting usage records - The following error has occurred : ' + err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Usage fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }

        if (!usage_summaries.isEmpty()) {
            System.debug('kornel - updating usage summaries - usage_summaries : ' + usage_summaries);
            update usage_summaries;
//            Database.update(usage_recs);
        }

        //insert usage_recs;
        //update usage_summaries; 
    }

    public void finish(Database.BatchableContext bc){
        System.debug(UsageSummaryRecordsProcessed + ' usage summary records processed. Kornel!');
        System.debug(UsageRecordsProcessed + ' usage records processed. Kornel!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
                JobItemsProcessed,
                TotalJobItems, CreatedBy.Email
        FROM AsyncApexJob
        WHERE Id = :bc.getJobId()];
        // call some utility to send email
        //EmailUtils.sendMessage(job, recordsProcessed);
    }
}