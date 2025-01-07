public class GenDocCreditNoteFromCreditNote {
	public blng__CreditNote__c cr { get; set; }
    public GenDocCreditNoteFromCreditNote(ApexPages.StandardController stdController) {
        String id = ApexPages.currentPage().getParameters().get('id');
        cr = [SELECT id,templateId__c   FROM blng__CreditNote__c where Id=:id limit 1];
  
    }
}