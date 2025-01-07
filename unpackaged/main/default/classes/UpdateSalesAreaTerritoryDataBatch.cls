global class UpdateSalesAreaTerritoryDataBatch implements Database.Batchable<sObject> {

     private string filterPaysRegionPF;
    
    
    
    public UpdateSalesAreaTerritoryDataBatch(string filterPaysRegionPF)
    {
        this.filterPaysRegionPF = filterPaysRegionPF;
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query SalesAreaData__c records where Secteur__c and Territory__c are null
        String Query = 'SELECT Id, SalesArea__c, PostalCode__c,Businessline__c,Account__r.OwnerId FROM SalesAreaData__c WHERE Secteur__c = null AND Territoire__c = null AND PostalCode__c <> null';
             if(filterPaysRegionPF!=null && filterPaysRegionPF!=''){
            Query+=' AND PFRegion__c=\''+filterPaysRegionPF+'\' ';
        }
           return Database.getQueryLocator(Query);

    }
    
    global void execute(Database.BatchableContext BC, List<SalesAreaData__c> scope) {
        // Maps to store Territory__c records by PostalCode__c and SalesArea__c
        Map<String, List<Territory__c>> territoireMap = new Map<String, List<Territory__c>>();

        // Query Territory__c records and populate the map
        for (Territory__c ter : [
            SELECT Id, Organisation_Commerciale__c,organisation_Commerciale__r.Businessline__c, Secteur__c, Code_Postal__c, Secteur__r.Commercial__c, Secteur__r.Manager_Commercial__c	
            FROM Territory__c
        ]) {
            String key = ter.Code_Postal__c + '-' + ter.Organisation_Commerciale__c;
            if (!territoireMap.containsKey(key)) {
                territoireMap.put(key, new List<Territory__c>());
            }
            territoireMap.get(key).add(ter);
        }

        // List to hold updates
        List<SalesAreaData__c> updates = new List<SalesAreaData__c>();

        // Process each SalesAreaData__c record
        for (SalesAreaData__c sad : scope) {
            String key = sad.PostalCode__c + '-' + sad.SalesArea__c;
            if (territoireMap.containsKey(key) && !territoireMap.get(key).isEmpty()) {
                // Assuming the first match is the desired one
                Territory__c ter = territoireMap.get(key)[0];
                sad.Territoire__c = ter.Id;
                sad.Secteur__c = ter.Secteur__c;
                if (ter.Secteur__c != null) {
               
                    
                    sad.ManagerCommercial__c = ter.Secteur__r.Manager_Commercial__c;
                    sad.TerritorialCommercial__c = ter.Secteur__r.Commercial__c;
                
                  
                }
                
            }
            else if(sad.BusinessLine__c=='Containers'){sad.TerritorialCommercial__c = sad.Account__r.OwnerId;}
            updates.add(sad);
        }

        // Update the SalesAreaData__c records
        if (!updates.isEmpty()) {
            update updates;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch Job Completed Successfully.');
    }
}