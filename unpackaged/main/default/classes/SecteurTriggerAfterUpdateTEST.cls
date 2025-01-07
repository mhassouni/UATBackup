@isTest
private class SecteurTriggerAfterUpdateTEST {
    @isTest static void testSecteurTrigger1() {
        // Setup test data
         
        User Commercial = Utils_TestMethods.createUser('lastName', 'lastName', Label.USR_ProfileId_PFReseau);
        User ManagerCommercial = Utils_TestMethods.createUser('ManagerCommercial', 'ManagerCommercial', Label.USR_ProfileId_PFReseau);
        Secteur__c sect = new Secteur__c(Commercial__c = Commercial.id, Manager_Commercial__c = ManagerCommercial.id);
        insert sect;

        SalesAreaData__c sad = new SalesAreaData__c(Secteur__c = sect.Id);
        insert sad;

        // Perform test
        Test.startTest();
        User Commercial2 = Utils_TestMethods.createUser('lastName2', 'lastName2', Label.USR_ProfileId_PFReseau);
        User ManagerCommercial2 = Utils_TestMethods.createUser('ManagerCommercial2', 'ManagerCommercial2', Label.USR_ProfileId_PFReseau);
        User Commercial3 = Utils_TestMethods.createUser('lastName3', 'lastName3', Label.USR_ProfileId_PFReseau);
        User ManagerCommercial3 = Utils_TestMethods.createUser('ManagerCommercial3', 'ManagerCommercial3', Label.USR_ProfileId_PFReseau);
        sect.Commercial__c = Commercial2.id;
        sect.Manager_Commercial__c = ManagerCommercial2.id;
        update sect;
        sad.TerritorialCommercial__c = Commercial3.id;
        update sad;
        
       
        sect.Manager_Commercial__c = ManagerCommercial3.id;
        update sect;
        Test.stopTest();

        // Verify results
        SalesAreaData__c updatedSad = [SELECT TerritorialCommercial__c, ManagerCommercial__c FROM SalesAreaData__c WHERE Id = :sad.Id];
        System.assertEquals(Commercial2.id, updatedSad.TerritorialCommercial__c);
        System.assertEquals(ManagerCommercial3.id, updatedSad.ManagerCommercial__c);
    }
    
     
    
   		@isTest static void testBatchExecution() {
        // Setup - create multiple Secteur__c records
        List<Secteur__c> secteurList = new List<Secteur__c>();
        List<Id> SecteurIds = new list<Id>();
            Map<Id, String> oldTerritorialCommercialMap = new Map<Id, String>();
    	 Map<Id, String> oldManagerCommercialMap = new Map<Id, String>();
        for(Integer i = 0; i < 5; i++) {
            secteurList.add(new Secteur__c(
                Commercial__c = (Utils_TestMethods.createUser('commercial' + i, 'Commercial' + i, Label.USR_ProfileId_PFReseau)).id,
                Manager_Commercial__c = (Utils_TestMethods.createUser('Manager' + i, 'Manager' + i, Label.USR_ProfileId_PFReseau)).id
            ));
        }
        
       insert secteurList;
       for(secteur__c sect:secteurList)
       {
           SecteurIds.add(sect.id);
       }

        // Setup - create related SalesAreaData__c records
        List<SalesAreaData__c> salesAreaList = new List<SalesAreaData__c>();
        for(Secteur__c secteur : secteurList) {
            User Comm1 = Utils_TestMethods.createUser('SADcommercial', 'SADCommercial' , Label.USR_ProfileId_PFReseau);
            User manager1 = Utils_TestMethods.createUser('SADmanager', 'SADmanager' , Label.USR_ProfileId_PFReseau);

            salesAreaList.add(new SalesAreaData__c(
                Secteur__c = secteur.Id,
                TerritorialCommercial__c = Comm1.id,
                ManagerCommercial__c = manager1.id
            ));
        }
        insert salesAreaList;

        // Perform test - update Secteur__c records to trigger the batch
        // 
       		User NewComm1 = Utils_TestMethods.createUser('NewSADcommercial', 'SADCommercial1' , Label.USR_ProfileId_PFReseau);
            User Newmanager1 = Utils_TestMethods.createUser('NewSADmanager', 'SADmanager1' , Label.USR_ProfileId_PFReseau);
        for(Secteur__c secteur : secteurList) {
            secteur.Commercial__c = NewComm1.id;
            secteur.Manager_Commercial__c = Newmanager1.id;
        }
        Test.startTest();
        update secteurList; // This update triggers the batch process
       Database.executeBatch(new UpdateSADAfterUpdateSecteurBatch(SecteurIds,oldTerritorialCommercialMap,oldManagerCommercialMap), 200);
        Test.stopTest();

        // Verify - check that related SalesAreaData__c records were updated
        List<SalesAreaData__c> updatedSalesAreaList = [SELECT TerritorialCommercial__c, ManagerCommercial__c FROM SalesAreaData__c WHERE Id IN :salesAreaList];
        for(SalesAreaData__c sad : updatedSalesAreaList) {
            System.assertEquals(NewComm1.id, sad.TerritorialCommercial__c);
            System.assertEquals(Newmanager1.id, sad.ManagerCommercial__c);
        }
    }
}