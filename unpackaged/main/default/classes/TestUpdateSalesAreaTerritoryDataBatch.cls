@isTest
private class TestUpdateSalesAreaTerritoryDataBatch {

    static void setupTestData() {
        //Create account
        Account ac = new Account(Name='Compte test',PaysRegionPF__c='DRO IDF 1',CodePostal__c='12345');
        insert ac;
        // Create and insert SalesArea
        SalesArea__c sa = new SalesArea__c(Name = 'Test Sales Area');
        insert sa;
        
        // Create and insert Secteur with a link to SalesArea
        Secteur__c sect = new Secteur__c(Organisation_Commerciale__c = sa.Id, Commercial__c = UserInfo.getUserId(), Manager_Commercial__c = UserInfo.getUserId());
        insert sect;
        
        // Create and insert Territoire linked to SalesArea and Secteur
        Territory__c ter = new Territory__c(Organisation_Commerciale__c = sa.Id, Secteur__c = sect.Id, Code_Postal__c = '12345');
        insert ter;
        
        // Create SalesAreaData with matching SalesArea and PostalCode but null Secteur__c and Territoire__c
        SalesAreaData__c sad = new SalesAreaData__c(Name='SAD test',SalesArea__c = sa.Id,Account__c=ac.id,TerritorialCommercial__c=null,ManagerCommercial__c=null,PFRegion__c='DRO IDF 1');
        insert sad;
    }
    
    static testMethod void testUpdateSalesAreaTerritoryDataBatch() {
        Test.startTest();
        
        // Setup test data
        setupTestData();
        
        // Execute the batch class
        UpdateSalesAreaTerritoryDataBatch batch = new UpdateSalesAreaTerritoryDataBatch('DRO IDF 1');
        Database.executeBatch(batch, 200);
        
        Test.stopTest();
        
        // Retrieve the updated SalesAreaData__c record
        Account ACC = [select id from account where Name = 'Compte test' limit 1];
        SalesAreaData__c updatedSad = [SELECT Territoire__c, Secteur__c, TerritorialCommercial__c, ManagerCommercial__c,PostalCode__c FROM SalesAreaData__c WHERE Account__c =: ACC.id and name = 'SAD test'  LIMIT 1];
        system.debug('SAD Territoire : '+updatedSad.Territoire__c +' Secteur : '+updatedSad.Secteur__c +'Postal code : '+updatedSad.PostalCode__c);
        // Assert that the updates were made as expected
        System.assertNotEquals(null, updatedSad.Territoire__c, 'Territoire__c was not updated.');
        System.assertNotEquals(null, updatedSad.Secteur__c, 'Secteur__c was not updated.');
        System.assertNotEquals(null, updatedSad.TerritorialCommercial__c, 'Commercial__c was not updated.');
        System.assertNotEquals(null, updatedSad.ManagerCommercial__c, 'Manager__c was not updated.');
    }
}