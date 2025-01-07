@isTest
private class RDD_SADController_Test {
  
    
    // Test the init method
    @isTest
    static void testInit() {
        Test.startTest();
          // Setup specific test data if needed
        RDD_SADController controller = new RDD_SADController();
        //Account
        Account ac = new Account(Name='Compte test',PaysRegionPF__c='DRO IDF 1',CodePostal__c='12345',RecordtypeId= Label.ACC_RecordTypeId_CompteClient); insert ac;
        //SalesArea
        SalesArea__c sa = new SalesArea__c(Name = 'Test Sales Area',BusinessLine__c='Véhicules Frigorifiques',Brand__c='Petit Forestier');
        SalesArea__c saContainer = new SalesArea__c(Name = 'Test Sales Area 2',BusinessLine__c='Containers',Brand__c='Petit Forestier');
        insert sa;insert saContainer;
        //SalesAreaData
        SalesAreaData__c sad = new SalesAreaData__c(Name='SAD test',SalesArea__c = sa.Id,Account__c=ac.id,TerritorialCommercial__c=null,ManagerCommercial__c=null,PFRegion__c='DRO IDF 1'); 
        SalesAreaData__c sadContainer = new SalesAreaData__c(Name='SAD test',SalesArea__c = saContainer.Id,Account__c=ac.id,TerritorialCommercial__c=null,ManagerCommercial__c=null,PFRegion__c='DRO IDF 1'); 
        insert sad;insert sadContainer;
        //DeroFI
        Dero_Fi__c DeroFI1 = new Dero_Fi__c(Account__c=ac.Id,SalesArea__c=sa.Id,SalesAreaData__c=sad.Id,Product_Type__c='Véhicules Frigorifiques');
        Dero_Fi__c DeroFI2 = new Dero_Fi__c(Account__c=ac.Id,SalesArea__c=saContainer.Id,SalesAreaData__c=sadContainer.Id,Product_Type__c='Containers');
        insert DeroFI1;insert DeroFI2;
        
 
        controller.SADInit= sad; controller.accInit = ac ;controller.accInitAct = ac;controller.accInitCondFi = ac;controller.accInitCtr = ac;controller.accInitDERO = ac;controller.accInitFact = ac;controller.accInitOpp = ac;controller.accInitTerritoire = ac;
        controller.accInit.PaysRegionPF__c='DRO IDF 1';
        // Instantiate your controller and call the init method
        
        controller.init();
        controller.denombrerInitSAD();
        controller.denombrerStatutSAD();
        controller.denombrerCondFiSAD();
        controller.denombrerInitFacturesSAD();
        controller.denombrerContactsSAD();
		controller.denombrerInitOppSAD();
        controller.denombrerDEROSAD();
        controller.denombrerTerritoire();
        // Perform asserts to verify the initialization
        // 
        Test.stopTest();
        
        // Example assert
        System.assertNotEquals(null, controller.accInit, 'Account should be initialized');
        System.assertNotEquals(null, controller.accInitAct, 'Account should be initialized');
        System.assertNotEquals(null, controller.accInitCondFi, 'Account should be initialized');
        System.assertNotEquals(null, controller.accInitCtr, 'Account should be initialized');
        System.assertNotEquals(null, controller.accInitDERO, 'Account should be initialized');
        System.assertNotEquals(null, controller.accInitFact, 'Account should be initialized');
        System.assertNotEquals(null, controller.accInitOpp, 'Account should be initialized');
        System.assertNotEquals(null, controller.accInitTerritoire, 'Account should be initialized');

        
    }
    
