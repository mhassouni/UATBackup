@isTest
private class VFE23_RoleContactIntermediaire_TEST{

    static testMethod void TestRoleContact() {
    
        Bypass__c MyBypass = Utils_TestMethods.createBypass(UserInfo.getUserId());
        MyBypass.BypassValidationRules__c = true;
        MyBypass.BypassTriggers__c = 'AP09Compte,AP03Opportunite,AP01Opportunite';
        insert MyBypass;
        
        Account Account1 = Utils_TestMethods.createAccount('Account1',null,null, Label.CPT_RecordTypeId_CompteClient); 
        Account1.PaysRegionPF__c = 'PFUK';
        Account1.AgencePF__c = '113 - LEEDS';
        insert Account1;
            
        Opportunity Opportunity1 = Utils_TestMethods.createOpportunity('Nouvelle Opportunité 1',Label.OPP_StageName_OpportuniteCreee,system.today(),Account1);
        Opportunity1.AccountId = Account1.Id;
        Opportunity1.PaysRegionPF__c = 'PFUK';
        Opportunity1.AgencePF__c = '113 - LEEDS';
        insert Opportunity1;
        
        system.debug('### opportunity1.id ' + Opportunity1.id);
        PageReference pageRef = Page.VFP23_RoleContactIntermediaire;
        pageRef.getParameters().put('oppId',Opportunity1.id);
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(Opportunity1);
        VFE23_RoleContactIntermediaire r = new VFE23_RoleContactIntermediaire(sc);
        
    }
}