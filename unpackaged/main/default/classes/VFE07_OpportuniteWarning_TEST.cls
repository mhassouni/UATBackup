/**
 * Test class for VFE07_OpportuniteWarning
 */
@isTest
private class VFE07_OpportuniteWarning_TEST {

    static testMethod void TestCompteWarning() {

        Bypass__c MyBypass = Utils_TestMethods.createBypass(UserInfo.getUserId());
        MyBypass.BypassValidationRules__c = true;
        MyByPass.BypassTriggers__c='AP01Opportunite;AP09Compte';
        insert MyBypass;
        
        Account Account1 = Utils_TestMethods.createAccount('Account1',null,null, Label.CPT_RecordTypeId_CompteClient);
        Account1.Statut__c = Label.CPT_Statut_Draft;
        Account1.ListeNoire__c = true;
            
        Account Account2 = Utils_TestMethods.createAccount('Account2',null,null, Label.CPT_RecordTypeId_CompteClient);
        Account2.Statut__c = Label.CPT_Statut_Draft;
        Account2.ListeNoire__c = true;
            
        Account Account3 = Utils_TestMethods.createAccount('Account3',null,null, Label.CPT_RecordTypeId_CompteClient);
        Account3.Statut__c = Label.CPT_Statut_Draft;
        Account3.ListeNoire__c = false;
        
        Account Account4 = Utils_TestMethods.createAccount('Account4',null,null, Label.CPT_RecordTypeId_CompteClient);
        Account4.Statut__c = Label.CPT_Statut_Draft;
        Account4.ListeNoire__c = false;
        
        Account Account5 = Utils_TestMethods.createAccount('Account5',null,null, Label.CPT_RecordTypeId_CompteClient);
        Account5.Statut__c = Label.CPT_Statut_Draft;
        Account5.ListeNoire__c = true;
        
        Account Account6 = Utils_TestMethods.createAccount('Account6',null,null, Label.CPT_RecordTypeId_CompteClient);
        Account6.Statut__c = Label.CPT_Statut_Draft;
        Account6.ListeNoire__c = false;
        
        Account Account7 = Utils_TestMethods.createAccount('Account7',null,null, Label.CPT_RecordTypeId_CompteClient);
        Account7.Statut__c = Label.CPT_Statut_Draft;
        Account7.ListeNoire__c = false;
        
        Account Account8 = Utils_TestMethods.createAccount('Account8',null,null, Label.CPT_RecordTypeId_CompteClient);
        Account8.Statut__c = Label.CPT_Statut_Draft;
        Account8.IDEulerHermes__c='test';
        Account8.Ligne1__c='test';
        Account8.CodePostal__c='test';
        Account8.Ville__c='test';
        Account8.Pays__c='France';
        Account8.ListeNoire__c = false;
        
        Account Account9 = Utils_TestMethods.createAccount('Account9',null,null, Label.CPT_RecordTypeId_CompteClient);
        Account9.Statut__c = Label.CPT_Statut_Draft;
        Account9.ListeNoire__c = false;
        
        insert new list<Account>{Account1,Account2,Account3,Account4,Account5,Account6,Account7,Account8,Account9};
        
        Opportunity Opportunity1 = Utils_TestMethods.createOpportunity('Opportunity1',Label.OPP_StageName_PropositionRemise,Date.newInstance(2016,9,1),Account1);
        Opportunity1.AccountId = Account1.Id;
        Opportunity1.DateClotureEffective__c = system.today();

        Opportunity Opportunity2 = Utils_TestMethods.createOpportunity('Opportunity2',Label.OPP_StageName_PropositionRemise,Date.newInstance(2016,9,1),Account2);
        Opportunity2.AccountId = Account2.Id;
        Opportunity2.DateClotureEffective__c = system.today();

        Opportunity Opportunity3 = Utils_TestMethods.createOpportunity('Opportunity3',Label.OPP_StageName_PropositionRemise,Date.newInstance(2016,9,1),Account3);
        Opportunity3.AccountId = Account3.Id;
        Opportunity3.DateClotureEffective__c = system.today();

        Opportunity Opportunity4 = Utils_TestMethods.createOpportunity('Opportunity4',Label.OPP_StageName_PropositionRemise,Date.newInstance(2016,9,1),Account4);
        Opportunity4.AccountId = Account4.Id;
        Opportunity4.DateClotureEffective__c = system.today();
        
        Opportunity Opportunity5 = Utils_TestMethods.createOpportunity('Opportunity5',Label.OPP_StageName_PropositionRemise,Date.newInstance(2016,9,1),Account5);
        Opportunity4.AccountId = Account5.Id;
        Opportunity4.DateClotureEffective__c = system.today();
        
        Opportunity Opportunity6 = Utils_TestMethods.createOpportunity('Opportunity6',Label.OPP_StageName_PropositionRemise,Date.newInstance(2016,9,1),Account6);
        Opportunity4.AccountId = Account6.Id;
        Opportunity4.DateClotureEffective__c = system.today();
        
        Opportunity Opportunity7 = Utils_TestMethods.createOpportunity('Opportunity7',Label.OPP_StageName_PropositionRemise,Date.newInstance(2016,9,1),Account7);
        Opportunity7.AccountId = Account7.Id;
        Opportunity7.DateClotureEffective__c = system.today();
        
        Opportunity Opportunity8 = Utils_TestMethods.createOpportunity('Opportunity8',Label.OPP_StageName_PropositionRemise,Date.newInstance(2016,9,1),Account8);
        Opportunity8.AccountId = Account8.Id;
        Opportunity8.DateClotureEffective__c = system.today();
        
        Opportunity Opportunity9 = Utils_TestMethods.createOpportunity('Opportunity9',Label.OPP_StageName_PropositionRemise,Date.newInstance(2016,9,1),Account9);
        Opportunity9.AccountId = Account9.Id;
        Opportunity9.DateClotureEffective__c = system.today();
        
        insert new list<Opportunity>{Opportunity1,Opportunity2,Opportunity3,Opportunity4,Opportunity5,Opportunity6,Opportunity7,Opportunity8,Opportunity9};
        
        ApexPages.StandardController controller = new ApexPages.StandardController(Opportunity1);
        VFE07_OpportuniteWarning r = new VFE07_OpportuniteWarning(controller);
        r.alert();
        
        ApexPages.StandardController controller2 = new ApexPages.StandardController(Opportunity2);
        VFE07_OpportuniteWarning r2 = new VFE07_OpportuniteWarning(controller2);
        r2.alert();
        
        ApexPages.StandardController controller3 = new ApexPages.StandardController(Opportunity3);
        VFE07_OpportuniteWarning r3 = new VFE07_OpportuniteWarning(controller3);
        r3.alert();
        
        ApexPages.StandardController controller4 = new ApexPages.StandardController(Opportunity4);
        VFE07_OpportuniteWarning r4 = new VFE07_OpportuniteWarning(controller4);
        r4.alert();
        
        ApexPages.StandardController controller5 = new ApexPages.StandardController(Opportunity5);
        VFE07_OpportuniteWarning r5 = new VFE07_OpportuniteWarning(controller5);
        r5.alert();
        
        ApexPages.StandardController controller6 = new ApexPages.StandardController(Opportunity6);
        VFE07_OpportuniteWarning r6 = new VFE07_OpportuniteWarning(controller6);
        r6.alert();
        
        ApexPages.StandardController controller7 = new ApexPages.StandardController(Opportunity7);
        VFE07_OpportuniteWarning r7 = new VFE07_OpportuniteWarning(controller7);
        r7.alert();
        
        ApexPages.StandardController controller8 = new ApexPages.StandardController(Opportunity8);
        VFE07_OpportuniteWarning r8 = new VFE07_OpportuniteWarning(controller8);
        r8.alert();
        
        ApexPages.StandardController controller9 = new ApexPages.StandardController(Opportunity9);
        VFE07_OpportuniteWarning r9 = new VFE07_OpportuniteWarning(controller9);
        r9.alert();
    }
}