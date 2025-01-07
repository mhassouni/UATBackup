/**
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class VFE13_ContactRole_TEST{

    static testMethod void TestContactRole() {

    Bypass__c MyBypass = Utils_TestMethods.createBypass(UserInfo.getUserId());
    MyBypass.BypassValidationRules__c = true;
    MyBypass.BypassTriggers__c = 'AP09Compte';
    insert MyBypass;
    
    Account Account1 = Utils_TestMethods.createAccount('Account1',null,null, Label.CPT_RecordTypeId_CompteClient); 
    Account1.Statut__c = Label.CPT_Statut_Valide;
    insert Account1;
    
    Contact Contact1 = Utils_TestMethods.createContact('Contact1',Account1.Id);
    insert Contact1;
    
    Opportunity Opportunity1= Utils_TestMethods.createOpportunity('OPP1',Label.OPP_StageName_PropositionRemise,system.today(),Account1);
    Opportunity1.AccountId = Account1.Id;
    insert Opportunity1;
    
    RoleContact__c rc = Utils_TestMethods.createRoleContact(Contact1.Id, Opportunity1.Id, Account1.Id);
    
    ApexPages.StandardController controller = new ApexPages.StandardController(rc);
    VFE13_ContactRole r = new VFE13_ContactRole(controller);
    r.selectContact();
    r.saveContact();

    RoleContact__c rc2 = Utils_TestMethods.createRoleContact(Contact1.Id, Opportunity1.Id, Account1.Id);    
    ApexPages.StandardController controller2 = new ApexPages.StandardController(rc2);
    VFE13_ContactRole r2 = new VFE13_ContactRole(controller2);
    r2.selectContact();
    r2.saveAndNewContact();

    RoleContact__c rc3 = Utils_TestMethods.createRoleContact(Contact1.Id, Opportunity1.Id, Account1.Id);    
    insert rc3;    
    ApexPages.StandardController controller3 = new ApexPages.StandardController(rc3);
    VFE13_ContactRole r3 = new VFE13_ContactRole(controller3);
    r3.selectContact();
    r3.saveContact();
    r3.saveAndNewContact();


    }
}