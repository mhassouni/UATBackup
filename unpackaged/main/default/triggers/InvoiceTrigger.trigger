trigger InvoiceTrigger on blng__Invoice__c (before update) {

    Set<Id> postedInvoices = new Set<Id>();
    
    if (Trigger.isBefore && Trigger.isUpdate) {
        DocumentNumberHandler.CreateInvoiceNumber(Trigger.New, Trigger.OldMap);
        DocumentNumberHandler.updateNumberInvoiceLine(Trigger.New, Trigger.OldMap);
    }
}