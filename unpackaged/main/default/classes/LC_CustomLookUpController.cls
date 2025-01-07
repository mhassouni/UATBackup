public with sharing class LC_CustomLookUpController {
    @AuraEnabled
    public static List <sObject> fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        
        String condition = '';
        if(ObjectName == 'account'){
            condition = 'AND RecordTypeId = \'' + Label.ACC_RT_AgencePF + '\' ';
        }

        List <sObject> returnList = new List < sObject > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey ' + condition + 'order by createdDate DESC limit 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}