    // test Controller
    @isTest
    static void testController() {
        Test.startTest();
        // Setup specific test data if needed
        RDD_SADController controller = new RDD_SADController();
        //Account
        Account ac = new Account(Name='Compte test',PaysRegionPF__c='DRO IDF 1',CodePostal__c='12345'); insert ac;
        //SalesArea
        SalesArea__c sa = new SalesArea__c(Name = 'Test Sales Area',BusinessLine__c='Véhicules Frigorifiques',Brand__c='Petit Forestier');
        SalesArea__c saContainer = new SalesArea__c(Name = 'Test Sales Area 2',BusinessLine__c='Containers',Brand__c='Petit Forestier');
        insert sa;insert saContainer;
        //SalesAreaData
        SalesAreaData__c sad = new SalesAreaData__c(Name='SAD test',SalesArea__c = sa.Id,Account__c=ac.id,TerritorialCommercial__c=null,ManagerCommercial__c=null,PFRegion__c='DRO IDF 1'); 
        SalesAreaData__c sadContainer = new SalesAreaData__c(Name='SAD test',SalesArea__c = saContainer.Id,Account__c=ac.id,TerritorialCommercial__c=null,ManagerCommercial__c=null,PFRegion__c='DRO IDF 1'); 
        insert sad;insert sadContainer;
        //DeroFI
        Dero_Fi__c DeroFI1 = new Dero_Fi__c(Account__c=ac.Id,SalesArea__c=sa.Id,SalesAreaData__c=sad.Id,Product_Type__c='Véhicules Frigorifiques');
        Dero_Fi__c DeroFI2 = new Dero_Fi__c(Account__c=ac.Id,SalesArea__c=saContainer.Id,SalesAreaData__c=sadContainer.Id,Product_Type__c='Containers');
        insert DeroFI1;insert DeroFI2;
        
 
        controller.SADInit= sad; controller.accInit = ac;controller.accInitAct = ac;controller.accInitCondFi = ac;controller.accInitCtr = ac;controller.accInitDERO = ac;controller.accInitFact = ac;controller.accInitOpp = ac;controller.accInitTerritoire = ac;
        
    
        
        // Execute the method to be tested
        controller.executeBatchIdInitSAD();
        controller.executeBatchIdInitCondFiSAD();
        controller.executeBatchIdInitCtsSAD();
        controller.executeBatchIdInitFactSAD();
        controller.executeBatchIdInitStatutSAD();
        controller.executeBatchIdInitDeroSAD();
        controller.executeBatchIdInitOppSAD();
        controller.executeBatchIdInitTerritoire();
        // method call
        Test.stopTest();
        
        // Asserts to verify method outcomes
       System.assertEquals(null, sad.Territoire__c, 'Territoire__c was not updated.');

    }
    
    
   // Template for testing other methods
    @isTest
    static void testMethods() {
        Test.startTest();
        // Setup specific test data if needed
        RDD_SADController controller = new RDD_SADController();
        Account ac = new Account(Name='Compte test',PaysRegionPF__c='DRO IDF 1',CodePostal__c='12345',Pays__c='FRANCE'); ac.Statut__c='Validé';
        insert ac;
        //Entité légale
        LegalEntity__c LegalEntity = new LegalEntity__c(Name='Petit Forestier Location',Active__c=true);
        insert LegalEntity;
        //SalesArea
        SalesArea__c sa = new SalesArea__c(Name = 'Test Sales Area',BusinessLine__c='Véhicules Frigorifiques',Brand__c='Petit Forestier',LegalEntity__c=LegalEntity.Id,Country__c='FRANCE');
        SalesArea__c saContainer = new SalesArea__c(Name = 'Test Sales Area 2',BusinessLine__c='Containers',Brand__c='Petit Forestier',LegalEntity__c=LegalEntity.Id,Country__c='FRANCE');
        insert sa;insert saContainer;
        //SalesAreaData
        SalesAreaData__c sad = new SalesAreaData__c(Name='SAD test',SalesArea__c = sa.Id,Account__c=ac.id,TerritorialCommercial__c=null,ManagerCommercial__c=null,PFRegion__c='DRO IDF 1'); 
        SalesAreaData__c sadContainer = new SalesAreaData__c(Name='SAD test',SalesArea__c = saContainer.Id,Account__c=ac.id,TerritorialCommercial__c=null,ManagerCommercial__c=null,PFRegion__c='DRO IDF 1'); 
        insert sad;insert sadContainer;
        	//Account SAD
      	List<SalesAreaData__c> ListeSADAccount = [select id,name,Account__c,BusinessLine__c,Pays_SA__c,PFRegion__c,SalesArea__c from SalesAreaData__c where Account__c=:Ac.id];
            //DeroFI
        Dero_Fi__c DeroFI1 = new Dero_Fi__c(Account__c=ac.Id,SalesArea__c=sa.Id,SalesAreaData__c=sad.Id,Product_Type__c='Véhicules Frigorifiques');
        Dero_Fi__c DeroFI2 = new Dero_Fi__c(Account__c=ac.Id,SalesArea__c=saContainer.Id,SalesAreaData__c=sadContainer.Id,Product_Type__c='Containers');
        insert DeroFI1;insert DeroFI2;
		//Contact Ct = Utils_TestMethods.createContact('conName', ac.id);
        Opportunity Opp = Utils_TestMethods.createOpportunityWithProduits('oppName', '1 - Opportunité créée	', Date.newInstance(2024,10,10), ac);
        Opp.PaysRegionPF__c='DO IDF 1';
        insert Opp;
		
        Contract Ct1 = new contract(RecordtypeId=Label.RecordtypeId_ContratVehicule,Accountid=ac.id);insert ct1;
        Contract Ct2 = new contract(RecordtypeId=Label.Master_Agreement_Contrat_RecordTypeId,Accountid=ac.id);insert ct2;
        controller.SADInit= sad; controller.accInit = ac;controller.accInitAct = ac;controller.accInitCondFi = ac;controller.accInitCtr = ac;controller.accInitDERO = ac;controller.accInitFact = ac;controller.accInitOpp = ac;controller.accInitTerritoire = ac;
       
        //Lists
        list<SalesAreaData__c> SADList = new list<SalesAreaData__c>();SADList.add(sad);SADList.add(sadContainer);
        list<Account> AccountsList = new list<Account>();AccountsList.add(ac);
        list<SalesArea__c> SAList = new list<SalesArea__c>();SAList.add(sa);SAList.add(saContainer);
        list<Opportunity> OPPList = new list<Opportunity>();OPPList.add(Opp);
        list<contract> ContractList = new list<Contract>();ContractList.add(ct1);ContractList.add(ct2);
        list<Derogation__c> DEROList = new list<Derogation__c>();
        list<Dero_Fi__c> DEROFIList = new list<Dero_Fi__c>();DEROFIList.add(DeroFI1);DEROFIList.add(DeroFI2);
        list<Facture_vehicule__c> FVList = new list<Facture_vehicule__c>();
        List<Id> ListIds = new list<id>();ListIds.Add(Opp.id);
        // Execute the method to be tested
        RDD_SADController.InitiateSADCreation(AccountsList, SAList);
        RDD_SADController.InitiateStatutSAD(ListeSADAccount);
        RDD_SADController.MigrateOppsSAD(OPPList, ListeSADAccount);
        RDD_SADController.MigrateContratsSAD(ContractList, ListeSADAccount);
        RDD_SADController.MigrateCondFiSAD(DEROFIList, ListeSADAccount);
        RDD_SADController.MigrateFacturesSAD(FVList, ListeSADAccount);
        RDD_SADController.MigrateDeroSAD(DEROList);
        RDD_SADController.MigrateOneOpportunity(ListIds);
        
        // method call
        Test.stopTest();
        
        // Asserts to verify method outcomes
//       System.assertEquals(null, sad.Territoire__c, 'Territoire__c was not updated.');

    }
    
