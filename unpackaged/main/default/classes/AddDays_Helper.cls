public class AddDays_Helper {

    public static Map<String, Date> addDays_Order(List<String> RecordIdsList) {
        Map<String, Date> OrderEndDates = new Map<String, Date>();
        List<Order> Orders = [SELECT Id, EndDate__c, StartDate__c, Opportunity.SBQQ__RenewedContract__r.Extension_Date__c, Opportunity.SBQQ__RenewedContract__r.EndDate FROM Order WHERE Id in :RecordIdsList];
        
        if(!Orders.isEmpty()) {
            for (Order ord : Orders) {
                if (ord.Opportunity != null &&
                    ord.Opportunity.SBQQ__RenewedContract__r != null &&
                    ord.Opportunity.SBQQ__RenewedContract__r.EndDate != null) {
                    
                    Date OrderStartDate = ord.Opportunity.SBQQ__RenewedContract__r.EndDate.addDays(1);
                    ord.StartDate__c = OrderStartDate;
                    ord.EndDate__c = ord.Opportunity.SBQQ__RenewedContract__r.Extension_Date__c;
                    OrderEndDates.put(String.valueOf(ord.EndDate__c), ord.EndDate__c);
                }
            }
            update Orders;
        }
        
        return OrderEndDates;
    }

    public static Map<String, Date> addDays_Contract(List<String> RecordIdsList) {
        Map<String, Date> ContractEndDates = new Map<String, Date>();
        List<Contract> Contracts = [SELECT Id, SBQQ__Opportunity__r.SBQQ__RenewedContract__r.EndDate, SBQQ__Opportunity__r.SBQQ__RenewedContract__r.Extension_Date__c, EndDate, StartDate FROM Contract WHERE Id in :RecordIdsList];
        
        if(!Contracts.isEmpty()) {
            for (Contract cont : Contracts) {
                if (cont.SBQQ__Opportunity__r != null &&
                    cont.SBQQ__Opportunity__r.SBQQ__RenewedContract__r != null &&
                    cont.SBQQ__Opportunity__r.SBQQ__RenewedContract__r.EndDate != null) {
                    
                    Date ContractStartDate = cont.SBQQ__Opportunity__r.SBQQ__RenewedContract__r.EndDate.addDays(1);
                    cont.StartDate = ContractStartDate;
                    cont.EndDate = cont.SBQQ__Opportunity__r.SBQQ__RenewedContract__r.Extension_Date__c;
                    ContractEndDates.put(String.valueOf(cont.Id), cont.EndDate);
                }
            }
            update Contracts;
        }
        
        return ContractEndDates;
    }

    public static Map<String, Date> addDays_QuoteLineGroup(List<String> RecordIdsList) {
        Map<String, Date> QuoteLineGroupEndDates = new Map<String, Date>();
        List<SBQQ__QuoteLineGroup__c> QuoteLineGroups = [SELECT Id, SBQQ__Quote__r.SBQQ__Opportunity2__r.SBQQ__RenewedContract__r.Extension_Date__c, SBQQ__StartDate__c, SBQQ__EndDate__c, SBQQ__Quote__r.SBQQ__Opportunity2__r.SBQQ__RenewedContract__r.EndDate FROM SBQQ__QuoteLineGroup__c WHERE Id in :RecordIdsList];
        
        if(!QuoteLineGroups.isEmpty()) {
            for (SBQQ__QuoteLineGroup__c qlg : QuoteLineGroups) {
                if (qlg.SBQQ__Quote__r != null &&
                    qlg.SBQQ__Quote__r.SBQQ__Opportunity2__r != null &&
                    qlg.SBQQ__Quote__r.SBQQ__Opportunity2__r.SBQQ__RenewedContract__r != null &&
                    qlg.SBQQ__Quote__r.SBQQ__Opportunity2__r.SBQQ__RenewedContract__r.EndDate != null) {
                    
                    Date QuoteLineGroupStartDate = qlg.SBQQ__Quote__r.SBQQ__Opportunity2__r.SBQQ__RenewedContract__r.EndDate.addDays(1);
                    qlg.SBQQ__StartDate__c = QuoteLineGroupStartDate;
                    qlg.SBQQ__EndDate__c = qlg.SBQQ__Quote__r.SBQQ__Opportunity2__r.SBQQ__RenewedContract__r.Extension_Date__c;
                    QuoteLineGroupEndDates.put(String.valueOf(qlg.SBQQ__EndDate__c), qlg.SBQQ__EndDate__c);
                }
            }
            update QuoteLineGroups;
        }
        
        return QuoteLineGroupEndDates;
    }

    @InvocableMethod(label='Add Days Helper Class. Objects Available : Order, Contract and QuoteLineGroup' description='AddDays_Helper for Objects : Order, Contract and QuoteLineGroup' )
    public static void AddDaysHelper_FromFlow(List<FlowParams> FlowParams) {
    if (FlowParams != null && !FlowParams.isEmpty()) {
        FlowParams params = FlowParams[0];

        if (params.IsOrderAction) {
            if (params.RecordIdsList != null && !params.RecordIdsList.isEmpty()) {
                addDays_Order(params.RecordIdsList);
            }
        }

        if (params.IsContractAction) {
            if (params.RecordIdsList != null && !params.RecordIdsList.isEmpty()) {
                addDays_Contract(params.RecordIdsList);
            }
        }

        if (params.IsQuoteLineGroupAction) {
            if (params.RecordIdsList != null && !params.RecordIdsList.isEmpty()) {
                addDays_QuoteLineGroup(params.RecordIdsList);
            }
        }
    }
}


    public class FlowParams {
        @InvocableVariable(label='Record Ids List' description='Record Ids List' required=true)
        public List<String> RecordIdsList;

        @InvocableVariable(label='If (IsContractAction) => Value = TRUE' description='Object : Contract' required=true)
        public Boolean IsContractAction;

        @InvocableVariable(label='If (IsOrderAction) => Value = TRUE' description='Object : Order' required=true)
        public Boolean IsOrderAction;

        @InvocableVariable(label='If (IsQuoteLineGroupAction) => Value = TRUE' description='Object : QuoteLineGroup' required=true)
        public Boolean IsQuoteLineGroupAction;
    }
}