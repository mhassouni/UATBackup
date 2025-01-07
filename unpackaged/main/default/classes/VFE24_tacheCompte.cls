public with sharing class VFE24_tacheCompte {
    
    public Opportunity a{get;set;}
    
    
    public VFE24_tacheCompte(ApexPages.StandardController controller) {
        a = [Select id, name, account.id, TypeProduits__c from Opportunity where id = :ApexPages.currentPage().getParameters().get('oppId')];
    
    }

}