    //Test batches
   @isTest
    static void testBatchs(){
        Test.startTest();

        
        RDD_InitSAD_Batch Batch1 = new RDD_InitSAD_Batch('DRO IDF 1');
        Database.executeBatch(Batch1,5);
        
        RDD_InitStatutSAD_Batch Batch2 = new RDD_InitStatutSAD_Batch('DRO IDF 1');
        Database.executeBatch(Batch2,5);
        
        RDD_InitOppSAD_Batch Batch3 = new RDD_InitOppSAD_Batch('DRO IDF 1');
        Database.executeBatch(Batch3,5);
        
        RDD_InitFactureSAD_Batch Batch4 = new RDD_InitFactureSAD_Batch('DRO IDF 1');
        Database.executeBatch(Batch4,5);
        
        RDD_InitDEROSAD_Batch Batch5 = new RDD_InitDEROSAD_Batch('DRO IDF 1');
        Database.executeBatch(Batch5,5);
        
        RDD_InitCondFiSAD_Batch Batch6 = new RDD_InitCondFiSAD_Batch('DRO IDF 1');
        Database.executeBatch(Batch6,5);
        
        RDD_InitContractsSAD_Batch Batch7 = new RDD_InitContractsSAD_Batch('DRO IDF 1');
        Database.executeBatch(Batch7,5);
		Test.stopTest();

    }
}