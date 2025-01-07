@isTest
private class FicheDepannageRIVController_TEST {
	static testMethod void testRedirectToWorkOrderItem()
    {
        //Mock
        Test.setMock(HttpCalloutMock.class, new FicheDepannageMock_TEST());
        WSParametreRequete__c wspr1 = new WSParametreRequete__c(Name='WS_Param_003',
                                                                   EndPoint__c = 'https://api-test.petitforestier.fr/api/services/SFDC/Report/RIV/v2.0/GetRIVReport',
                                                                   Methode__c = 'POST',
                                                                   UserName__c = 'mdm_sfdc',
                                                                   MotDePasse__c = '5:?MWWE6-tm9fcW4',
                                                                   ContentType__c = 'application/jsonl',
                                                                   ApplicationName__c = 'SFCD',
                                                                   Authorization__c = 'Basic bWRtX3NmZGM6NTo/TVdXRTYtdG05ZmNXNA==');
        insert wspr1;
        //DATA
        Account Account1 = Utils_TestMethods.createAccount('Account1',null,null, Label.CPT_RecordTypeId_CompteSite);
        insert Account1;
        Account Agence1 = Utils_TestMethods.CreateAgence('AgenceTEST');
        insert Agence1;
        Asset Parc1 = Utils_TestMethods.CreateAsset(Account1.id,Label.Parc_RecordTypeId);
        Parc1.Agence__c=Agence1.id;
        insert Parc1;
        Case Req1 = Utils_TestMethods.CreateCase_Depannage(Account1.id,Parc1.id,Agence1.id,Label.Case_RecordTypeID_Depannage_Vehicule);
        Req1.Agence_proprietaire__c=Agence1.id;
        insert Req1;
        WorkOrder WO1 = Utils_TestMethods.CreateWorkOrder_Depannage(Account1.id,Parc1.id,Agence1.id,Req1.id,Label.OT_RecordTypeId_Depannage_Vehicule);
        insert WO1;
        
        
        PageReference pref = Page.FicheDepannageRIV;
        pref.getParameters().put('id',WO1.Id);
        Test.setCurrentPage(pref);
        Test.startTest();
        ApexPages.StandardController con = new ApexPages.StandardController(WO1);
        FicheDepannageRIVController MyCon = new FicheDepannageRIVController(con);
        MyCon.RedirectToWorkOrderItem();
        Test.stopTest();
    }
}