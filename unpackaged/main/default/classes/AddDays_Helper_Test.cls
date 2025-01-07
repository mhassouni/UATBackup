@isTest (seealldata=true)
public class AddDays_Helper_Test {

    static testMethod void doAddDays() {
        Contract c = [SELECT Id, SBQQ__Opportunity__r.SBQQ__RenewedContract__r.EndDate, SBQQ__Opportunity__r.SBQQ__RenewedContract__r.Extension_Date__c, EndDate, StartDate FROM Contract WHERE SBQQ__Quote__r.Saved_Quote_Line_Groups__c > 0 AND SBQQ__Opportunity__r.SBQQ__RenewedContract__r.EndDate != NULL AND SBQQ__Quote__r.Type_de_location__c = 'Longue Durée' LIMIT 1];
        Order orderRecord = [SELECT Id, EndDate__c, StartDate__c, Opportunity.SBQQ__RenewedContract__r.Extension_Date__c, Opportunity.SBQQ__RenewedContract__r.EndDate FROM Order WHERE SBQQ__Quote__r.Saved_Quote_Line_Groups__c > 0 AND Opportunity.SBQQ__RenewedContract__r.EndDate != NULL AND SBQQ__Quote__r.Type_de_location__c = 'Longue Durée' LIMIT 1];
        SBQQ__QuoteLineGroup__c quoteLineGroup = [SELECT Id, SBQQ__Quote__r.SBQQ__Opportunity2__r.SBQQ__RenewedContract__r.Extension_Date__c, SBQQ__StartDate__c, SBQQ__EndDate__c, SBQQ__Quote__r.SBQQ__Opportunity2__r.SBQQ__RenewedContract__r.EndDate FROM SBQQ__QuoteLineGroup__c WHERE SBQQ__Quote__r.Saved_Quote_Line_Groups__c > 0 AND SBQQ__Quote__r.SBQQ__Opportunity2__r.SBQQ__RenewedContract__r.EndDate != NULL AND SBQQ__EndDate__c != NULL AND SBQQ__Quote__r.Type_de_location__c = 'Longue Durée' LIMIT 1];
 
        Test.startTest();

        List<String> contractIds = new List<String>{c.Id};
        Map<String, Date> contractEndDates = AddDays_Helper.addDays_Contract(contractIds);
        System.assert(!contractEndDates.isEmpty(), 'Contract end dates map should not be empty');

        List<String> orderIds = new List<String>{orderRecord.Id};
        Map<String, Date> orderEndDates = AddDays_Helper.addDays_Order(orderIds);
        System.assert(!orderEndDates.isEmpty(), 'Order end dates map should not be empty');

        List<String> quoteLineGroupIds = new List<String>{quoteLineGroup.Id};
        Map<String, Date> quoteLineGroupEndDates = AddDays_Helper.addDays_QuoteLineGroup(quoteLineGroupIds);
        System.assert(!quoteLineGroupEndDates.isEmpty(), 'QuoteLineGroup end dates map should not be empty');

        AddDays_Helper.FlowParams params = new AddDays_Helper.FlowParams();
        params.IsOrderAction = true;
        params.RecordIdsList = new List<String>{orderRecord.Id};

        List<AddDays_Helper.FlowParams> paramsList = new List<AddDays_Helper.FlowParams>{params};

        AddDays_Helper.AddDaysHelper_FromFlow(paramsList);

        params.IsOrderAction = false;
        params.IsContractAction = true;
        params.RecordIdsList = new List<String>{c.Id};
        AddDays_Helper.AddDaysHelper_FromFlow(paramsList);

        params.IsContractAction = false;
        params.IsQuoteLineGroupAction = true;
        params.RecordIdsList = new List<String>{quoteLineGroup.Id};
        AddDays_Helper.AddDaysHelper_FromFlow(paramsList);

        Test.stopTest();
    }
}