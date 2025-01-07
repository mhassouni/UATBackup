@isTest
private class AP01Asset_TEST {
	
    static testMethod void testPostCallout_200() {

        Test.setMock(HttpCalloutMock.class, new AP01AssetMock_200());
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
        test.startTest();
        AP01Asset.TransmitKmCompteurToIgloo(currAsset.Id, 10);
        test.stopTest();
    }
     static testMethod void testPostCallout_208() {
        
        Test.setMock(HttpCalloutMock.class, new AP01AssetMock_208());
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
        test.startTest();
        AP01Asset.TransmitKmCompteurToIgloo(currAsset.Id, 10);
        test.stopTest();
    }
    static testMethod void testPostCallout_207() {
        
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
        test.startTest();
        AP01Asset.TransmitKmCompteurToIgloo(currAsset.Id, 10);
        test.stopTest();
    }
}