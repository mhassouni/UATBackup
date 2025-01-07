public with sharing class VFE23_RoleContactIntermediaire {

    public Opportunity a{get;set;}
    
    public VFE23_RoleContactIntermediaire(ApexPages.StandardController controller) {
    
        a = [ Select id , name from opportunity where id = :ApexPages.currentPage().getParameters().get('oppId')];
       
    }
   

}