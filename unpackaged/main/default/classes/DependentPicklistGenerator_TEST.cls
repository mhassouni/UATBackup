@isTest(SeeAllData=true)
public class DependentPicklistGenerator_TEST 
{
    public static testMethod void fetchRecords()
    {
        String QueryPart_01 = 'Select  Code_Pays__c, Catalogue__c, Code_PF__c, Standard__c, Marque__c, Modele__c from Base_produit__c  ';
        Test.startTest();
        DependentPicklistGenerator.getCatalogDependentValues(QueryPart_01, 'CodePaysParam', 'CatalogueParam', 'CodePFParam', 'StandardPFParam', 'MarqueParam', 'ModeleParam');
        DependentPicklistGenerator.getAllBaseProduitRecords();
        Test.stopTest();
    }
    
}