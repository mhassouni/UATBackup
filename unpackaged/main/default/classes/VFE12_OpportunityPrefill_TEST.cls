/**
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class VFE12_OpportunityPrefill_TEST{

    static testMethod void TestOpportunityPrefill() {

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
    
    ApexPages.StandardController controller;
    VFE12_OpportunityPrefill r = new VFE12_OpportunityPrefill(controller);
    ApexPages.currentPage().getparameters().put('accid', Account1.Id);
    ApexPages.currentPage().getparameters().put('parentOppId', Opportunity1.Id);
    r.prefillOpportunity();
    r.prefillChildOpportunity();
    boolean sf1 = r.isBrowser;
    r.theme = label.VFP_Theme4t_SF1;
    boolean sf2 = r.isBrowser;
    }
}