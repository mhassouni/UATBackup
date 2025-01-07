public class GenDocContractsFromQuote {
    public SBQQ__Quote__c quote { get; set; }
    public List<Contract> contracts { get; set; }
    public GenDocContractsFromQuote(ApexPages.StandardController stdController) {
        String id = ApexPages.currentPage().getParameters().get('id');
        system.debug('params');
        system.debug(id);
        contracts = [SELECT id,templateId__c  FROM Contract where SBQQ__Quote__c=:id];
    }
}