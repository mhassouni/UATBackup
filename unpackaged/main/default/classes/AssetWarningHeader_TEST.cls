@isTest
private class AssetWarningHeader_TEST {
    static testMethod void TestWarningMajKmIglooBlank()
    {
        Test.setMock(HttpCalloutMock.class, new AP01AssetMock_200());
        Test.setMock(HttpCalloutMock.class, new AP01AssetMock_208());
        Test.setMock(HttpCalloutMock.class, new AP01AssetMock_207());
        WSParametreRequete__c wspr1 = new WSParametreRequete__c(Name='WS_Param_004',
                                                                   EndPoint__c = 'https://api-test.petitforestier.fr/api/services/IGLOO/KmCompteur/v1.0/InsertKmCompteur',
                                                                   Methode__c = 'POST',
                                                                   UserName__c = 'mdm_sfdc',
                                                                   MotDePasse__c = '5:?MWWE6-tm9fcW4',
                                                                   ContentType__c = 'application/jsonl',
                                                                   ApplicationName__c = 'SFCD',
                                                                   Authorization__c = 'Basic bWRtX3NmZGM6NTo/TVdXRTYtdG05ZmNXNA==');
        insert wspr1;
        Bypass__c MyBypass = Utils_TestMethods.createBypass(UserInfo.getUserId());
        MyBypass.BypassValidationRules__c = true;
        MyBypass.BypassTriggers__c = 'AP09Compte';
        insert MyBypass;
        Account currAccount=Utils_TestMethods.createAccount('Account1',null,null, Label.CPT_RecordTypeId_CompteClient);
        insert currAccount;
        Asset currAsset=new Asset();
        currAsset.Name='PF-32500';
        currAsset.AccountId=currAccount.Id;
        insert currAsset;
        ApexPages.StandardController sc = new ApexPages.StandardController(currAsset);
        test.startTest();
        AssetWarningHeader custController = new AssetWarningHeader(sc);
        AssetWarningHeader.IsLastKmCompteurOK(currAsset.Id);
        AssetWarningHeader.setDisplayWarningMessage(currAsset.Id);
        AssetWarningHeader.IsDisplayWarning(currAsset.Id);
        AssetWarningHeader.TransmitKmToIgloo(currAsset.Id, 10);
        test.stopTest();
        
    }
    
    static testMethod void TestWarningMajKmIglooNotBlank()
    {
       // Test.setMock(HttpCalloutMock.class, new InsertkmCompteurIglooMock());
        Test.setMock(HttpCalloutMock.class, new AP01AssetMock_200());
        Test.setMock(HttpCalloutMock.class, new AP01AssetMock_208());
        Test.setMock(HttpCalloutMock.class, new AP01AssetMock_207());
        WSParametreRequete__c wspr1 = new WSParametreRequete__c(Name='WS_Param_004',
                                                                   EndPoint__c = 'https://api-test.petitforestier.fr/api/services/IGLOO/KmCompteur/v1.0/InsertKmCompteur',
                                                                   Methode__c = 'POST',
                                                                   UserName__c = 'mdm_sfdc',
                                                                   MotDePasse__c = '5:?MWWE6-tm9fcW4',
                                                                   ContentType__c = 'application/jsonl',
                                                                   ApplicationName__c = 'SFCD',
                                                                   Authorization__c = 'Basic bWRtX3NmZGM6NTo/TVdXRTYtdG05ZmNXNA==');
        insert wspr1;
        Bypass__c MyBypass = Utils_TestMethods.createBypass(UserInfo.getUserId());
        MyBypass.BypassValidationRules__c = true;
        MyBypass.BypassTriggers__c = 'AP09Compte';
        insert MyBypass;
        Account currAccount=Utils_TestMethods.createAccount('Account1',null,null, Label.CPT_RecordTypeId_CompteClient);
        insert currAccount;
        
        
        Asset currAsset2=new Asset();
        currAsset2.Name='PF-32501';
        currAsset2.AccountId=currAccount.Id;
        currAsset2.WarningMajKmIgloo__c='test';
        insert currAsset2;
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(currAsset2);
        
        AssetWarningHeader custController2 = new AssetWarningHeader(sc2);
        test.startTest();
        AssetWarningHeader.IsLastKmCompteurOK(currAsset2.Id);
        AssetWarningHeader.setDisplayWarningMessage(currAsset2.Id);
        AssetWarningHeader.IsDisplayWarning(currAsset2.Id);
        AssetWarningHeader.TransmitKmToIgloo(currAsset2.Id, 10);
        test.stopTest();
                
    }
}