/**
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class VFE26_PiecesJointes_TEST{

    static testMethod void TestNewNPJ() {

        Bypass__c MyBypass = Utils_TestMethods.createBypass(UserInfo.getUserId());
        MyBypass.BypassValidationRules__c = true;
        MyBypass.BypassTriggers__c = 'AP09Compte,AP03Opportunite,AP01Opportunite';
        insert MyBypass;
        
        Profile p = [SELECT Id FROM Profile WHERE Name=: Label.USR_ProfileName_PFAdministrateurSysteme][0];
        User testUser1 = Utils_TestMethods.createUser('VFE26Usr','VFE26Usr',string.valueof(p.id));
        insert testUser1;

        Piece_Jointe__c NPJ1 = new Piece_Jointe__c();
        insert NPJ1;
        
        Attachment TestAttachment1= new Attachment();
        TestAttachment1.ParentId = NPJ1.Id;
        TestAttachment1.Name= 'TestAttachment1';
        TestAttachment1.Body= Blob.valueof('BLA');        
        insert TestAttachment1;
        
        Piece_Jointe__Share NPJShare1 = new Piece_Jointe__Share();
        NPJShare1.ParentId = NPJ1.Id;
        NPJShare1.UserOrGroupId = testUser1.Id;
        NPJShare1.accessLevel= 'Read';
        insert NPJShare1;
        
        Account Account1 = Utils_TestMethods.createAccount('Account1',null,null, Label.CPT_RecordTypeId_CompteClient); 
        Account1.PaysRegionPF__c = 'PFUK';
        Account1.AgencePF__c = '113 - LEEDS';
        insert Account1;
            
        Opportunity Opportunity1 = Utils_TestMethods.createOpportunity('Nouvelle Opportunité 1',Label.OPP_StageName_OpportuniteCreee,system.today(),Account1);
        //Opportunity1.AccountId = Account1.Id;
        Opportunity1.PaysRegionPF__c = 'PFUK';
        Opportunity1.AgencePF__c = '113 - LEEDS';
        insert Opportunity1;
        
        ApexPages.StandardController controller;
        ApexPages.currentPage().getparameters().put('Id', NPJ1.Id);
        VFE26_PiecesJointes r = new VFE26_PiecesJointes (controller);
        r.Partage();
        r.Redirect();
        
        NPJ1.Opportunite__c = Opportunity1.Id;
        NPJ1.TECH_AccesUtilisateurs__c = UserInfo.getUserId()+'-';
        update NPJ1;
        r = new VFE26_PiecesJointes (controller);
        r.Partage();
        r.Redirect();
        
        r = new VFE26_PiecesJointes (controller);
        r.Redirect();
        
    }
}