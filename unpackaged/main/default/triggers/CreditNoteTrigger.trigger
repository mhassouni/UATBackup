trigger CreditNoteTrigger on blng__CreditNote__c (before update) {
	
    Set<Id> postedcreditNotes = new Set<Id>();
    
    if (Trigger.isBefore && Trigger.isUpdate) {
        //system.debug('korTrigger.New:'+Trigger.New);
        //system.debug('korTrigger.OldMap:'+Trigger.OldMap);
        DocumentNumberHandler.CreateCreditNoteNumber(Trigger.New, Trigger.OldMap);
        DocumentNumberHandler.updateNumberCreditNotesLine(Trigger.New, Trigger.OldMap);
    }
}