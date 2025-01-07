public with sharing class DependentPicklistGenerator 
{
    @AuraEnabled(cacheable=true)
    public static    Map<Map<Integer, String>, Object> getAllBaseProduitRecords()
    {
        List<AggregateResult> AllPicklistValues = [Select  Code_Pays__c, Catalogue__c, Code_PF__c, Standard__c, Marque__c, Modele__c from Base_produit__c  Group By  Code_Pays__c, Catalogue__c, Code_PF__c, Standard__c, Marque__c, Modele__c order by Code_PF__c, Standard__c];        
        Map<Map<Integer, String>, Object> AllPicklistValuesToMap = new  Map<Map<Integer, String>, Object>();
        for(Integer i=0; i< AllPicklistValues.size(); i++) 
        {
            AllPicklistValuesToMap.put(new Map<Integer, String> { i => 'Code_Pays__c'},  AllPicklistValues[i].get('Code_Pays__c'));
            AllPicklistValuesToMap.put(new Map<Integer, String> { i => 'Catalogue__c'},  AllPicklistValues[i].get('Catalogue__c'));
            AllPicklistValuesToMap.put(new Map<Integer, String> { i => 'Code_PF__c'},  AllPicklistValues[i].get('Code_PF__c'));
            AllPicklistValuesToMap.put(new Map<Integer, String> { i => 'Standard__c'},  AllPicklistValues[i].get('Standard__c'));
            AllPicklistValuesToMap.put(new Map<Integer, String> { i => 'Marque__c'},  AllPicklistValues[i].get('Marque__c'));
            AllPicklistValuesToMap.put(new Map<Integer, String> { i => 'Modele__c'},  AllPicklistValues[i].get('Modele__c'));
        }
        return AllPicklistValuesToMap;       
    }

    @AuraEnabled(cacheable=true)
    public static  List<AggregateResult> getCatalogDependentValues(String QueryToApexMethod, String CodePaysParam, String CatalogueParam, String CodePFParam, String StandardPFParam, String MarqueParam, String ModeleParam)     
    {
        List<sObject> DynamicSoqlQueryResponse = Database.query(string.escapeSingleQuotes(QueryToApexMethod));
        return DynamicSoqlQueryResponse;  
    }
}