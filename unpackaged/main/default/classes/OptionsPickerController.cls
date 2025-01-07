public class OptionsPickerController {

    /************************************* READ *************************************/ 

    
    /*********** RECORDS  ***********/


    /**** PRODUCTS ****/

    @AuraEnabled
    public static List<Product2> getOptionProducts(){
        if(!Test.isRunningTest()){
            return [SELECT Id, Name, ProductCode
                    FROM Product2 
                    WHERE Gamme__c LIKE 'Option%' 
                    AND Exclude_For_Container__c = false
                    AND isActive = true
                    ORDER BY Name];
        }
        else{
            return [SELECT Id, Name, ProductCode
                    FROM Product2 
                    WHERE Gamme__c LIKE 'Option%'
                    AND Exclude_For_Container__c = false
                    ORDER BY Name];
        }
    }

    /**** ASSETS ****/

    @AuraEnabled
    public static Asset getOptionInstallees(Id assetId){
        return [SELECT Options__c
                FROM Asset 
                WHERE Id =: assetId];
    }


    /************************************* CREATE/UPDATE/DELETE *************************************/ 

    
    /***********  ***********/




}