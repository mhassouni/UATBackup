public class GenDocQuoteFromQuote {
    
    public SBQQ__Quote__c quote { get; set; }

    public GenDocQuoteFromQuote(ApexPages.StandardController stdController) {
        String id = ApexPages.currentPage().getParameters().get('id');
        quote = [SELECT id, templateId__c FROM SBQQ__Quote__c where Id=:id Limit 1];
        system.debug('quote');
        system.debug(quote);
    }
}